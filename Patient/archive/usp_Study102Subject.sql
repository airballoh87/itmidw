IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Study102Subject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Study102Subject]
GO
/**************************************************************************
Created On : 3/17/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study102Subject]
Functional : ITMI SSIS for Insert and Update for study 102 subjects
Purpose : Import of study 101 subjects from data difz schema for all forms, taking the distinct list of SubjectID's and making an insert.
History : Created on 3/17/2014
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
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102Subject][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study102Subject]...'

--*************************************
--******************102****************
--*************************************
--drop table
IF OBJECT_ID('tempdb..#sourceSubject') IS NOT NULL
DROP TABLE #sourceSubject  



SELECT DISTINCT [sourceSystemSubjectID],[sourceSystemIDLabel],[studyID],[personID],[orgSourceSystemID],[createDate],[createdBy]
INTO #sourceSubject
FROM (
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].[ITMI_1000_Day_Study_101] a WHERE LEN(siteNumber) <3 
UNION ALL
	SELECT 
	 a.subject + '-01' AS [sourceSystemSubjectID] 
	 , a.subject + '-01' AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM itmistaging.[difz].[ITMI_1000_Day_Study_107] a WHERE LEN(siteNumber) <3 
UNION ALL
SELECT
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM itmistaging.[difz].[ITMI_1000_Day_Study_73] a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_103',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].[ITMI_1000_Day_Study_103] a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_105',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_105 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_109',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_109 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_57',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_57 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_59',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_59 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_61',
	SELECT 
	  a.subject + '-01' AS [sourceSystemSubjectID] 
	  , a.subject + '-01' AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	, 3 AS orgSourceSystemID
	, GETDATE() AS createDate
	,  'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_61 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_63',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_63 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_65',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_65 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_67',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_67 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_69',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_69 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_71',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_71 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_75',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_75 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_77',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_77 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_79',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_79 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_81',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_81 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_83',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_83 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_85',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_85 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_87',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_87 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_89',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_89 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_91',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_91 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_95',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_95 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_97',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_97 a WHERE LEN(siteNumber) <3 
UNION ALL
--'ITMI_1000_Day_Study_97',
	SELECT 
	 a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemSubjectID] 
	 , a.subject + '-' + SUBSTRING(instanceName, CHARINDEX('-',instanceName)+2, LEN(instanceName)) AS [sourceSystemIDLabel] 
	 , (select stud.studyID from itmidw.dbo.tblStudy stud where stud.studyshortID like '%102%') as studyID
	 , NULL as PersonID
	 , 3 AS orgSourceSystemID
	 , GETDATE() AS createDate
	 , 'TSQL Import: adb'  AS createdBy
		FROM  itmistaging.[difz].ITMI_1000_Day_Study_97 a WHERE LEN(siteNumber) <3 
	) AS B

--Slowly changing dimension
MERGE  ITMIDW.[dbo].[tblSubject] AS targetSubject
USING #sourceSubject ss
	ON targetSubject.[sourceSystemSubjectID] = ss.[sourceSystemSubjectID]
WHEN MATCHED
	AND (
	ss.[studyID] <> targetSubject.[studyID] OR 
	ss.[sourceSystemIDLabel] <> targetSubject.[sourceSystemIDLabel] OR
	ss.[personID] <> targetSubject.[personID] OR
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



