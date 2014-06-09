IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[itmidw].[usp_Study102SubjectIdentifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [itmidw].[usp_Study102SubjectIdentifier]
GO
/**************************************************************************
Created ON : 3/17/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study102SubjectIdentifier]
Functional : ITMI SSIS for Insert AND Update for study 102 subjects Identifiers
 forms, taking the distinct list of SubjectID's AND making an insert.
History : Created ON 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102SubjectIdentifier]
--TRUNCATe table ITMIDW.[dbo].[tblSubjectIdentifer] 
--select * FROM ITMIDW.[dbo].[tblSubjectIdentifer]  order by subjectID, subjectidentifiertype
update ITMIDW.[dbo].[tblSubjectIdentifer]   set subjectIdentifier  = 'memaw' where subjectID = 6626
select * FROM ITMIDW.[dbo].[tblSubjectIdentifer]  where subjectID = 6626
delete from ITMIDW.[dbo].[tblSubjectIdentifer]  where subjectID = 6621
select * FROM ITMIDW.[dbo].[tblSubjectIdentifer]  where subjectID = 6621
**************************************************************************/
CREATE PROCEDURE [itmidw].[usp_Study102SubjectIdentifier]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102SubjectIdentifier][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [itmidw].[usp_Study102SubjectIdentifier]...'

--*************************************
--******************102****************
--*************************************
--drop table
IF OBJECT_ID('tempdb..#sourceSubjectIdentifier') IS NOT NULL
DROP TABLE #sourceSubjectIdentifier  

--UUID from DIFZ
SELECT 
           sub.subjectID AS [subjectID]
           , CONVERT(VARCHAR(100),Participant.ParticipantID)  AS [subjectIdentifier]
           , 'Source System DB ID' AS [subjectIdentifierType]
		   , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
           , GETDATE()[createDate]
           , 'usp_Study102SubjectIdentifier' AS [createdBy]
INTO #sourceSubjectIdentifier
	FROM difzDBcopy.Participant AS Participant
		INNER JOIN itmidw.tblSubject sub
			ON CONVERT(VARCHAR(100),sub.[sourceSystemSubjectID]) = CONVERT(VARCHAR(100),Participant.participantID)
				AND sub.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') 
	WHERE participant.isActive = 1

--Family ID - ITMI Specific

INSERT INTO #sourceSubjectIdentifier ([subjectID],[subjectIdentifier],[subjectIdentifierType],[orgSourceSystemID],[createDate],[createdBy])
SELECT 
           sub.subjectID AS [subjectID]
           , sub.sourceSystemIDLabel AS [subjectIdentifier]
           , 'ITMI Subject ID' AS [subjectIdentifierType]
           , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
           , GETDATE()[createDate]
           , 'usp_Study102SubjectIdentifier' AS [createdBy]
	FROM difzDBcopy.Participant AS Participant
		INNER JOIN itmidw.tblSubject sub
			ON CONVERT(VARCHAR(100),sub.[sourceSystemSubjectID]) = CONVERT(VARCHAR(100),Participant.participantID)
				AND sub.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') 
	WHERE participant.isActive = 1

INSERT INTO #sourceSubjectIdentifier ([subjectID],[subjectIdentifier],[subjectIdentifierType],[orgSourceSystemID],[createDate],[createdBy])
SELECT 
           sub.subjectID AS [subjectID]
           , participant.medicalRecordNumber AS [subjectIdentifier]
           , 'MRN' AS [subjectIdentifierType]
           , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
           , GETDATE()[createDate]
           , 'usp_Study102SubjectIdentifier' AS [createdBy]
	FROM difzDBcopy.Participant AS Participant
		INNER JOIN itmidw.tblSubject sub
			ON CONVERT(VARCHAR(100),sub.[sourceSystemSubjectID]) = CONVERT(VARCHAR(100),Participant.participantID)
				AND sub.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') 
	WHERE participant.isActive = 1
		AND participant.medicalRecordNumber IS NOT NULL

		
--Slowly changing dimension
MERGE  ITMIDW.[tblSubjectIdentifer] AS targetSubject
USING #sourceSubjectIdentifier ss
	ON targetSubject.subjectID = ss.subjectID
		AND targetSubject.subjectIdentifierType = ss.subjectIdentifierType
WHEN MATCHED
	AND (
		ss.[subjectIdentifier] <> targetSubject.[subjectIdentifier] OR
		ss.[orgSourceSystemID] <> targetSubject.[orgSourceSystemID] OR  
		ss.[createDate] <> targetSubject.[createDate] OR
		ss.[createdBy] <> targetSubject.[createdBy] 
	)
THEN UPDATE SET
	 [subjectIdentifier] = ss.[subjectIdentifier]
	, [orgSourceSystemID] = ss.[orgSourceSystemID]
	, [createDate] = ss.[createDate] 
	, [createdBy] = ss.[createdBy] 
WHEN NOT MATCHED THEN

INSERT ([subjectID],[subjectIdentifier],[subjectIdentifierType],[orgSourceSystemID],[createDate],[createdBy])
VALUES (ss.[subjectID],ss.[subjectIdentifier],ss.[subjectIdentifierType],ss.[orgSourceSystemID],ss.[createDate],ss.[createdBy]);

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

END


