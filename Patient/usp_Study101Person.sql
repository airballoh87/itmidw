IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[itmidw].[usp_Study101Person]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101Person]
GO
/**************************************************************************
Created On : 3/19/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study101Person]
Functional : ITMI SSIS for Insert and Update for study 101 person table
Purpose : Import of study 101 people from data spoint101 schema for Mom, dad and baby
History : Created on 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101Person]
--testing update and delete
--UPDATE tblPerson set studyID = 5 where sourceSystemIDLabel = 'F-101-066'
--select * from tblPerson where sourceSystemIDLabel = 'F-101-066'
--delete from tblPerson where sourceSystemIDLabel = 'F-101-201'
--select * from tblPerson where sourceSystemIDLabel = 'F-101-201'
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study101Person]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101Person][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[usp_Study101Person]...'


--**************************************************************************
--*******[tblPerson]********DBCC CHECKIDENT('tblPerson', RESEED, 1)*******
--**************************************************************************
--drop table
IF OBJECT_ID('tempdb..#sourcePerson') IS NOT NULL
DROP TABLE #sourcePerson  

IF OBJECT_ID('tempdb..#subjectDemo') IS NOT NULL
DROP TABLE #subjectDemo

SELECT 
	1 AS PersonTypeID
	, 0 AS deadFlag
	, 6 AS orgSourceSystemID
	, GETDATE() AS createDate
	,  'usp_Study101Person'  AS createdBy
	, tblsubject.subjectID as [orgSourceSystemUniqueID]
INTO #sourcePerson
FROM itmidw.tblSubject
WHERE studyID = (SELECT studyID from tblStudy where studyShortID = '101')


--Slowly Changing dimension
MERGE itmidw.[tblPerson] AS targetPerson
USING #sourcePerson sp
	ON targetPerson.[orgSourceSystemUniqueID] = sp.[orgSourceSystemUniqueID]
WHEN MATCHED
	AND (
	sp.PersonTypeID <> targetPerson.PersonTypeID OR 
	sp.deadFlag <> targetPerson.deadFlag OR 
	sp.orgSourceSystemID <> targetPerson.orgSourceSystemID OR 
	sp.createDate <> targetPerson.createDate OR 
	sp.createdBy <> targetPerson.createdBy OR 
	sp.orgSourceSystemUniqueID <> targetPerson.orgSourceSystemUniqueID
	)
THEN UPDATE SET
	PersonTypeID = sp.PersonTypeID
	, deadFlag = sp.deadFlag
	, orgSourceSystemID = sp.orgSourceSystemID
	, createDate = sp.createDate
	, createdBy = sp.createdBy
	, orgSourceSystemUniqueID = sp.orgSourceSystemUniqueID
WHEN NOT MATCHED THEN

INSERT ([personTypeID],[deadFlag],[orgSourceSystemID] ,[createDate],[createdBy] ,[orgSourceSystemUniqueID])
VALUES ([personTypeID],[deadFlag],[orgSourceSystemID],[createDate],[createdBy] ,[orgSourceSystemUniqueID]);


--update back to Subject
UPDATE itmidw.tblSubject set personID = person.personID
FROM itmidw.tblSubject subject
	INNER JOIN itmidw.tblperson person
		on person.[orgSourceSystemUniqueID] = subject.subjectID
where subject.orgSourceSystemID =  (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') 

--Epic Demographics

--****************
--**[epicMOMDemo]
--****************
--put in temp table
select 
	sub.sourceSystemIDLabel
	, LAST_NAME
	, FIRST_NAME
	, sex
	, zip
	, race
	, ETHNIC_GROUP
	, mrn
	, sub.subjectID
INTO #subjectDemo
from epic.[epicMOMDemo] demo
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),demo.mrn)
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where demo.matchSubjectID is null

--update table person
UPDATE itmidw.tblperson SET 
	mrn = sb.mrn
	, raceCode = sb.race
	, ethnicityCode = sb.ETHNIC_GROUP
	, sex = sb.sex
	, zip = sb.zip
	, lastName = sb.LAST_NAME
	, firstName =sb.FIRST_NAME
from itmidw.tblPerson person
	INNER JOIN itmidw.tblsubject sub
		on sub.personID = person.personID
	INNER JOIN #subjectDemo sb
		on sb.SubjectID = sub.subjectID


PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

END



