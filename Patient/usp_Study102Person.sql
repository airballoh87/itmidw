IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[itmidw].[usp_Study102Person]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study102Person]
GO
/**************************************************************************
Created ON : 3/19/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study102Person]
Functional : ITMI SSIS for Insert and Update for study 101 persON table
Purpose : Import of study 101 people FROM data spoint101 schema for Mom, dad and baby
History : Created ON 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102Person]
--testing update and delete
--UPDATE tblPersON set studyID = 5 WHERE sourceSystemIDLabel = 'F-101-066'
--select * FROM tblPersON WHERE sourceSystemIDLabel = 'F-101-066'
--delete FROM tblPersON WHERE sourceSystemIDLabel = 'F-101-201'
--select * FROM tblPersON WHERE sourceSystemIDLabel = 'F-101-201'
**************************************************************************/
CREATE PROCEDURE [itmidw].[usp_Study102Person]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102Person][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study102Person]...'


--**************************************************************************
--*******[tblPerson]********DBCC CHECKIDENT('tblPerson', RESEED, 1)*******
--**************************************************************************
--drop table
IF OBJECT_ID('tempdb..#sourcePerson') IS NOT NULL
DROP TABLE #sourcePersON  


--*************************************
--*******insert into temp table********
--*************************************
SELECT 
	1 AS PersonTypeID
	, 0 AS deadFlag
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	,  'usp_Study102Person'  AS createdBy
	, tblsubject.subjectID as [orgSourceSystemUniqueID]
INTO #sourcePerson
FROM itmidw.tblSubject
WHERE studyID = (SELECT studyID FROM itmidw.tblStudy WHERE studyShortID = '102')

--*************************************
--Slowly Changing dimension--**********
--*************************************
MERGE  itmidw.[tblPerson] AS targetPerson
USING #sourcePersON sp
	ON targetPerson.[orgSourceSystemUniqueID] = sp.[orgSourceSystemUniqueID]
		AND targetPerson.orgSourceSystemID <> sp.orgSourceSystemID 
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

--*************************************
--update back to Subject--*************
--*************************************
UPDATE itmidw.tblSubject SET personID = person.personID
FROM itmidw.tblSubject subject
	INNER JOIN itmidw.tblpersON person
		ON person.[orgSourceSystemUniqueID] = subject.subjectID
WHERE subject.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ')


PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'


END



