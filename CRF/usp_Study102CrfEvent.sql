IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[itmidw].[usp_Study102CrfEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study102CrfEvent]
GO
/**************************************************************************
Created On : 3/29/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study102CrfEvent]
Functional : ITMI SSIS for Insert and Update for study 102 tblCrfEvent
 Which is attaching subjects to other entities, including family, original site WHERE the subject was enrolled.
History : Created on 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC itmidw.[usp_Study102CrfEvent]
--TRUNCATe table ITMIDW.[dbo].[tblOrganization] 
--SELECT * FROM ITMIDW.[dbo].[tblOrganization] 

**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study102CrfEvent]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102CrfEvent][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study102CrfEvent]...'

--*************************************
--******************102****************
--*************************************
--drop table
IF OBJECT_ID('tempdb..#sourceCrfEvent') IS NOT NULL
DROP TABLE #sourceCrfEvent


SELECT DISTINCT
           CONVERT(Varchar(100),deets.recordID) AS [sourceSystemCrfEventID]
           ,NULL AS [parentCrfEventID]
           ,crf.crfID AS [crfID]
           ,deets.itmiFormName AS [crfType]
           ,crf.crfID AS [crfVersionID] --at this time the ID' are the same **Change control** if now versions of the forms need to be tracked.
           ,subject.subjectID AS [subjectID]
           ,NULL AS [crfStatus]
           ,MAX(dbo.dateonly(RaveCreatedDateTime)) AS  [updatedDate]
           ,MIN(dbo.dateonly(revieweddatetime))  AS [completedDate]
           , (SELECT studyID FROM itmidw.tblstudy WHERE [studyShortID] like '%102%') AS StudyId
           ,NULL AS [eventCrfUUID]
           ,(SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
           ,GETDATE() [createDate]
           ,'usp_Study102CrfEvent' AS [createdBy]
INTO #sourceCrfEvent
FROM difzDBCopy.PatientDataPointDetail AS deets
	INNER JOIN itmidw.tblSubject subject
		ON subject.subjectId = deets.itmidwSubjectID
	INNER JOIN itmidw.tblCrf crf
		ON crf.crfName = deets.itmiFormName
WHERE deets.isactive = 1	
	and subject.studyID = (SELECT studyID FROM itmidw.tblstudy WHERE [studyShortID] like '%102%')
GROUP BY 
      deets.recordID
      ,crf.crfID 
      ,deets.itmiFormName
      ,subject.subjectID


--Surveys
--baby6
INSERT INTO #sourceCrfEvent ([sourceSystemCrfEventID], [parentCrfEventID], [crfID], [crfType], [crfVersionID], [subjectID], [crfStatus], [updatedDate], [completedDate], [StudyId], [eventCrfUUID], [orgSourceSystemID], [createDate], [createdBy])
SELECT DISTINCT
           --[sourceSystemCrfEventID]
		ss.[family ID]
           --, [parentCrfEventID]
		, NULL
           --, [crfID]
		, (Select crfID from itmidw.tblCrf crf where crf.crfName = 'Rave: 6 Month Survery for Baby :102')
           --, [crfType]
		, 'Survey'
           --, [crfVersionID]
		,(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '6MonthBaby: v1')
           --, [subjectID]
		, sub.subjectID
           --, [crfStatus]
		, NULL-- ss.[survey status]
           --, [updatedDate]
		, ss.[date completed]
           --, [completedDate]
		, ss.[date completed]
           --, [StudyId]
		, (select study.studyID FROM itmidw.tblstudy study where study.studyShortID = '102')
           --, [eventCrfUUID]
		, NULL
           --, [orgSourceSystemID]
        , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
		, GETDATE() [createDate]
		, 'usp_Study102CrfEvent' AS [createdBy]
--SELECT *
FROM etl.SurveyBaby6_Stage ss
	INNER JOIN itmidw.tblsubject sub
		on sub.sourceSystemIDLabel = ss.[family ID]

--mom6
INSERT INTO #sourceCrfEvent ([sourceSystemCrfEventID], [parentCrfEventID], [crfID], [crfType], [crfVersionID], [subjectID], [crfStatus], [updatedDate], [completedDate], [StudyId], [eventCrfUUID], [orgSourceSystemID], [createDate], [createdBy])
SELECT DISTINCT
           --[sourceSystemCrfEventID]
		ss.[family ID]
           --, [parentCrfEventID]
		, NULL
           --, [crfID]
		, (Select crfID from itmidw.tblCrf crf where crf.crfName = 'Rave: 6 Month Survery for Mom :102')
           --, [crfType]
		, 'Survey'
           --, [crfVersionID]
		,(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '6MonthBaby: v1')
           --, [subjectID]
		, sub.subjectID
           --, [crfStatus]
		, NULL-- ss.[survey status]
           --, [updatedDate]
		, ss.[date completed]
           --, [completedDate]
		, ss.[date completed]
           --, [StudyId]
		, (select study.studyID FROM itmidw.tblstudy study where study.studyShortID = '102')
           --, [eventCrfUUID]
		, NULL
           --, [orgSourceSystemID]
        , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
		, GETDATE() [createDate]
		, 'usp_Study102CrfEvent' AS [createdBy]
--SELECT *
FROM etl.SurveyMom6_Stage ss
	INNER JOIN itmidw.tblsubject sub
		on sub.sourceSystemIDLabel = ss.[family ID]

--baby12
INSERT INTO #sourceCrfEvent ([sourceSystemCrfEventID], [parentCrfEventID], [crfID], [crfType], [crfVersionID], [subjectID], [crfStatus], [updatedDate], [completedDate], [StudyId], [eventCrfUUID], [orgSourceSystemID], [createDate], [createdBy])
SELECT DISTINCT
           --[sourceSystemCrfEventID]
		ss.[family ID]
           --, [parentCrfEventID]
		, NULL
           --, [crfID]
		, (Select crfID from itmidw.tblCrf crf where crf.crfName = 'Rave: 12 Month Survery for Baby :102')
           --, [crfType]
		, 'Survey'
           --, [crfVersionID]
		,(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '6MonthBaby: v1')
           --, [subjectID]
		, sub.subjectID
           --, [crfStatus]
		, NULL-- ss.[survey status]
           --, [updatedDate]
		, ss.[date completed]
           --, [completedDate]
		, ss.[date completed]
           --, [StudyId]
		, (select study.studyID FROM itmidw.tblstudy study where study.studyShortID = '102')
           --, [eventCrfUUID]
		, NULL
           --, [orgSourceSystemID]
        , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
		, GETDATE() [createDate]
		, 'usp_Study102CrfEvent' AS [createdBy]
--SELECT *
FROM etl.SurveyBaby12_Stage ss
	INNER JOIN itmidw.tblsubject sub
		on sub.sourceSystemIDLabel = ss.[family ID]

--mom12
INSERT INTO #sourceCrfEvent ([sourceSystemCrfEventID], [parentCrfEventID], [crfID], [crfType], [crfVersionID], [subjectID], [crfStatus], [updatedDate], [completedDate], [StudyId], [eventCrfUUID], [orgSourceSystemID], [createDate], [createdBy])
SELECT DISTINCT
           --[sourceSystemCrfEventID]
		ss.[family ID]
           --, [parentCrfEventID]
		, NULL
           --, [crfID]
		, (Select crfID from itmidw.tblCrf crf where crf.crfName = 'Rave: 12 Month Survery for Mom :102')
           --, [crfType]
		, 'Survey'
           --, [crfVersionID]
		,(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '6MonthBaby: v1')
           --, [subjectID]
		, sub.subjectID
           --, [crfStatus]
		, NULL-- ss.[survey status]
           --, [updatedDate]
		, ss.[date completed]
           --, [completedDate]
		, ss.[date completed]
           --, [StudyId]
		, (select study.studyID FROM itmidw.tblstudy study where study.studyShortID = '102')
           --, [eventCrfUUID]
		, NULL
           --, [orgSourceSystemID]
        , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
		, GETDATE() [createDate]
		, 'usp_Study102CrfEvent' AS [createdBy]
--SELECT *
FROM etl.SurveyMom12_Stage ss
	INNER JOIN itmidw.tblsubject sub
		on sub.sourceSystemIDLabel = ss.[family ID]

--baby18
INSERT INTO #sourceCrfEvent ([sourceSystemCrfEventID], [parentCrfEventID], [crfID], [crfType], [crfVersionID], [subjectID], [crfStatus], [updatedDate], [completedDate], [StudyId], [eventCrfUUID], [orgSourceSystemID], [createDate], [createdBy])
SELECT DISTINCT
           --[sourceSystemCrfEventID]
		ss.[family ID]
           --, [parentCrfEventID]
		, NULL
           --, [crfID]
		, (Select crfID from itmidw.tblCrf crf where crf.crfName = 'Rave: 18 Month Survery for Baby :102')
           --, [crfType]
		, 'Survey'
           --, [crfVersionID]
		,(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '6MonthBaby: v1')
           --, [subjectID]
		, sub.subjectID
           --, [crfStatus]
		, NULL-- ss.[survey status]
           --, [updatedDate]
		, ss.[date completed]
           --, [completedDate]
		, ss.[date completed]
           --, [StudyId]
		, (select study.studyID FROM itmidw.tblstudy study where study.studyShortID = '102')
           --, [eventCrfUUID]
		, NULL
           --, [orgSourceSystemID]
        , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
		, GETDATE() [createDate]
		, 'usp_Study102CrfEvent' AS [createdBy]
--SELECT *
FROM etl.SurveyBaby18_Stage ss
	INNER JOIN itmidw.tblsubject sub
		on sub.sourceSystemIDLabel = ss.[family ID]


INSERT INTO #sourceCrfEvent ([sourceSystemCrfEventID], [parentCrfEventID], [crfID], [crfType], [crfVersionID], [subjectID], [crfStatus], [updatedDate], [completedDate], [StudyId], [eventCrfUUID], [orgSourceSystemID], [createDate], [createdBy])
SELECT DISTINCT
           --[sourceSystemCrfEventID]
		ss.[family ID]
           --, [parentCrfEventID]
		, NULL
           --, [crfID]
		, (Select crfID from itmidw.tblCrf crf where crf.crfName = 'Rave: 18 Month Survery for Mom :102')
           --, [crfType]
		, 'Survey'
           --, [crfVersionID]
		,(SELECT v.crfVersionID from itmidw.tblCrfVersion v where v.crfVersionName = '6MonthBaby: v1')
           --, [subjectID]
		, sub.subjectID
           --, [crfStatus]
		, NULL-- ss.[survey status]
           --, [updatedDate]
		, ss.[date completed]
           --, [completedDate]
		, ss.[date completed]
           --, [StudyId]
		, (select study.studyID FROM itmidw.tblstudy study where study.studyShortID = '102')
           --, [eventCrfUUID]
		, NULL
           --, [orgSourceSystemID]
        , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS [orgSourceSystemID]
		, GETDATE() [createDate]
		, 'usp_Study102CrfEvent' AS [createdBy]
--SELECT *
FROM etl.SurveyMom18_Stage ss
	INNER JOIN itmidw.tblsubject sub
		on sub.sourceSystemIDLabel = ss.[family ID]



--Slowly changing dimension
MERGE  ITMIDW.[tblCrfEvent] AS targetCrfEvent
USING #sourceCrfEvent ss
	ON targetCrfEvent.[sourceSystemCrfEventID] = ss.[sourceSystemCrfEventID]
		and targetCrfEvent.[orgSourceSystemID] = ss.[orgSourceSystemID]
		and targetCrfEvent.[crfId] = ss.[crfId]
  WHEN MATCHED
	AND (
           ss.[crfID] <>  targetCrfEvent.[crfID] OR
           ss.[crfType] <> targetCrfEvent.[crfType] OR 
           ss.[crfVersionID] <>  targetCrfEvent.[crfVersionID] OR 
           ss.[subjectID] <> targetCrfEvent.[subjectID] OR 
           ss.[crfStatus] <> targetCrfEvent.[crfStatus] OR 
           ss.[updatedDate] <> targetCrfEvent.[updatedDate] OR 
           ss.[completedDate] <> targetCrfEvent.[completedDate] OR 
           ss.[studyID] <> targetCrfEvent.[studyID] OR 
           ss.[eventCrfUUID] <> targetCrfEvent.[eventCrfUUID] OR 
		 ss.[orgSourceSystemID] <> targetCrfEvent.[orgSourceSystemID] OR  
		ss.[createDate] <> targetCrfEvent.[createDate] OR
		ss.[createdBy] <> targetCrfEvent.[createdBy] 
	)
THEN UPDATE SET
           [crfID]  = ss.[crfID]
           ,[crfType] =ss.[crfType] 
           ,[crfVersionID]=   ss.[crfVersionID] 
           ,[subjectID] = ss.[subjectID] 
           ,[crfStatus]= ss.[crfStatus] 
           ,[updatedDate] = ss.[updatedDate] 
           ,[completedDate] = ss.[completedDate] 
           ,[studyID] = ss.[studyID] 
           ,[eventCrfUUID] = ss.[eventCrfUUID] 
	, [orgSourceSystemID] = ss.[orgSourceSystemID]
	, [createDate] = ss.[createDate] 
	, [createdBy] = ss.[createdBy] 
WHEN NOT MATCHED THEN

INSERT (    [sourceSystemCrfEventID]
			, [crfID]
           ,[crfType]
           ,[crfVersionID]
           ,[subjectID]
           ,[crfStatus]
           ,[updatedDate]
           ,[completedDate]
           ,[studyID]
           ,[eventCrfUUID]
		,[orgSourceSystemID],[createDate],[createdBy])
VALUES (ss.[sourceSystemCrfEventID]
, ss.[crfID]
           ,ss.[crfType]
           ,ss.[crfVersionID]
           ,ss.[subjectID]
           ,ss.[crfStatus]
           ,ss.[updatedDate]
           ,ss.[completedDate]
           ,ss.[studyID]
           ,ss.[eventCrfUUID]
			,ss.[orgSourceSystemID],ss.[createDate],ss.[createdBy]);

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'


END



