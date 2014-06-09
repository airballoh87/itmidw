/*
--List of volumes and files
select [AWSVolume] ,COUNT(*)
from [dbo].[itmiAWSFile]
GROUP BY [AWSVolume] 


select [File Extension],COUNT(*), AVG([File Size(GBbytes)])
from [dbo].[vwitmiAWSFiles]
where [AWS Volume] = 'itmi.ptb.illumina'
	and [File Extension] = 'bam'
GROUP BY [File Extension]

select avg(sizeInGB) * 2400 as avgSize, MIN(sizeInGB), MAX(sizeInGB)
FROM (
select [Top Bucket],COUNT(*) as fileCnt,SUM([File Size(GBbytes)])  as sizeInGB
from [dbo].[vwitmiAWSFiles]
where [AWS Volume] = 'itmi.ptb.illumina'
	AND LEFT([top bucket],2) = 'LP'
	and [Top Bucket] <> 'LP6005638-DNA_B03'
GROUP BY [Top Bucket]
) as A

select 
[FileExtension]
,COUNT(*) as cntOfFiles
,ROUND(avg(sizeInbytes)/1024/1024/1024,3) as AvgOfGB
,ROUND(sum(sizeInbytes)/1024/1024,3) as SumOfMB
,ROUND(avg(sizeInbytes)/1024/1024,2) as avgOfMB
,ROUND(sum(sizeInbytes)/1024/1024/1024,3) as SumOfGB
,ROUND(sum(sizeInbytes)/1024/1024/1024/1024,3) as SumOfTB
,ROUND(sum(sizeInbytes)/1024/1024/1024/1024/1024,3) as SumOfPT
from itmiAWSFile
where  AWSVolume =    'itmi.ptb'
GROUP BY [FileExtension]

select avg(numOfFiles) as avgNoFiles, Avg(SumOfGB) as avgGBperFiles, count(*) as NumberOfSpecimens
FROM (
select 
	topbucket
	, count(*) as NumOfFiles
	, sum(sizeinbytes) suminBytes
	, ROUND(sum(sizeInbytes)/1024/1024/1024,3) as SumOfGB
from itmiAWSFile
where  AWSVolume =    'itmi.ptb'
group by topbucket
) as a


*/
WITH itmiPTB as (
select sizeinbytes, awsfilename
from itmiAWSFile i
where  AWSVolume =    'itmi.ptb'
 and topBucket = 'GS000009122-DID'
 )
 , itmiPTBGlacier  as (
select sizeinbytes , awsfilename
from itmiAWSFile i
where  AWSVolume =    'itmi.ptb.raw.glacier'
 and topBucket = 'GS000009122-DID'
 )

 select 
	glacier.AwsfileName as glacierSize, glacier.sizeInBytes as glacierSize
	, itmiPTB.AwsfileName as ITMIptbFileName, itmiPTB.sizeinBytes as ITMIsizeInBytes
 from itmiPTBGlacier glacier
	FULL OUTER JOIN itmiPTB	
		on glacier.awsfilename = itmiPTB.awsfilename
ORDER BY  itmiPTB.AwsfileName desc, glacier.AwsfileName