IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[itmidw].[usp_AllStudiesFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_AllStudiesFile]
GO
/**************************************************************************
Created ON  : 4/6/2014
Created By : AarON  Black
Team Name : Informatics
Object name : [usp_AllStudiesFile]
Functional : ITMI SSIS for Insert AND Update for all studies tblFiles
 This procedure grabs files that are connected to subjects AND or specimens that run through ITMI studies
History : Created ON  4/6/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC itmidw.[usp_AllStudiesFile]
--TRUNCATe table ITMIDW.[tblfile] 
--SELECT * FROM ITMIDW.[dbo].[tblfile] where matchsubjectID IS NOT NULL order by fileLocation

**************************************************************************/
CREATE PROCEDURE [itmidw].[usp_AllStudiesFile]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON  SMALLDATETIME
SET @UpdatedON  = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_AllStudiesFile][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_AllStudiesFile]...'


--*************************************
--drop table--*************************
--*************************************
IF OBJECT_ID('tempdb..#sourceFile') IS NOT NULL
DROP TABLE #sourceFile

IF OBJECT_ID('tempdb..#ManifestWGSCGI') IS NOT NULL
DROP TABLE #ManifestWGSCGI

IF OBJECT_ID('tempdb..#eaAWSFiles') IS NOT NULL
DROP TABLE #eaAWSFiles


IF OBJECT_ID('tempdb..#eaAWSFiles') IS NOT NULL
DROP TABLE #ddMani

IF OBJECT_ID('tempdb..#sourceEvent') IS NOT NULL
DROP TABLE #sourceEvent  

--****************
--*****Plate******
--****************
 SELECT DISTINCT
	LEFT(IlluminaID,9) AS shipmentPlateName 
	, (SELECT organizationID from itmidw.tblOrganizatiON  WHERE organizationName = 'Illumina') AS shipToOrganization
	, 'WGS' AS shipToProcessingType
	, [Assembly] AS [shipToAssemblyVersion]
	, dateShipped AS shipDate
	, DriveBarcode  AS shipDataDriveName 
	, -1 AS [orgSourceSystemID]
	, GETDATE() AS [createDate]
	, 'usp_AllstudyFiles' AS [createdBy]
INTO #ddMani
FROM [etl].[DataDeliveryManifest] dm
	LEFT JOIN itmidw.tblShipmentPlate sp
		ON  sp.shipmentPlateName = LEFT(IlluminaID,9)
WHERE sp.shipmentPlateID IS NULL


--*************************************--*************************************
 --TRUNCATE TABLE itmidw.tblShipmentPlate--*************************************
 --*************************************--*************************************
INSERT INTO itmidw.tblShipmentPlate (
 shipmentPlateName 
, shipToOrganization
, shipToProcessingType
, [shipToAssemblyVersion]
, shipDate
, shipDataDriveName
, [orgSourceSystemID]
, [createDate]
, [createdBy]
)
SELECT
 shipmentPlateName 
, shipToOrganization
, shipToProcessingType
, [shipToAssemblyVersion]
, MAX(shipDate)
, NULL AS shipDataDriveName
, [orgSourceSystemID]
, [createDate]
, [createdBy]
FROM #ddMani
GROUP BY 
 shipmentPlateName 
, shipToOrganization
, shipToProcessingType
, [shipToAssemblyVersion]
, [orgSourceSystemID]
, [createDate]
, [createdBy]

--****************************
--*****externalDrives*********
--****************************

INSERT INTO [itmidw].[tblFileExternalDrive](
	[shipDataDriveName]
	,[shipmentPlateName]
	,[shipToOrganization]
	,[shipToProcessingType]
	,[shipToAssemblyVersion]
	,[orgSourceSystemID]
	,[createDate]
	,[createdBy])
