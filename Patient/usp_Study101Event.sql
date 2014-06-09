IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study101Event]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101Event]
GO	
/**************************************************************************
Created On : 4/1/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study101Event]
Functional : ITMI SSIS for Insert and Update for study 101 subject Identifier
Purpose : Import of study 101, this shoudld be for MRN and other idnetifiers that need isolated
History : Created on 4/1/2014
*************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101Event]
--testing update and delete
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study101Event]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101Event][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.[usp_Study101Event]...'
/*
IF OBJECT_ID('tempdb..#DiagInsert') IS NOT NULL
DROP TABLE #DiagInsert 

IF OBJECT_ID('tempdb..#encounterIe3') IS NOT NULL
DROP TABLE #encounterIe3

IF OBJECT_ID('tempdb..#encounter') IS NOT NULL
DROP TABLE #encounter 

--*************************************
--******************101****************
--*************************************
 

INSERT INTO itmidw.[tblEvent]([sourceSystemEventID],[eventType],[eventName],[studyID],[orgSourceSystemID],[createDate],[createdBy], SubjectID)
SELECT 
	'EDC101Father: ' + CONVERT(VARCHAR(100), a.pkid)
	, 'Clinical Report Form'
	, 'Father EDC Form'
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID like '%101%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
	, GETDATE()
	, 'usp_Study101Event'  
	, sub.subjectID
FROM  itmistaging.[spoint101].[EDC101Father] a --UNION ALL
	INNER JOIN tblsubject sub
		ON sub.sourceSystemSubjectID = [Fathers Study ID]

INSERT INTO itmidw.[tblEvent]([sourceSystemEventID],[eventType],[eventName],[studyID],[orgSourceSystemID],[createDate],[createdBy], SubjectID)
SELECT 
	'EDC101Mother: ' + CONVERT(VARCHAR(100), a.pkid)
	, 'Clinical Report Form', 'Mother EDC Form'
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID like '%101%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
	, GETDATE(), 
'usp_Study101Event'  ,sub.subjectID
FROM  itmistaging.[spoint101].[EDC101Mother] a --UNION ALL
	INNER JOIN tblsubject sub
		ON sub.sourceSystemSubjectID = [Mothers Study ID]

INSERT INTO itmidw.[tblEvent]([sourceSystemEventID],[eventType],[eventName],[studyID],[orgSourceSystemID],[createDate],[createdBy], SubjectID)
SELECT 
	'EDC101NewBorn: ' + CONVERT(VARCHAR(100), a.pkid)
	, 'Clinical Report Form'
	, 'Newborn EDC Form'
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID like '%101%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
	, GETDATE()
	, 'usp_Study101Event'  
	,sub.subjectID
FROM  itmistaging.[spoint101].[EDC101NEWBORN] a --UNION ALL
	INNER JOIN tblsubject sub
		ON sub.sourceSystemSubjectID = [Infants Study ID]

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

--EHR Encounter Events
--find counter for date


select 
	sub.subjectID
	, csn as [sourceSystemEventID]
	, COUNT(*) as DiagnosisCnt
	, MIN(admit_date) as minAdminDate
	, MAX(disch_date) as maxAdminDate
	, ROW_NUMBER() OVER(PARTITION BY subjectID ORDER BY subjectID,max(admit_date))diagencounterOrder
	, sub.studyID
INTO #encounter
FROM [EPIC].[epicMOMDiags] Diag 
	INNER join itmidw.tblsubject sub
		on sub.subjectID = diag.matchsubjectID
GROUP BY sub.subjectID, csn, sub.studyID

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

--delete from itmidw.[tblEvent] where eventType = 'EHR Event'

INSERT INTO itmidw.[tblEvent]([sourceSystemEventID],[eventType],[eventName],[studyID],[orgSourceSystemID],[createDate],[createdBy], SubjectID)
SELECT 
	enc.[sourceSystemEventID] 
	, 'EHR Event'
	, 'EHR Event - EPIC Encounter'
	, enc.studyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
	, GETDATE()
	, 'usp_Study101Event'  
	, enc.SubjectID
FROM #encounter enc
UNION 
SELECT 
	enc.[sourceSystemEventID] 
	, 'EHR Event'
	, 'EHR Event - I3E Encounter - ' + CONVERT(Varchar(100), enc.encounterType) 
	, enc.studyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
	, GETDATE()
	, 'usp_Study101Event'  
	, enc.SubjectID
FROM #encounterIe3 enc
*/
END