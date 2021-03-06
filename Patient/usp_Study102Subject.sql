/****** Object:  StoredProcedure [itmidw].[usp_Study102Subject]    Script Date: 3/29/2014 6:39:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
CREATE PROCEDURE [itmidw].[usp_Study102Subject]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102Subject][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [itmidw].[usp_Study102Subject]...'

--*************************************
--*************drop table**************
--*************************************

IF OBJECT_ID('tempdb..#sourceSubject') IS NOT NULL
DROP TABLE #sourceSubject  

--*************************************
--************insert temp table********
--*************************************
SELECT 
	CONVERT(VARCHAR(50),Participant.ParticipantID) AS [sourceSystemSubjectID]
	, CONVERT(VARCHAR(50),subject.subjectNumber+'-' + participant.participantIdentifier) AS [sourceSystemIDLabel]
	, CASE ISNULL(LEFT(participant.participantidentifier,2),'')
		WHEN '01' THEN 'Mother'
		WHEN '02' THEN 'Father'
		WHEN '03' THEN 'Infant'
		WHEN '' THEN 'None'
		ELSE 'PO' END AS cohortRole
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID like '%102%') AS StudyID
	, NULL AS PersonID --to be sent later
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Subject'  AS [createdBy]
INTO #sourceSubject
	FROM difzDBcopy.Participant AS Participant
		INNER JOIN  difzDBcopy.Subject Subject
			ON subject.subjectId = participant.subjectID
		INNER JOIN  difzDBcopy.StudySite ss
			ON ss.studySiteID= subject.studySiteID
		INNER JOIN  difzDBcopy.OrganizatiON org
			ON org.organizationID = ss.OrganizationID
		INNER JOIN difzDBcopy.PermissibleValues PermVal
			ON LTRIM(RTRIM(PermVal.PermissibleValuesID)) = LTRIM(RTRIM(org.statusCode))
				AND permVal.codesetname = 'statusCode' 
	WHERE participant.isActive = 1
		AND permVal.codeValue = 'Active'

--*************************************
--*****--Slowly changing dimension*****
--*************************************
MERGE  ITMIDW.[tblSubject] AS targetSubject
USING #sourceSubject ss
	ON targetSubject.[sourceSystemSubjectID] = ss.[sourceSystemSubjectID]
		AND targetSubject.[orgSourceSystemID] = ss.[orgSourceSystemID] 
WHEN MATCHED
	AND (
	ss.[studyID] <> targetSubject.[studyID] OR 
	ss.[sourceSystemIDLabel] <> targetSubject.[sourceSystemIDLabel] OR
	ss.cohortRole <>  targetSubject.[cohortRole] OR
	ss.[createDate] <> targetSubject.[createDate] OR
	ss.[createdBy] <> targetSubject.[createdBy] 
	)
THEN UPDATE SET
	[studyID]  = ss.[studyID]
	, [sourceSystemIDLabel] = ss.[sourceSystemIDLabel]
	, [personID] = ss.[personID]
	,  cohortRole = ss.[cohortRole]

	, [createDate] = ss.[createDate]
	, [createdBy] = ss.[createdBy] 
WHEN NOT MATCHED THEN

INSERT (cohortrole,[sourceSystemSubjectID],[sourceSystemIDLabel],[studyID],[personID],[orgSourceSystemID],[createDate],[createdBy])
VALUES (ss.cohortRole,ss.[sourceSystemSubjectID],ss.[sourceSystemIDLabel],ss.[studyID],ss.[personID],ss.[orgSourceSystemID],ss.[createDate],ss.[createdBy]);

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'


END