SELECT 
	dd.[shipDataDriveName]
	,dd.[shipmentPlateName]
	,dd.[shipToOrganization]
	,dd.[shipToProcessingType]
	,dd.[shipToAssemblyVersion]
	,dd.[orgSourceSystemID]
	,dd.[createDate]
	,dd.[createdBy]
FROM #ddMani dd	
	LEFT JOIN [itmidw].[tblFileExternalDrive] exist
		ON  exist.[shipDataDriveName] = dd.[shipDataDriveName]
WHERE exist.[shipDataDriveName] IS NULL


--****************
--*****Files******
--****************


SELECT DISTINCT
	 aws.awsfileName AS [itmiFileName]
	,aws.locatiON  AS [fileLocation]
	,aws.awsDateCreated AS [fileCreateDate]
	,NULL AS [fileCreateBy]
	,NULL AS [fileModDate]
	,NULL AS [fileModBy]
	,NULL AS [matchSubjectID]
	,NULL AS [matchSpecimenID]
	,aws.sizeinBytes AS [fileSizeInBytes]
	,ROUND(aws.sizeinBytes /1024/1024,2) AS [fileSizeInMB]
	,ROUND(aws.sizeinBytes /1024/1024/2014,2)AS [fileSizeInGB]
	,aws.monthCreated
	,aws.yearCreated
	,aws.fileextension
	,aws.variantType
	,aws.plate 
	,aws.AWSVolume
	,aws.topbucket AS awsTopBucket
	,CONVERT(VARCHAR(100),NULL) AS ITMISubjectID
    ,(SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'ITMI AWS Illumina') AS [orgSourceSystemID]
    ,GETDATE() [createDate]
    ,'usp_Study102CrfEvent' AS [createdBy]
INTO #sourceFile
FROM aws.itmiAWSFile aws
WHERE aws.awsVolume = 'itmi.ptb.illumina'
	AND aws.AwsfileName <> aws.Location

--*************************************
--***********insert into #temp file****
--*************************************
INSERT INTO #sourceFile (
[itmiFileName],[fileLocation],[fileCreateDate],[fileCreateBy],[fileModDate],[fileModBy]
,[matchSubjectID],[matchSpecimenID],[fileSizeInBytes],[fileSizeInMB],[fileSizeInGB]
,monthCreated,yearCreated,fileextension,variantType,plate,AWSVolume,awsTopBucket
,ITMISubjectID,[orgSourceSystemID],createDate,createdBy)
SELECT DISTINCT
	 aws.awsfileName AS [itmiFileName]
	,aws.locatiON  AS [fileLocation]
	,aws.awsDateCreated AS [fileCreateDate]
	,NULL AS [fileCreateBy]
	,NULL AS [fileModDate]
	,NULL AS [fileModBy]
	,NULL AS [matchSubjectID]
	,NULL AS [matchSpecimenID]
	,aws.sizeinBytes AS [fileSizeInBytes]
	,ROUND(aws.sizeinBytes /1024/1024,2) AS [fileSizeInMB]
	,ROUND(aws.sizeinBytes /1024/1024/1024,2)AS [fileSizeInGB]
	,aws.monthCreated
	,aws.yearCreated
	,aws.fileextension
	,aws.variantType
	,aws.plate 
	,aws.AWSVolume
	,aws.TopBucket
	,CONVERT(VARCHAR(100),NULL) AS ITMISubjectID
    ,(SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'ITMI AWS CGI') AS [orgSourceSystemID]
    ,GETDATE() [createDate]
    ,'usp_Study102CrfEvent' AS [createdBy]
FROM aws.itmiAWSFile aws
WHERE aws.awsVolume = 'itmi.ptb'
AND aws.AwsfileName <> aws.Location

--*************************************
--itmi.ptb.ea--************************
--*************************************

