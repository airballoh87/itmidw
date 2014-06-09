/*
select 
	sum(fileSizeInBytes)
	/1024/1024/1024/1024
select COUNT(*) from  itmidw.tblFile aws
where awsVolume = 'itmi.ptb.ea'

select 	
 variantType

, awsVolume 
, ROUND(sum(SizeInBytes)/1024/1024/1024/1024,2)
from aws.itmiAWSFile
GROUP BY  variantType

, awsVolume 
ORDER  BY 
 variantType

, awsVolume 

--where awsVolume = 'itmi.ptb.raw.glacier'




SELECT 
	ROUND(SUM(fileSizeInGB),2) sumInGB
	, ROUND(SUM(fileSizeInGB/1024),2) sumInTB
	, ROUND(SUM(fileSizeInGB/1024/1024),2) sumInPB
	, awsVolume
	, analysisType
	
FROM  itmidw.tblFile aws
GROUP BY  awsVolume, analysisType
ORDER BY  awsVolume , analysisType




SELECT 
ROUND(SUM(fileSizeInGB),2) sumInGB
,ROUND(SUM(fileSizeInGB/1024),2) sumInTB
,ROUND(SUM(fileSizeInGB/1024/1024),2) sumInPB
, awsVolume
from  itmidw.tblFile aws
GROUP BY  awsVolume 
ORDER BY  awsVolume



SELECT 
ROUND(SUM(fileSizeInGB),2) sumInGB
,ROUND(SUM(fileSizeInGB/1024),2) sumInTB
,ROUND(SUM(fileSizeInGB/1024/1024),2) sumInPB
from  itmidw.tblFile aws
WHERE awsVolume = 'itmi.ptb.ea'

*/


--SELECT  
--	 awsTopBucket
--	, COUNT(*) as fileCnt
--	, CASE WHEN LEFT(awstopbucket,2) = 'GS' THEN SUBSTRING(filelocation,33,15) ELSE plate END as plate
--FROM itmidw.tblFile aws
--WHERE matchSubjectID IS NULL
--	and itmifileName not like '%manifest%'
--	and itmifileName not like '%readme%'
--	and awsTopBucket not IN ('$RECYCLE.BIN','Docs','EA13021','Genotyping_Files_Omni2.5','GlobinClear''Living_Document','Small_RNASeq','System Volume Information','test_arena','Living_Document','GlobinClear')
--	GROUP BY awsTopBucket,CASE WHEN LEFT(awstopbucket,2) = 'GS' THEN SUBSTRING(filelocation,33,15) ELSE plate END
--	ORDER BY  CASE WHEN LEFT(awstopbucket,2) = 'GS' THEN SUBSTRING(filelocation,33,15) ELSE plate END ,awsTopBucket

--select *
--FROM itmidw.tblFile aws
--where awstopbucket = 'GS000009353-DID'
----'LP6005815'
----'LP6005891'
----'LP6005636'

----SELECT Plate
----, COUNT(*)
----FROM (
--	select  
--		 SUBSTRING(aws.filelocation,33,15) as PlateColRow
--		, SUBSTRING(aws.filelocation,33,11) as Plate
--		, MIN(matchsubjectID) as minSubjectID
--		, MAX(matchsubjectID) as MaxSubjectID
--		, COUNT(*)
--	from itmidw.tblFile aws
--	where  AWSVolume = 'itmi.ptb'
--		--and matchsubjectID IS NULL
--		and itmifileName not like '%manifest%'
--		and itmifileName not like '%readme%'
--	GROUP BY 		 
--		SUBSTRING(aws.filelocation,33,15) 
--		, SUBSTRING(aws.filelocation,33,11)
--	ORDER BY SUBSTRING(aws.filelocation,33,15) 

		
----) as A
----	GROUP BY plate

