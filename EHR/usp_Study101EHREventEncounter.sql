IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study101EHREventEncounter]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101EHREventEncounter]
GO	
/**************************************************************************
Created On : 5/24/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study101EHREventEncounter]
Functional : ITMI SSIS for Insert and Update for EHR Event Encounter
Purpose : Import of study 101, Events, to be part of the diagnosis for the Subjects, this is from export from Epic
History : Created on 5/24/2014
*************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC itmidw.[usp_Study101EHREventEncounter]
--testing update and delete
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study101EHREventEncounter]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101EHREventEncounter][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.[usp_Study101EHREventEncounter]...'

--***********************
--*****prep**************
--***********************

--DROP TABLES

IF OBJECT_ID('tempdb..#sourceSubject') IS NOT NULL
DROP TABLE #encounter

IF OBJECT_ID('tempdb..#encounterLab') IS NOT NULL
DROP TABLE #encounterLab

IF OBJECT_ID('tempdb..#encounter') IS NOT NULL
DROP Table #encounter

IF OBJECT_ID('tempdb..#encounterIe3') IS NOT NULL
DROP Table #encounterIe3

select 
	sub.subjectID
	, csn as headerMatchID
	, COUNT(*) as DiagnosisCnt
	, MIN(admit_date) as minAdminDate
	, MAX(disch_date) as maxAdminDate
	, ROW_NUMBER() OVER(PARTITION BY subjectID ORDER BY subjectID,max(admit_date))diagencounterOrder
	, NULL as encounterType
INTO #encounter
FROM [EPIC].[epicMOMDiags] Diag 
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
GROUP BY sub.subjectID, csn

--find counter for date

select 
	sub.subjectID
	, acct  as [sourceSystemEventID]
	, COUNT(*) as DiagnosisCnt
	, MIN(admit_dt) as minAdminDate
	, MAX(disch_dt) as maxAdminDate
	, ROW_NUMBER() OVER(ORDER BY subjectID,max(admit_dt) ) diagencounterOrder
	, sub.studyID
	, enc_type as encounterType
INTO #encounterIe3
FROM [EPIC].epicMOMDiagsI3E Diag 
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
GROUP BY sub.subjectID, acct, sub.studyID,enc_type
--truncate table itmidw.[tblEHREventEncounter]

INSERT INTO itmidw.[tblEHREventEncounter](eventID , sourcesystemEventID    , subjectID , EncounterType, encounterStartDate , encounterEndDate , encounterLengthInDays 
, encounterOrder , diagnosisCnt , [orgSourceSystemID] , [createDate], [createdBy]   )
select  DISTINCT
	eve.eventID
	, eve.sourceSystemEventID
	, Eve.subjectID
	, NULL as encounterType --do not have for Epic data  (yet)
	, e.minAdminDate
	, e.maxAdminDate
	, DATEDIFF(dd,e.minAdminDate, e.maxAdminDate) as encounterLengthInDays
	, e.diagencounterOrder
	, e.DiagnosisCnt encounterDiagnosisCnt
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
	, GETDATE() AS CreateDate
	, 'usp_Study101EHREventEncounter'  AS createdBy	
FROM itmidw.tblEvent eve
	INNER JOIN #encounter e
		on e.headerMatchID = eve.sourceSystemEventID


INSERT INTO itmidw.[tblEHREventEncounter](eventID , sourcesystemEventID    , subjectID , encounterType,encounterStartDate , encounterEndDate , encounterLengthInDays 
, encounterOrder , diagnosisCnt , [orgSourceSystemID] , [createDate], [createdBy]   )
select  DISTINCT
	eve.eventID
	, eve.sourceSystemEventID
	, Eve.subjectID
	, e.encounterType
	, e.minAdminDate
	, e.maxAdminDate
	, DATEDIFF(dd,e.minAdminDate, e.maxAdminDate) as encounterLengthInDays
	, e.diagencounterOrder
	, e.DiagnosisCnt encounterDiagnosisCnt
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
	, GETDATE() AS CreateDate
	, 'usp_Study101EHREventEncounter'  AS createdBy	
FROM itmidw.tblEvent eve
	INNER JOIN #encounterIe3 e
		on e.[sourceSystemEventID] = eve.sourceSystemEventID



--*****************
--*****Diagnosis***
--*****************

INSERT INTO itmidw.tblEHRDiagnosis (sourceSystemDiagnosisID , subjectID , EHREncounterID , diagnosisPriority 
, diagnosisName  , diagnosisICD9  , [orgSourceSystemID], [createDate] , [createdBy]  )
select  DISTINCT
	CONVERT(VARCHAR(100),sub.subjectID ) + '-' + diag.diag_id + '-' + diag.diag_priority as sourceSystemDiagnosisID
	, sub.subjectID
	, ee.[EHREncounterID]
	, diag.diag_Priority as encounterDiagnosisPriority
	, diag.diag_name as encounterDiagnosisName
	, diag.diag_ICD9 as encounterICD9	
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
	, GETDATE() AS CreateDate
	, 'usp_Study101EHREventEncounter'  AS createdBy	
FROM [EPIC].[epicMOMDiags] Diag 
	INNER JOIN itmidw.tblEHREventEncounter ee
		ON ee.sourcesystemEventID = diag.csn --using as sourceSystemEventID \ headerMatchID 
			and ee.subjectID = diag.matchSubjectID
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
	INNER JOIN #encounter e
		on e.headerMatchID = diag.csn
			and e.subjectID = sub.subjectID


INSERT INTO itmidw.tblEHRDiagnosis (sourceSystemDiagnosisID , subjectID , EHREncounterID , diagnosisPriority 
, diagnosisName  , diagnosisICD9  , [orgSourceSystemID], [createDate] , [createdBy]  )

select  DISTINCT
	CONVERT(VARCHAR(100),sub.subjectID ) + '-' + diag.icd9 + '-' + diag.diag_priority as sourceSystemDiagnosisID
	, sub.subjectID
	, ee.[EHREncounterID]
	, diag.diag_Priority as encounterDiagnosisPriority
	, diag.diag_desc as encounterDiagnosisName
	, diag.ICD9 as encounterICD9	
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
	, GETDATE() AS CreateDate
	, 'usp_Study101EHREventEncounter'  AS createdBy	
--select *
FROM [EPIC].[epicMOMDiagsI3E] Diag 
	INNER JOIN itmidw.tblEHREventEncounter ee
		ON ee.sourcesystemEventID = diag.acct --using as sourceSystemEventID \ headerMatchID 
			and ee.subjectID = diag.matchSubjectID
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
	INNER JOIN #encounterIe3 e
		on e.[sourceSystemEventID] =  diag.acct
			and e.subjectID = sub.subjectID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'
--, eventID 
--, sourcesystemEventID    
--, subjectID 
--, encounterStartDate 
--, encounterEndDate 
--, encounterLengthInDays 
--, encounterOrder 
--, diagnosisCnt 
--, [orgSourceSystemID] 
--, [createDate]
--, [createdBy]   

--, sourceSystemDiagnosisID 
--	, subjectID 
--	, EHREncounterID 
--	, diagnosisPriority 
--	, diagnosisName  
--	, diagnosisICD9  
--	, [orgSourceSystemID]
--	, [createDate] 
--	, [createdBy]  

END
