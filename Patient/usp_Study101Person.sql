IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[itmidw].[usp_Study101PersON]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101PersON]
GO
/**************************************************************************
Created ON : 3/19/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study101PersON]
FunctiONal : ITMI SSIS for Insert AND Update for study 101 persON table
Purpose : Import of study 101 people FROM data spoint101 schema for Mom, dad AND baby
--mom demographics FROM EHR
History : Created ON 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101PersON]
--testing update AND delete
--UPDATE tblPersON set studyID = 5 WHERE sourceSystemIDLabel = 'F-101-066'
--SELECT * FROM tblPersON WHERE sourceSystemIDLabel = 'F-101-066'
--delete FROM tblPersON WHERE sourceSystemIDLabel = 'F-101-201'
--SELECT * FROM tblPersON WHERE sourceSystemIDLabel = 'F-101-201'
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study101PersON]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedON, 121) + ' [usp_Study101PersON][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[usp_Study101PersON]...'


--**************************************************************************
--*******[tblPersON]********DBCC CHECKIDENT('tblPersON', RESEED, 1)*******
--**************************************************************************

--*************************************
--drop table--*************************
--*************************************

IF OBJECT_ID('tempdb..#sourcePersON') IS NOT NULL
DROP TABLE #sourcePersON  

IF OBJECT_ID('tempdb..#subjectDemo') IS NOT NULL
DROP TABLE #subjectDemo

--*************************************
--************SELECT FROM tblsubject***
--*************************************
SELECT 
	1 AS PersONTypeID
	, 0 AS deadFlag
	, 6 AS orgSourceSystemID
	, GETDATE() AS createDate
	,  'usp_Study101PersON'  AS createdBy
	, tblsubject.subjectID as [orgSourceSystemUniqueID]
INTO #sourcePersON
FROM itmidw.tblSubject
WHERE studyID = (SELECT studyID FROM tblStudy WHERE studyShortID = '101')

--*************************************
--***--Slowly Changing dimensiON*******
--*************************************

MERGE itmidw.[tblPersON] AS targetPersON
USING #sourcePersON sp
	ON targetPersON.[orgSourceSystemUniqueID] = sp.[orgSourceSystemUniqueID]
		AND targetPersON.[orgSourceSystemID] = sp.[orgSourceSystemID]
WHEN MATCHED
	AND (
	sp.PersONTypeID <> targetPersON.PersONTypeID OR 
	sp.deadFlag <> targetPersON.deadFlag OR 
	sp.createDate <> targetPersON.createDate OR 
	sp.createdBy <> targetPersON.createdBy OR 
	sp.orgSourceSystemUniqueID <> targetPersON.orgSourceSystemUniqueID
	)
THEN UPDATE SET
	PersONTypeID = sp.PersONTypeID
	, deadFlag = sp.deadFlag
	, createDate = sp.createDate
	, createdBy = sp.createdBy
	, orgSourceSystemUniqueID = sp.orgSourceSystemUniqueID
WHEN NOT MATCHED THEN

INSERT ([persONTypeID],[deadFlag],[orgSourceSystemID] ,[createDate],[createdBy] ,[orgSourceSystemUniqueID])
VALUES ([persONTypeID],[deadFlag],[orgSourceSystemID],[createDate],[createdBy] ,[orgSourceSystemUniqueID]);


--*************************************
--***--update back to Subject**********
--*************************************

UPDATE itmidw.tblSubject set persONID = persON.persONID
FROM itmidw.tblSubject subject
	INNER JOIN itmidw.tblpersON persON
		ON persON.[orgSourceSystemUniqueID] = subject.subjectID
WHERE subject.orgSourceSystemID =  (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') 


--*************************************
--***epic demographics*****************
--*************************************

--****************--****************
--**[epicMOMDemo] temp table--******
--****************--****************

SELECT 
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
FROM epic.[epicMOMDemo] demo
	INNER join itmidw.tblSubjectIdentifer id
		ON id.subjectIdentifier = CONVERT(varchar(100),demo.mrn)
			AND id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		ON sub.subjectID = id.subjectID
WHERE demo.matchSubjectID is null

--****************--****************
--update table persON--*************
--****************--****************

UPDATE itmidw.tblpersON SET 
	mrn = sb.mrn
	, raceCode = sb.race
	, ethnicityCode = sb.ETHNIC_GROUP
	, sex = sb.sex
	, zip = sb.zip
	, lastName = sb.LAST_NAME
	, firstName =sb.FIRST_NAME
FROM itmidw.tblPersON persON
	INNER JOIN itmidw.tblsubject sub
		ON sub.persONID = persON.persONID
	INNER JOIN #subjectDemo sb
		ON sb.SubjectID = sub.subjectID


PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

END



