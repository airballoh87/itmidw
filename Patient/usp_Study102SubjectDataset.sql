/****** Object:  StoredProcedure [itmidw].[usp_Study102SubjectDataset]    Script Date: 3/29/2014 6:39:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**************************************************************************
Created ON : 3/17/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study102SubjectDataset]
Functional : ITMI SSIS for Insert AND Update for study 102 subjects
Purpose : Import of study 101 subjects from data difz schema for all forms, taking the distinct list of SubjectID's AND making an insert.
History : Created ON 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC itmidw.[usp_Study102SubjectDataset]
--checking both delete AND insert component of slowing changing dimension

**************************************************************************/
ALTER PROCEDURE [itmidw].[usp_Study102SubjectDataset]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102SubjectDataset][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [itmidw].[usp_Study102SubjectDataset]...'

--*************************************
--************--drop table*************
--*************************************

IF OBJECT_ID('tempdb..#sourceSubject') IS NOT NULL
DROP TABLE #sourceSubject  

IF OBJECT_ID('tempdb..#babyCnt') IS NOT NULL
DROP TABLE #babyCnt

--*************************************
--************insert temp table *******
--*************************************
SELECT org.organizationName
,CASE MAX(RIGHT(sub.sourceSystemIDLabel,1)) 
	WHEN 'B' THEN 'Twin'
	WHEN 'C' THEN 'Triplet'
	ELSE 'More than 3' END AS babyType
INTO #babyCnt
FROM itmidw.tblSubject sub
	INNER JOIN itmidw.tblSubjectOrganizationMap map
		ON map.subjectID = sub.subjectID
	INNER JOIN itmidw.tblOrganizatiON org
		ON org.organizationID = map.organizationID
	INNER JOIN itmidw.tblOrganizationType orgType
		ON orgType.organizationTypeID = org.organizationTypeID
	WHERE sub.cohortRole = 'Infant'
		AND ISNUMERIC(RIGHT(sub.sourceSystemIDLabel,1)) = 0
		AND orgType.organizationTypeName = 'Family'
		AND sub.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ')
GROUP BY org.organizationName
HAVING COUNT(*) >1

--*************************************
--************insert temp table *******
--*************************************
SELECT DISTINCT
   sub.sourceSystemSubjectID AS sourceSystemDatasetID           
   , sub.subjecTID           
   , 'Birth' AS paramListID           
   , 'Birth Type' AS variantID           
   , 'Multiple Birth Type' AS paramName           
   , '1' AS paramListVersionID           
   , 1 AS dataset           
   , bc.babyType AS enteredtext           
   , NULL AS enteredvalue           
   , 1  AS datasetSequence           
   , 1 AS dataItemSequence           
   , 'Complete' AS dataSetStatus           
   , 'Y' AS dataItemApproved           
   , 'Y' AS isMaxItem           
   , NULL AS doesMetricPass
   , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
   , GETDATE() AS createDate
   , 'usp_Study102SubjectDataset'  AS [createdBy]
INTO #sourceSubject  
FROM #babyCnt bc
	INNER JOIN itmidw.tblOrganizatiON org
		ON org.organizationName = bc.organizationName
	INNER JOIN itmidw.tblSubjectOrganizationMap orgMap
		ON orgMap.organizationID = org.organizationID
	INNER JOIN itmidw.tblSubject sub
		ON sub.subjectID =orgMap.subjectID
			AND sub.cohortRole = 'Infant'

--*************************************
--*****--Slowly changing dimension*****
--*************************************
MERGE  ITMIDW.[tblSubjectDataSet] AS targetSubject
USING #sourceSubject ss
	ON targetSubject.sourceSystemDatasetID = ss.sourceSystemDatasetID
		AND targetSubject.paramName = ss.paramName
		AND targetSubject.[orgSourceSystemID] <> ss.[orgSourceSystemID]
WHEN MATCHED
	AND (
    ss.[subjectID] <> targetSubject.[subjectID] OR 
    ss.[paramListID] <> targetSubject.[paramListID] OR 
    ss.[variantID] <> targetSubject.[variantID] OR 
    ss.[paramListVersionID] <> targetSubject.[paramListVersionID] OR 
    ss.[dataset] <> targetSubject.[dataset] OR 
    ss.[enteredtext] <> targetSubject.[enteredtext] OR 
    ss.[enteredvalue] <> targetSubject.[enteredvalue] OR 
    ss.[datasetSequence] <> targetSubject.[datasetSequence] OR 
    ss.[dataItemSequence] <> targetSubject.[dataItemSequence] OR 
    ss.[dataSetStatus] <> targetSubject.[dataSetStatus] OR 
    ss.[dataItemApproved] <> targetSubject.[dataItemApproved] OR 
    ss.[isMaxItem] <> targetSubject.[isMaxItem] OR 
    ss.[doesMetricPass] <> targetSubject.[doesMetricPass] OR
	ss.[orgSourceSystemID] <> targetSubject.[orgSourceSystemID] OR  
	ss.[createDate] <> targetSubject.[createDate] OR
	ss.[createdBy] <> targetSubject.[createdBy] 
	)
THEN UPDATE SET
	[subjectID] =ss.[subjectID] 
    ,[paramListID] =ss.[paramListID] 
    ,[variantID] =ss.[variantID] 
    ,[paramName] =ss.[paramName] 
    ,[paramListVersionID] =ss.[paramListVersionID] 
    ,[dataset] =ss.[dataset] 
    ,[enteredtext] =ss.[enteredtext] 
    ,[enteredvalue] =ss.[enteredvalue] 
    ,[datasetSequence] =ss.[datasetSequence] 
    ,[dataItemSequence] =ss.[dataItemSequence] 
    ,[dataSetStatus] =ss.[dataSetStatus] 
    ,[dataItemApproved] =ss.[dataItemApproved] 
    ,[isMaxItem] =ss.[isMaxItem] 
    ,[doesMetricPass] =ss.[doesMetricPass]
	, [orgSourceSystemID] = ss.[orgSourceSystemID]
	, [createDate] = ss.[createDate]
	, [createdBy] = ss.[createdBy] 
WHEN NOT MATCHED THEN

INSERT (
 [sourceSystemDatasetID]
 ,[subjectID]
 ,[paramListID]
 ,[variantID]
 ,[paramName]
 ,[paramListVersionID]
 ,[dataset]
 ,[enteredtext]
 ,[enteredvalue]
 ,[datasetSequence]
 ,[dataItemSequence]
 ,[dataSetStatus]
 ,[dataItemApproved]
 ,[isMaxItem]
 ,[doesMetricPass]
 ,[orgSourceSystemID]
 ,[createDate]
 ,[createdBy]
)
VALUES (
 ss.[sourceSystemDatasetID]
 ,ss.[subjectID]
 ,ss.[paramListID]
 ,ss.[variantID]
 ,ss.[paramName]
 ,ss.[paramListVersionID]
 ,ss.[dataset]
 ,ss.[enteredtext]
 ,ss.[enteredvalue]
 ,ss.[datasetSequence]
 ,ss.[dataItemSequence]
 ,ss.[dataSetStatus]
 ,ss.[dataItemApproved]
 ,ss.[isMaxItem]
 ,ss.[doesMetricPass]
 ,ss.[orgSourceSystemID]
 ,ss.[createDate]
 ,ss.[createdBy]
);

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'


END