INSERT INTO #sourceFile (
[itmiFileName],[fileLocation],[fileCreateDate],[fileCreateBy],[fileModDate],[fileModBy]
,[matchSubjectID],[matchSpecimenID],[fileSizeInBytes],[fileSizeInMB],[fileSizeInGB]
,monthCreated,yearCreated,fileextension
,variantType
,plate
,awsVolume
,awsTopBucket
,ITMISubjectID
,[orgSourceSystemID]
,createDate
,createdBy)
SELECT DISTINCT
	 aws.awsfileName AS [itmiFileName]
	,aws.locatiON  AS [fileLocation]
	,aws.awsDateCreated AS [fileCreateDate]
	,NULL AS [fileCreateBy]
	,NULL AS [fileModDate]
	,NULL AS [fileModBy]
	,NULL AS [matchSubjectID]
	,NULL AS [matchSpecimenID]
	,aws.sizeinBytes AS [fileSizeInBytes]
	,ROUND(aws.sizeinBytes /1024/1024,2) AS [fileSizeInMB]
	,ROUND(aws.sizeinBytes /1024/1024/1024,2)AS [fileSizeInGB]
	,aws.monthCreated
	,aws.yearCreated
	,aws.fileextension
	,aws.variantType
	,aws.plate 
	,aws.AWSVolume
	,aws.TopBucket
	,CONVERT(VARCHAR(100),NULL) AS ITMISubjectID
    ,(SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'ITMI AWS EA') AS [orgSourceSystemID]
    ,GETDATE() [createDate]
    ,'usp_Study102CrfEvent' AS [createdBy]
FROM aws.itmiAWSFile aws
WHERE aws.awsVolume = 'itmi.ptb.ea'
AND aws.AwsfileName <> aws.Location

--*************************************
--Slowly changing dimension--**********
--*************************************
MERGE  ITMIDW.[tblFile] AS targetFile
USING #sourceFile ss
	ON  targetFile.[fileLocation] = ss.[fileLocation]
		AND targetfile.[orgSourceSystemID] = ss.[orgSourceSystemID]
  WHEN MATCHED
	AND (
		ss.[itmiFileName] <> targetFile.[itmiFileName] OR
		ss.[fileCreateDate] <> targetFile.[fileCreateDate] OR
		ss.[fileCreateBy] <> targetFile.[fileCreateBy] OR
		ss.[fileModDate] <> targetFile.[fileModDate] OR
		ss.[fileModBy] <> targetFile.[fileModBy] OR
		ss.[matchSubjectID] <> targetFile.[matchSubjectID] OR
		ss.[matchSpecimenID] <> targetFile.[matchSpecimenID] OR
		ss.[fileSizeInBytes] <> targetFile.[fileSizeInBytes] OR
		ss.[fileSizeInMB] <> targetFile.[fileSizeInMB] OR
		ss.[fileSizeInGB] <> targetFile.[fileSizeInGB] OR
		ss.monthCreated <> targetFile.monthCreated OR
		ss.yearCreated <> targetFile.yearCreated OR
		ss.fileextensiON  <> targetFile.fileextensiON  OR
		ss.variantType <> targetFile.variantType OR
		ss.plate <> targetFile.plate OR
		ss.AwsVolume <> targetFile.AwsVolume OR
		ss.awsTopBucket <> targetFile.awsTopBucket OR
		ss.ITMISubjectID <> targetFile.ITMISubjectID OR
		ss.createDate <> targetFile.createDate OR
		ss.createdBy <> targetFile.createdBy 
	)
THEN UPDATE SET
		[fileLocation] = ss.[fileLocation]
		, [itmiFileName] = ss.[itmiFileName]
		,[fileCreateDate] = ss.[fileCreateDate]
		,[fileCreateBy] = ss.[fileCreateBy]
		,[fileModDate] = ss.[fileModDate]
		,[fileModBy] = ss.[fileModBy]
		,[matchSubjectID] = ss.[matchSubjectID]
		,[matchSpecimenID] = ss.[matchSpecimenID]
		,[fileSizeInBytes] = ss.[fileSizeInBytes]
		,[fileSizeInMB] = ss.[fileSizeInMB]
		,[fileSizeInGB] = ss.[fileSizeInGB]
		,monthCreated = ss.monthCreated
		,yearCreated = ss.yearCreated
		,fileextensiON  = ss.fileextension
		,variantType = ss.variantType
		,plate = ss.plate
		,awsVolume = ss.awsVolume
		,awsTopBucket = ss.awsTopBucket
		, ITMISubjectID  = ss.ITMISubjectID 
	    ,[orgSourceSystemID] = ss.[orgSourceSystemID]
	    ,[createDate] = ss.[createDate] 
		, [createdBy] = ss.[createdBy] 
