IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study101Subject]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101Subject]
GO
/**************************************************************************
Created On : 3/17/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study101Subject]
Functional : ITMI SSIS for Insert and Update for study 101 subjects
Purpose : Import of study 101 subjects from data spoint101 schema for Mom, dad and baby
History : Created on 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101Subject]
--testing update and delete
--UPDATE tblsubject set studyID = 5 where sourceSystemIDLabel = 'F-101-066'
--select * from tblsubject where sourceSystemIDLabel = 'F-101-066'
--delete from tblsubject where sourceSystemIDLabel = 'F-101-201'
--select * from tblsubject where sourceSystemIDLabel = 'F-101-201'
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study101Subject]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101Subject][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw..[usp_Study101Subject]...'


--**************************************************************************
--*******[tblSubject]********DBCC CHECKIDENT('tblSubject', RESEED, 1)*******
--**************************************************************************
--drop table
IF OBJECT_ID('tempdb..#sourceSubject') IS NOT NULL
DROP TABLE #sourceSubject  


SELECT DISTINCT [sourceSystemSubjectID],[sourceSystemIDLabel],[studyID], [cohortRole], [personID],[orgSourceSystemID],[createDate],[createdBy]
INTO #sourceSubject
FROM (
	SELECT 
		DISTINCT 
		a.[Fathers Study ID] AS sourceSystemSubjectID
		,a.[Fathers Study ID] AS sourceSystemIDLabel
		, (select stud.studyID from itmidw.tblStudy stud where stud.studyshortID like '%101%') AS studyID
		, 'Father' as [cohortRole]
		, NULL AS PersonID --will be part of insert later
		, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
		, GETDATE() AS CreateDate
		, 'usp_Study101Subject'  AS createdBy
		FROM  [spoint101].[EDC101Father] a
			WHERE ISNULL(a.[Fathers Study ID],'' ) <> '' 
				AND LEFT(a.[Fathers Study ID],1) = 'F' UNION ALL
	SELECT DISTINCT
		a.[Mothers Study ID] AS sourceSystemSubjectID
		, a.[Mothers Study ID] AS sourceSystemIDLabel
		, (select stud.studyID from itmidw.tblStudy stud where stud.studyshortID like '%101%') AS studyID
		, 'Mother' as [cohortRole]
		, NULL AS PersonID --will be part of insert later
		, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
		, GETDATE() AS CreateDate
		, 'usp_Study101Subject'  AS createdBy
		FROM [spoint101].[EDC101Mother] a 
			WHERE ISNULL(a.[Mothers Study ID],'') <> '' UNION ALL
	SELECT 
		a.[Infants Study ID] AS sourceSystemSubjectID
		, a.[Infants Study ID] AS sourceSystemIDLabel
		, (select stud.studyID from itmidw.tblStudy stud where stud.studyshortID like '%101%') AS studyID
		, 'Infant' as [cohortRole]
		, NULL AS PersonID --will be part of insert later
		, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
		, GETDATE() AS CreateDate
		, 'usp_Study101Subject'  AS createdBy
		FROM [spoint101].[EDC101NEWBORN] a 
			WHERE ISNULL(a.[Infants Study ID],'') <> '' UNION ALL
	SELECT 
		DISTINCT 
		a.[Fathers Study ID] AS sourceSystemSubjectID
		,a.[Fathers Study ID] AS sourceSystemIDLabel
		, (select stud.studyID from itmidw.tblStudy stud where stud.studyshortID like '%101%') AS studyID
		, 'PO' as [cohortRole]
		, NULL AS PersonID --will be part of insert later
		, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') AS orgSourceSystemID
		, GETDATE() AS CreateDate
		, 'usp_Study101Subject'  AS createdBy
		FROM  [spoint101].[EDC101Father] a
			WHERE ISNULL(a.[Fathers Study ID],'' ) <> '' 
				AND LEFT(a.[Fathers Study ID],2) = 'PO' 
	) AS B

--********Withdrawals -- from Spreadsheet extract

INSERT INTO #sourceSubject (sourceSystemSubjectID,sourceSystemIDLabel, studyId, cohortRole, orgSourceSystemID, createDate, createdBy)
SELECT	'M-101-038',	'M-101-038',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-059',	'M-101-059',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-098',	'M-101-098',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-114',	'M-101-114',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-133',	'M-101-133',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-154',	'M-101-154',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-168',	'M-101-168',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-211',	'M-101-211',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-291',	'M-101-291',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-294',	'M-101-294',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-340',	'M-101-340',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-345',	'M-101-345',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-366',	'M-101-366',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-378',	'M-101-378',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-383',	'M-101-383',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-407',	'M-101-407',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-416',	'M-101-416',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-418',	'M-101-418',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-425',	'M-101-425',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-429',	'M-101-429',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-431',	'M-101-431',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-442',	'M-101-442',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-453',	'M-101-453',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-475',	'M-101-475',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-484',	'M-101-484',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-493',	'M-101-493',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-496',	'M-101-496',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-540',	'M-101-540',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-573',	'M-101-573',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-655',	'M-101-655',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-674',	'M-101-674',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-685',	'M-101-685',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-690',	'M-101-690',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-691',	'M-101-691',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-701',	'M-101-701',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-707',	'M-101-707',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-721',	'M-101-721',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-727',	'M-101-727',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-737',	'M-101-737',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-761',	'M-101-761',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-767',	'M-101-767',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-779',	'M-101-779',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-829',	'M-101-829',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-916',	'M-101-916',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-939',	'M-101-939',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-950',	'M-101-950',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-960',	'M-101-960',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-332',	'M-101-332',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-214',	'M-101-214',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-201',	'M-101-201',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-221',	'M-101-221',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-189',	'M-101-189',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-120',	'M-101-120',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' UNION ALL
SELECT	'M-101-074',	'M-101-074',	1, 'Mother',6,GETDATE(), 'usp_Study101Subject' 


--Slowly Changing dimension
MERGE  ITMIDW.[tblSubject] AS targetSubject
USING #sourceSubject ss
	ON targetSubject.[sourceSystemSubjectID] = ss.[sourceSystemSubjectID]
		and ss.[orgSourceSystemID] = targetSubject.[orgSourceSystemID]
WHEN MATCHED
	AND (
	ss.[studyID] <> targetSubject.[studyID] OR 
	ss.[sourceSystemIDLabel] <> targetSubject.[sourceSystemIDLabel] OR
	ss.[personID] <> targetSubject.[personID] OR
	ss.cohortRole<>  targetSubject.[cohortRole] OR
	ss.[orgSourceSystemID] <> targetSubject.[orgSourceSystemID] OR  
	ss.[createDate] <> targetSubject.[createDate] OR
	ss.[createdBy] <> targetSubject.[createdBy] 
	)
THEN UPDATE SET
	[studyID]  = ss.[studyID]
	, [sourceSystemIDLabel] = ss.[sourceSystemIDLabel]
	, [personID] = ss.[personID]
	, cohortRole = ss.[cohortRole]
	, [orgSourceSystemID] = ss.[orgSourceSystemID]
	, [createDate] = ss.[createDate]
	, [createdBy] = ss.[createdBy] 
WHEN NOT MATCHED THEN


INSERT (cohortRole,[sourceSystemSubjectID],[sourceSystemIDLabel],[studyID],[personID],[orgSourceSystemID],[createDate],[createdBy])
VALUES (ss.cohortRole,ss.[sourceSystemSubjectID],ss.[sourceSystemIDLabel],ss.[studyID],ss.[personID],ss.[orgSourceSystemID],ss.[createDate],ss.[createdBy]);

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

END


