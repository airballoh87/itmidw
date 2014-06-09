IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Study102Subject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Study102Subject]
GO
/**************************************************************************
Created ON : 3/17/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study102Subject]
Functional : ITMI SSIS for Insert and Update for study 102 subjects
Purpose : Import of study 101 subjects from data difz schema for all forms, taking the distinct list of SubjectID's and making an insert.
History : Created ON 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102Subject]
--checking both delete and insert component of slowing changing dimension
DELETE FROM  tblsubject where sourceSystemSubjectID = '102-00250-02'
SELECT * FROM  tblsubject where sourceSystemSubjectID = '102-00250-02'
SELECT * FROM  tblsubject where subjectID = '13121'
UPDATE tblsubject set createdby = 'boo..' where subjectID = '13121'

**************************************************************************/
CREATE PROCEDURE [dbo].[usp_Study102Subject]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102Subject][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study102Subject]...'

--*************************************
--******************102****************
--*************************************
--drop table
IF OBJECT_ID('tempdb..#sourceSubject') IS NOT NULL
DROP TABLE #sourceSubject  


SELECT 
	CONVERT(VARCHAR(50),Participant.ParticipantID) AS [sourceSystemSubjectID]
	, CONVERT(VARCHAR(50),subject.subjectNumber+'-' + participant.participantIdentifier) AS [sourceSystemIDLabel]
	, 2 AS studyID
	, NULL AS PersonID
	, 6 AS [orgSourceSystemID] 
	, GETDATE() AS createDate
	, 'usp_Study102Subject'  AS [createdBy]
INTO #sourceSubject
	FROM ITMIDIFZ.genesis.Participant AS Participant
		INNER JOIN  ITMIDIFZ.genesis.Subject Subject
			ON subject.subjectId = participant.subjectID
	WHERE participant.isActive = 1


--Slowly changing dimension
MERGE  ITMIDW.[dbo].[tblSubject] AS targetSubject
USING #sourceSubject ss
	ON targetSubject.[sourceSystemSubjectID] = ss.[sourceSystemSubjectID]
WHEN MATCHED
	AND (
	ss.[studyID] <> targetSubject.[studyID] OR 
	ss.[sourceSystemIDLabel] <> targetSubject.[sourceSystemIDLabel] OR

	ss.[orgSourceSystemID] <> targetSubject.[orgSourceSystemID] OR  
	ss.[createDate] <> targetSubject.[createDate] OR
	ss.[createdBy] <> targetSubject.[createdBy] 
	)
THEN UPDATE SET
	[studyID]  = ss.[studyID]
	, [sourceSystemIDLabel] = ss.[sourceSystemIDLabel]
	, [personID] = ss.[personID]
	, [orgSourceSystemID] = ss.[orgSourceSystemID]
	, [createDate] = ss.[createDate]
	, [createdBy] = ss.[createdBy] 
WHEN NOT MATCHED THEN

INSERT ([sourceSystemSubjectID],[sourceSystemIDLabel],[studyID],[personID],[orgSourceSystemID],[createDate],[createdBy])
VALUES (ss.[sourceSystemSubjectID],ss.[sourceSystemIDLabel],ss.[studyID],ss.[personID],ss.[orgSourceSystemID],ss.[createDate],ss.[createdBy]);

END