WHEN NOT MATCHED THEN

INSERT ( 
	    [itmiFileName] 
		,filelocation
		,orgSourceSystemID
		,[fileCreateDate]
		,[fileCreateBy]
		,[fileModDate]
		,[fileModBy]
		,[matchSubjectID]
		,[matchSpecimenID]
		,[fileSizeInBytes]
		,[fileSizeInMB]
		,[fileSizeInGB]
		,monthCreated
		,yearCreated
		,fileextension
		,variantType
		,plate
		,awsVolume
		,awsTopBucket
		,createDate
		,createdBy)
VALUES (
	    ss.[itmiFileName] 
		,ss.filelocation
		,ss.orgSourceSystemID
		,ss.[fileCreateDate]
		,ss.[fileCreateBy]
		,ss.[fileModDate]
		,ss.[fileModBy]
		,ss.[matchSubjectID]
		,ss.[matchSpecimenID]
		,ss.[fileSizeInBytes]
		,ss.[fileSizeInMB]
		,ss.[fileSizeInGB]
		,ss.monthCreated
		,ss.yearCreated
		,ss.fileextension
		,ss.variantType
		,ss.plate
		,ss.awsVolume
		,ss.awsTopBucket
		,ss.createDate
		,ss.createdBy);

--*************************************		
--Match Logic for Subject--************
--*************************************

UPDATE itmidw.tblFile SET  itmiSubjectID =  left([itmiFileName],15)
FROM itmidw.tblFile
where left(itmiFileName,3) IN ('102','103')
AND itmisubjectID IS NULL

UPDATE itmidw.tblFile SET  itmiSubjectID =  left([itmiFileName],9)
FROM itmidw.tblFile
where itmisubjectID IS NULL
	AND left(itmiFileName,2) IN ('M-','F-')
	AND itmisubjectID IS NULL;

---********************************************************
---*************WGS (Illumina)*****************************
---********************************************************
Update itmidw.tblfile SET matchSubjectID  = sub.subjectID
from itmidw.tblfile f
	INNER JOIN etl.ManifestWGSIllumina_Import ill
		ON  ill.plateRowCol = f.awsTopBucket
	INNER JOIN itmidw.tblSubject sub
		ON  LTRIM(RTRIM(sub.sourceSystemIDLabel)) = 
			CASE LEFT(ill.itmiSubjectId,3) 
				WHEN '102' THEN 
				  LEFT(ill.ITMISubjectID,4) + SUBSTRING(ill.ITMISubjectID,8,12)
			WHEN '102' THEN 
				 LTRIM(RTRIM(ill.itmiSubjectID))
			ELSE 
				 LTRIM(RTRIM(ill.itmiSubjectID))
			END
WHERE awsVolume  = 'itmi.ptb.illumina'