--SELECT 
--	awstopBucket
--	,plate
--	, MIN(matchsubjectID) as minSubjectID
--	, MAX(matchsubjectID) as MaxSubjectID
--	, COUNT(*) fileCnt
--from itmidw.tblFile aws
--where  AWSVolume = 'itmi.ptb.illumina'
--		and LEFT(awstopBucket,2) = 'LP'
--	GROUP BY awstopBucket	,plate
--	ORDER BY awstopBucket	,plate


--SELECT 
--	aws.awsVolume
--	, aws.monthCreated
--	, aws.yearCreated
--	, CONVERT(varchar(10),aws.yearCreated) + '-'+ CONVERT(varchar(10),
--		CASE 
--			WHEN LEN(aws.monthCreated) = 1 
--				THEN '0' + CONVERT(varchar(2),aws.monthcreated)
--			ELSE CONVERT(varchar(100),aws.monthcreated) END 
--		)
--	 AS groupDate
--	, ROUND(SUM(aws.sizeInBytes),2) sizeInBytes
--	, ROUND(SUM(aws.sizeInBytes)/1024,2) sizeInKB
--	, ROUND(SUM(aws.sizeInBytes)/1024/1024,2) sizeInMB
--	, ROUND(SUM(aws.sizeInBytes)/1024/1024/1024,2) sizeInGB
--	, ROUND(SUM(aws.sizeInBytes)/1024/1024/1024/1024,2) sizeInTB
--	, ROUND(SUM(aws.sizeInBytes)/1024/1024/1024/1024/1024,2) sizeInPB
--FROM [aws].[itmiAWSFile] aws
--GROUP BY 
--	aws.awsVolume
--	, aws.monthCreated
--	, aws.yearCreated
--	, CONVERT(varchar(10),aws.yearCreated) + '-'+ CONVERT(varchar(10),aws.monthCreated)
--ORDER BY 
--		CONVERT(varchar(10),aws.yearCreated) + '-'+ CONVERT(varchar(10),
--		CASE 
--			WHEN LEN(aws.monthCreated) = 1 
--				THEN '0' + CONVERT(varchar(2),aws.monthcreated)
--			ELSE CONVERT(varchar(100),aws.monthcreated) END 
--		)
--		, aws.awsVolume


SELECT 
	aws.awsVolume
	, aws.monthCreated
	, aws.yearCreated
	, CONVERT(varchar(10),aws.yearCreated) + '-'+ CONVERT(varchar(10),
		CASE 
			WHEN LEN(aws.monthCreated) = 1 
				THEN '0' + CONVERT(varchar(2),aws.monthcreated)
			ELSE CONVERT(varchar(100),aws.monthcreated) END 
		)
	 AS groupDate
	, ROUND(SUM(aws.filesizeInBytes),2) sizeInBytes
	, ROUND(SUM(aws.filesizeInBytes)/1024,2) sizeInKB
	, ROUND(SUM(aws.filesizeInBytes)/1024/1024,2) sizeInMB
	, ROUND(SUM(aws.filesizeInBytes)/1024/1024/1024,2) sizeInGB
	, ROUND(SUM(aws.filesizeInBytes)/1024/1024/1024/1024,2) sizeInTB
	, ROUND(SUM(aws.filesizeInBytes)/1024/1024/1024/1024/1024,2) sizeInPB
	, ISNULL(aws.analysisType,'None') as analysistype
FROM itmidw.[tblFile] aws
GROUP BY 
	aws.awsVolume
	, aws.monthCreated
	, aws.yearCreated
	, CONVERT(varchar(10),aws.yearCreated) + '-'+ CONVERT(varchar(10),aws.monthCreated)
	, ISNULL(aws.analysisType,'None')
ORDER BY 
		CONVERT(varchar(10),aws.yearCreated) + '-'+ CONVERT(varchar(10),
		CASE 
			WHEN LEN(aws.monthCreated) = 1 
				THEN '0' + CONVERT(varchar(2),aws.monthcreated)
			ELSE CONVERT(varchar(100),aws.monthcreated) END 
		)
		, aws.awsVolume


select 
	awsVolume
	, matchSubjectID
from itmidw.[tblFile] aws
group by awsVolume
	, matchSubjectID
