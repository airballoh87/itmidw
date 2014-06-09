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
Functional : ITMI SSIS for Insert and Update for study 102 subjects
Purpose : Import of study 101 subjects from data difz schema for all forms, taking the distinct list of SubjectID's and making an insert.
History : Created ON 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC itmidw.[usp_Study102SubjectDataset]
--checking both delete and insert component of slowing changing dimension

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
--******************102****************
--*************************************

--drop table
IF OBJECT_ID('tempdb..#sourceSubject') IS NOT NULL
DROP TABLE #sourceSubject  

IF OBJECT_ID('tempdb..#babyCnt') IS NOT NULL
DROP TABLE #babyCnt

select org.organizationName
,CASE MAX(RIGHT(sub.sourceSystemIDLabel,1)) 
	WHEN 'B' THEN 'Twin'
	WHEN 'C' THEN 'Triplet'
	ELSE 'More than 3' END as babyType
INTO #babyCnt
FROM itmidw.tblSubject sub
	inner join itmidw.tblSubjectOrganizationMap map
		on map.subjectID = sub.subjectID
	inner join itmidw.tblOrganization org
		on org.organizationID = map.organizationID
	inner join itmidw.tblOrganizationType orgType
		on orgType.organizationTypeID = org.organizationTypeID
	where sub.cohortRole = 'Infant'
		and ISNUMERIC(RIGHT(sub.sourceSystemIDLabel,1)) = 0
		and orgType.organizationTypeName = 'Family'
		and sub.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ')
GROUP BY org.organizationName
HAVING COUNT(*) >1


SELECT DISTINCT
           --(<sourceSystemDatasetID, varchar(20),>
		   sub.sourceSystemSubjectID as sourceSystemDatasetID
           --,<subjectID, int,>
		   , sub.subjecTID
           --,<paramListID, varchar(20),>
		   , 'Birth' as paramListID
           --,<variantID, varchar(20),>
		   , 'Birth Type' as variantID
           --,<paramName, varchar(20),>
		   , 'Multiple Birth Type' as paramName
           --,<paramListVersionID, varchar(20),>
		   , '1' as paramListVersionID
           --,<dataset, numeric(18,0),>
		   , 1 as dataset
           --,<enteredtext, varchar(255),>
		   , bc.babyType as enteredtext
           --,<enteredvalue, numeric(28,10),>
		   , NULL as enteredvalue
           --,<datasetSequence, numeric(18,0),>
		   , 1  as datasetSequence
           --,<dataItemSequence, numeric(18,0),>
		   , 1 as dataItemSequence
           --,<dataSetStatus, varchar(20),>
		   , 'Complete' as dataSetStatus
           --,<dataItemApproved, varchar(1),>
		   , 'Y' as dataItemApproved
           --,<isMaxItem, varchar(1),>
		   , 'Y' as isMaxItem
           --,<doesMetricPass, varchar(1),>
		   , NULL as doesMetricPass
		   , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
		   , GETDATE() AS createDate
		   , 'usp_Study102SubjectDataset'  AS [createdBy]
INTO #sourceSubject  
FROM #babyCnt bc
	INNER JOIN itmidw.tblOrganization org
		on org.organizationName = bc.organizationName
	inner join itmidw.tblSubjectOrganizationMap orgMap
		on orgMap.organizationID = org.organizationID
	INNER JOIN itmidw.tblSubject sub
		on sub.subjectID =orgMap.subjectID
			and sub.cohortRole = 'Infant'




--Slowly changing dimension
MERGE  ITMIDW.[tblSubjectDataSet] AS targetSubject
USING #sourceSubject ss
	ON targetSubject.sourceSystemDatasetID = ss.sourceSystemDatasetID
		AND targetSubject.paramName = ss.paramName
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