--************************************************-- One time import*****--************************************************--************************************************--*******************************
--UPDATE [dbo].[CGIShippedGenomesData] SET itmiSubjectID = sub.subjectID FROM [dbo].[CGIShippedGenomesData] d INNER JOIN itmidw.tblSubject sub ON  sub.sourceSystemIDLabel = d.[cust# subject ID]  --**********
--ALTER TABLE [dbo].[CGIShippedGenomesData] ADD itmisubjectID INT--************************************************--************************************************--***************************************
--*****--************************************************--************************************************--************************************************--***********************************************



--************************************************
--CGI--*******************************************
--************************************************

SELECT 
	SubjectID
	, LEFT(PlateRowCol,7) AS PlateId
	, RowCol
	, PlateRowCol
	, barcode
	, CONVERT(varchar(100),NULL) AS itmiSubjectID
 INTO #ManifestWGSCGI
from dbo.manifestCGI
	WHERE barcode not in ('standardSample')

UPDATE #ManifestWGSCGI set ITMIsubjectID  = subjectID

update itmidw.tblfile set matchSubjectID = sub.subjectID
from itmidw.tblfile aws
	INNER JOIN #ManifestWGSCGI mani
		ON  SUBSTRING(aws.fileLocation,33,15)  = mani.PlateRowCol
	INNER JOIN itmidw.tblSubject sub
		ON  sub.sourceSystemIDLabel	= mani.itmisubjectID


--************************************************
--updates matchSubjectID-*************************
--************************************************

update itmidw.tblfile set matchSubjectID = d.itmiSubjectID
from itmidw.tblfile aws
	INNER JOIN [dbo].[CGIShippedGenomesData] d
		ON  SUBSTRING(aws.fileLocation,33,15)  = d.[sample ID]




--************************************************
--EA*********************************************
--************************************************


SELECT  i.fileLocatiON  AS location, i.itmiFileName AS awsfilename, i.awstopBucket AS topBucket
, CONVERT(Varchar(100),NULL) AS itmiSubjectID
INTO #eaAWSFiles
from itmidw.tblfile i
where  AWSVolume = 'itmi.ptb.ea'

UPDATE #eaAWSFiles SET  itmiSubjectID =  left(AwsfileName,15)
where left(AwsfileName,3) IN ('102','103')
	AND itmisubjectID IS NULL

UPDATE #eaAWSFiles SET  itmiSubjectID =  left(AwsfileName,9)
FROM #eaAWSFiles
where itmisubjectID IS NULL
	AND left(AwsfileName,2) IN ('M-','F-')
UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	AND (locatiON  like '%batch_ea%' or locatiON  like '%batch.batch%' or locatiON  like '%test_%' or locatiON  like '%.test%'
		or locatiON  like '%h_sapiens%')

UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	AND topBucket IN ( 'Docs', 'Living_Document')
	
UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	AND awsfileName  = ''
		

UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK - Methylation'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	AND (locatiON  like '%EA13021-Iyer (2013-06-06)%' OR locatiON  like '%EA13021/2013-06-07/23%'
	OR locatiON  like '%EA13021/2013-06-08/23%'  )

UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	AND (locatiON  like '%Image Data (%' or locatiON  like '%Generated Data %')

UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK - Methylation'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	AND LEFT(location,7) = 'EA13021'


UPDATE #eaAWSFiles SET  itmiSubjectID =  left(itmiSubjectID,14)
From #eaAWSFiles
where itmiSubjectID like '%_s%'

UPDATE #eaAWSFiles SET  itmiSubjectID =  REPLACE(itmisubjectID,'_s','')
From #eaAWSFiles
where itmiSubjectID like '%_s%'

UPDATE #eaAWSFiles SET  itmiSubjectID =  REPLACE(itmisubjectID,'_mg','')
From #eaAWSFiles
where itmiSubjectID like '%_mg%'

Update itmidw.tblfile set matchSubjectID = sub.subjectID
from itmidw.tblFile aw
	INNER JOIN itmidw.tblSubject sub
		ON  sub.sourceSystemIDLabel = 
			case sub.studyID 
				WHEN 1 THEN aw.itmiSubjectID    
				WHEN 2 THEN LEFT(aw.itmiSubjectID ,4) + SUBSTRING(aw.itmiSubjectID ,8,10) 
			END
where aw.itmisubjectID NOT LIKE '%no link%'


--************************************************
--analysisType************************************
--************************************************
UPDATE itmidw.tblFile 
	SET analysisType = 'WGS'
