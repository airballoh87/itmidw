IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AllStudyAWSFileEnrichment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].usp_AllStudyAWSFileEnrichment
GO
/**************************************************************************
Created On : 3/29/2014
Created By : Aaron Black
Team Name : Informatics
Object name : usp_AllStudyAWSFileEnrichment
Functional : ITMI SSIS for Enrichment of AWS file data that is brought into wareshouse
Purpose : This helps strip out information from raw data to allow for reporting and analysis
History : Created on 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_AllStudyAWSFileEnrichment]
--checking both delete and insert component of slowing changing dimension

**************************************************************************/
CREATE PROCEDURE [dbo].usp_AllStudyAWSFileEnrichment
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_AllStudyAWSFileEnrichment][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'




--************************************
--finding the top Bucket
--************************************
UPDATE ITMISTaging.[aws].[itmiAWSFile] SET topBucket = 
CASE WHEN	
	CHARINDEX('/',location) =0
		THEN location
	ELSE 
	SUBSTRING(location, 1,CHARINDEX('/',location)-1)
END
FROM ITMISTaging.[aws].[itmiAWSFile]
WHERE topBucket IS NULL

--************************************
--finding the file name
--************************************
UPDATE ITMISTaging.[aws].[itmiAWSFile] SET AwsfileName = 
CASE WHEN	
	CHARINDEX('/',location) =0
		THEN location
	ELSE 
 SUBSTRING(location, (LEN(location) - CHARINDEX('/',reverse(location)))+2, CHARINDEX('/',reverse(location)))
END 
FROM ITMISTaging.[aws].[itmiAWSFile]
WHERE AwsfileName IS NULL


--************************************
--updating the date format and spliting into month and year
--************************************
UPDATE ITMISTaging.[aws].[itmiAWSFile] SET AWSdateCreated  = CONVERT(DATE,(RTRIM(LTRIM(LEFT(dateCreated,11))))) WHERE AWSdateCreated IS NULL
UPdate [itmiAWSFile] SET monthCreated  = MONTH(AWSdateCreated) WHERE monthCreated IS NULL
UPdate [itmiAWSFile] SET yearCreated  = YEAR(AWSdateCreated)WHERE yearCreated IS NULL


--************************************
--setting the file extension
--************************************
UPDATE ITMISTaging.[aws].[itmiAWSFile] SET fileextension = 
LTRIM(RTRIM(CASE WHEN	
	CHARINDEX('.',location) =0
		THEN 'No Extension'
	ELSE 
 SUBSTRING(location, (LEN(location) - CHARINDEX('.',reverse(location)))+2, CHARINDEX('.',reverse(location)))
END ))
FROM ITMISTaging.[aws].[itmiAWSFile]
WHERE fileextension  IS NULL


--************************************
--finding the variant type for biologicial files
--************************************
UPDATE ITMISTaging.[aws].[itmiAWSFile] SET variantType = 'Copy Number'
--select *
FROM ITMISTaging.[aws].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%CNV.%'


UPDATE ITMISTaging.[aws].[itmiAWSFile] SET variantType = 'Single Variant'
--select *
FROM ITMISTaging.[aws].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%SV.%'
	and awsvolume = 'itmi.ptb.illumina'


UPDATE ITMISTaging.[aws].[itmiAWSFile] SET variantType = 'Indels'
FROM ITMISTaging.[aws].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%indels.%'


UPDATE ITMISTaging.[aws].[itmiAWSFile] SET variantType = 'Bams'
FROM ITMISTaging.[aws].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%.bam%'

UPDATE ITMISTaging.[aws].[itmiAWSFile] SET variantType = 'SNPs'
FROM ITMISTaging.[aws].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%snps.%'


UPDATE ITMISTaging.[aws].[itmiAWSFile] SET variantType = 'Genotyping'
FROM ITMISTaging.[aws].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%genotyping.%'


UPDATE ITMISTaging.[aws].[itmiAWSFile] SET variantType = 'Genome'
FROM ITMISTaging.[aws].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%genome.%'


--************************************
--update plate for Illumina
--************************************

UPDATE ITMISTaging.[aws].[itmiAWSFile] SET Plate =  LEFT(topBucket, charindex('-DNA',topBucket,1)-1)
FROM ITMISTaging.[aws].[itmiAWSFile]
WHERE LEFT(topBucket,2) = 'LP'


END