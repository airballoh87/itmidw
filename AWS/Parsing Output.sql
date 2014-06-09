--ALTER TABLE [itmiAWSFile] ADD topBucket varchar(200)
/*

UPDATE [dbo].[itmiAWSFile] SET topBucket = 
CASE WHEN	
	CHARINDEX('/',location) =0
		THEN location
	ELSE 
	SUBSTRING(location, 1,CHARINDEX('/',location)-1)
END
FROM [dbo].[itmiAWSFile]
WHERE topBucket IS NULL

--ALTER TABLE [itmiAWSFile] add AwsfileName varchar(500)

UPDATE [dbo].[itmiAWSFile] SET AwsfileName = 
CASE WHEN	
	CHARINDEX('/',location) =0
		THEN location
	ELSE 
 SUBSTRING(location, (LEN(location) - CHARINDEX('/',reverse(location)))+2, CHARINDEX('/',reverse(location)))
END 
FROM [dbo].[itmiAWSFile]
WHERE AwsfileName IS NULL


--ALTER TABLE [itmiAWSFile] ADD AWSdateCreated DATETIME
UPDATE [dbo].[itmiAWSFile] SET AWSdateCreated  = CONVERT(DATE,(RTRIM(LTRIM(LEFT(dateCreated,11))))) WHERE AWSdateCreated IS NULL

--ALTER TABLE [itmiAWSFile] ADD monthCreated INT
--ALTER TABLE [itmiAWSFile] ADD yearCreated INT



UPdate [itmiAWSFile] SET monthCreated  = MONTH(AWSdateCreated) WHERE monthCreated IS NULL
UPdate [itmiAWSFile] SET yearCreated  = YEAR(AWSdateCreated)WHERE yearCreated IS NULL



--ALTER TABLE [itmiAWSFile] ADD  fileextension varchar(200)

UPDATE [dbo].[itmiAWSFile] SET fileextension = 
LTRIM(RTRIM(CASE WHEN	
	CHARINDEX('.',location) =0
		THEN 'No Extension'
	ELSE 
 SUBSTRING(location, (LEN(location) - CHARINDEX('.',reverse(location)))+2, CHARINDEX('.',reverse(location)))
END ))
FROM [dbo].[itmiAWSFile]
WHERE fileextension  IS NULL

--SELECT * FROM [dbo].[itmiAWSFile]

--ALTER TABLE [itmiAWSFile] ADD variantType varchar(50)


UPDATE [dbo].[itmiAWSFile] SET variantType = 'Copy Number'
--select *
FROM [dbo].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%CNV.%'


UPDATE [dbo].[itmiAWSFile] SET variantType = 'Single Variant'
--select *
FROM [dbo].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%SV.%'
	and awsvolume = 'itmi.ptb.illumina'




UPDATE [dbo].[itmiAWSFile] SET variantType = 'Indels'
--select *
FROM [dbo].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%indels.%'


UPDATE [dbo].[itmiAWSFile] SET variantType = 'Bams'
--select *
FROM [dbo].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%.bam%'



UPDATE [dbo].[itmiAWSFile] SET variantType = 'SNPs'
--select *
FROM [dbo].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%snps.%'


UPDATE [dbo].[itmiAWSFile] SET variantType = 'Genotyping'
--select *
FROM [dbo].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%genotyping.%'


UPDATE [dbo].[itmiAWSFile] SET variantType = 'Genome'
--select *
FROM [dbo].[itmiAWSFile]
where variantType IS NULL 
	and awsfilename like '%genome.%'



ALTER TABLE [itmiAWSFile] ADD Plate varchar(200)


UPDATE [dbo].[itmiAWSFile] SET Plate =  LEFT(topBucket, charindex('-DNA',topBucket,1)-1)

FROM [dbo].[itmiAWSFile]
WHERE LEFT(topBucket,2) = 'LP'


-- by volume 
select 
aws.AWSVOLUME
, sum(sizeInbytes)/1024 as SumOfKB
,sum(sizeInbytes)/1024/1024 as SumOfMB
,ROUND(sum(sizeInbytes)/1024/1024/1024,3) as SumOfGB
,ROUND(sum(sizeInbytes)/1024/1024/1024/1024,3) as SumOfTB
,ROUND(sum(sizeInbytes)/1024/1024/1024/1024/1024,3) as SumOfTB
from itmiAWSFile aws
GROUP BY aws.AWSVOLUME
ORDER BY 
ROUND(sum(sizeInbytes)/1024/1024/1024,3)DESC

--by year \ month
select 
aws.MonthCreated
,aws.YearCreated
, sum(sizeInbytes)/1024 as SumOfKB
,sum(sizeInbytes)/1024/1024 as SumOfMB
,ROUND(sum(sizeInbytes)/1024/1024/1024,3) as SumOfGB
,ROUND(sum(sizeInbytes)/1024/1024/1024/1024,3) as SumOfTB
,ROUND(sum(sizeInbytes)/1024/1024/1024/1024/1024,3) as SumOfTB
from itmiAWSFile aws
GROUP BY 
aws.YearCreated,
aws.MonthCreated
ORDER BY 
aws.YearCreated,
aws.MonthCreated



--by fileExtension
*/	
select 
aws.fileextension
, sum(sizeInbytes)/1024 as SumOfKB
,sum(sizeInbytes)/1024/1024 as SumOfMB
,ROUND(sum(sizeInbytes)/1024/1024/1024,3) as SumOfGB
,ROUND(sum(sizeInbytes)/1024/1024/1024/1024,3) as SumOfTB
,ROUND(sum(sizeInbytes)/1024/1024/1024/1024/1024,3) as SumOfTB
from itmiAWSFile aws
GROUP BY 

aws.fileextension
ORDER BY 
ROUND(sum(sizeInbytes)/1024/1024/1024,3)DESC