WHERE awsVolume = 'itmi.ptb'


UPDATE itmidw.tblFile 
	SET analysisType = 'WGS'
WHERE awsVolume = 'itmi.ptb.illumina'


UPDATE itmidw.tblFile 
	SET analysisType = 'RNAseq'
WHERE awsVolume = 'itmi.ptb.ea'
	AND LEFT(fileLocation,11) = 'GlobinClear'

	
--************************************************
--analysisType--mRNA - ***************************
--************************************************

UPDATE itmidw.tblFile 
	SET analysisType = 'microRNA'
FROM itmidw.tblFile 
WHERE awsVolume = 'itmi.ptb.ea'
	AND LEFT(fileLocation,12) = 'Small_RNASeq'


--************************************************
--analysisType--methylation***********************
--************************************************

UPDATE itmidw.tblFile 
	SET analysisType = 'methylation'
FROM itmidw.tblFile 
WHERE awsVolume = 'itmi.ptb.ea'
	AND LEFT(fileLocation,7) = 'EA13021'

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'





--************************************************
--events when files are recieved from Vendors*****
--************************************************

SELECT DISTINCT
	sub.subjectID AS [subjectID]
	, CONVERT(varchar(100),MAX(f.fileID)) AS [sourceSystemEventID]
	, CONVERT(varchar(100),'Biological File Received') AS [eventType]
	, CONVERT(varchar(100),f.analysistype) + ' - '+  CONVERT(varchar(100),CONVERT(varchar(100),sub.cohortRole)) AS [eventName]
	, dbo.DateOnly(MIN(f.fileCreateDate)) AS  eventDate
	, study.studyID AS [studyID]
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, CONVERT(VARCHAR(100),'usp_AllStudiesFile')  AS createdBy
INTO #sourceEvent
FROM itmidw.tblfile f
	INNER JOIN itmidw.tblSubject sub
		ON  sub.subjectID = f.matchSubjectID
	INNER JOIN itmidw.tblStudy study
		ON  study.studyID  = sub.studyID
GROUP BY f.awsVolume, f.analysisType, sub.subjectID, study.studyID,sub.cohortRole



--************************************************
--***************Manifest Event - Illumina********
--************************************************
INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  DISTINCT
	Sub.[subjectID] AS SubjectID
	, ill.plateRowCol
	, 'Shipping Manifest' AS [eventType]
	, sub.cohortRole + ' - Illumina'  AS [eventName]
	, '01-01-1900'
	, sub.studyID AS StudyID
    , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'ITMI AWS Illumina') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_AllStudiesFile' AS [createdBy]
	FROM etl.ManifestWGSIllumina_Import ill
		INNER JOIN itmidw.tblSubject sub
		ON  LTRIM(RTRIM(sub.sourceSystemIDLabel)) = 
			CASE LEFT(ill.itmiSubjectId,3) 
				WHEN '102' THEN 
				  LEFT(ill.ITMISubjectID,4) + SUBSTRING(ill.ITMISubjectID,8,12)
			WHEN '102' THEN 
				 LTRIM(RTRIM(ill.itmiSubjectID))
			ELSE 
				 LTRIM(RTRIM(ill.itmiSubjectID))
			END

--************************************************
--************Manifest Event - EA***********
--************************************************

INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  DISTINCT	
	Sub.[subjectID] AS SubjectID
	, ill.plateID + ' - ' + colrow
	, 'Shipping Manifest' AS [eventType]
	, sub.cohortRole + ' - EA'  AS [eventName]
	, '01-01-1900'
	, sub.studyID AS StudyID
    , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'ITMI AWS EA') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_AllStudiesFile' AS [createdBy]
	FROM dbo.manifestEa ill
		INNER JOIN itmidw.tblSubject sub
		ON  LTRIM(RTRIM(sub.sourceSystemIDLabel)) = ill.itmiSubjectId


--************************************************
--************Manifest Event - CGI***********
--************************************************

INSERT INTO #sourceEvent ([subjectID],[sourceSystemEventID],[eventType],[eventName],EventDate,[studyID],[orgSourceSystemID],[createDate],[createdBy])
SELECT  DISTINCT	
	Sub.[subjectID] AS SubjectID
	, ill.plateRowCol 
	, 'Shipping Manifest' AS [eventType]
	, sub.cohortRole + ' - CGI'  AS [eventName]
	, '01-01-1900'
	, sub.studyID AS StudyID
    , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'ITMI AWS EA') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    ,'usp_AllStudiesFile' AS [createdBy]
	FROM dbo.manifestCGI ill
		INNER JOIN itmidw.tblSubject sub
		ON  LTRIM(RTRIM(sub.sourceSystemIDLabel)) = ill.SubjectId


--************************************************
--Slowly Changing dimension***********************
--************************************************

MERGE  itmidw.[tblEvent] AS targetEvent
USING #sourceEvent sp
	ON  targetEvent.[sourceSystemEventID] = sp.[sourceSystemEventID]
	AND targetEvent.orgSourceSystemID = sp.orgSourceSystemID
	AND targetEvent.eventName = sp.eventName
	AND targetEvent.subjectID = sp.SubjectID
WHEN MATCHED
	AND (
	sp.subjectID <> targetEvent.subjectID OR
	sp.[eventType] <>targetEvent.[eventType] OR
	sp.EventDate <>targetEvent.EventDate OR
	sp.StudyID <>targetEvent.StudyID OR
	sp.createDate <> targetEvent.createDate OR 
	sp.createdBy <> targetEvent.createdBy
	)
THEN UPDATE SET
	subjectID = sp.subjectID
	, [eventType]=  sp.[eventType]
	, [eventName] = sp.[eventName]
	, EventDate = sp.EventDate
	, StudyID = sp.StudyID
	, createDate = sp.createDate
	, createdBy = sp.createdBy
WHEN NOT MATCHED THEN
INSERT ([subjectID],[sourceSystemEventID],[eventType],[eventName],eventDate,[studyID],[createDate],[createdBy] ,[orgSourceSystemID])
VALUES (sp.[subjectID],sp.[sourceSystemEventID],sp.[eventType],sp.[eventName],sp.eventDate,sp.[studyID],sp.[createDate],sp.[createdBy] ,sp.[orgSourceSystemID]);


PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'



--************************************************
----inserting into rules table********************
--************************************************
INSERT INTO itmidw.[tblEventRules]([eventName] ,[eventRuleName],[eventRuleValue],[eventRuleOrder],[studyID],[orgSourceSystemID],[createDate] ,[createdBy])
SELECT  
DISTINCT eve.eventName, 'Event Order', NULL, NULL
	, (SELECT stud.studyID FROM itmidw.tblStudy stud WHERE stud.studyshortID like '%102%') AS StudyID
	, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') AS orgSourceSystemID
	, GETDATE() AS createDate
	, 'usp_Study102Event'  AS createdBy
from itmidw.[tblEvent] eve
	INNER JOIN itmidw.tblsubject sub
		ON  sub.subjectID = eve.subjectID
	INNER JOIN itmidw.tblSubjectOrganizationMap orgMap
		ON  orgMap.subjectID = sub.subjectID
	INNER JOIN itmidw.tblOrganizatiON  org
		ON  org.organizationID = orgMap.organizationID
	INNER JOIN itmidw.tblOrganizationType orgType
		ON  orgType.organizationTypeID = org.organizationTypeID
			AND orgType.organizationTypeName = 'Family'
	LEFT JOIN itmidw.[tblEventRules] eveExist
		ON  eveExist.eventName = eve.eventName	
			AND eveExist.eventRuleName = 'Event Order'
WHERE eveExist.eventRulesID IS NULL


END

