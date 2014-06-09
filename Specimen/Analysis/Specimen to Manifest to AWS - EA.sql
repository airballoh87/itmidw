use itmistaging
GO
--/*

--ALTER table itmistaging.dbo.manifestEa add convertedITMISubjectID VARCHAR(20)
---********************************************************
---************EA******************************************
---********************************************************

---********************************************************
---*************Specimen (sdb)*****************************
---********************************************************

--101,102
DROP TABLE #eaSpecimen
DROP TABLE #manifestEA
DROP TABLE #eaAWSFiles

GO
SELECT 
		barcode
		, [row]
		, col
		, study_subject_number
		, study_name
		, CONVERT(Varchar(100),NULL) as itmiSubjectID
	INTO #eaSpecimen
--***********
	FROM (
	select 
		cont.barcode
		, cont.[row]
		, cont.col
		, sub.study_subject_number
		, stud.study_name
		--select *
	from sdb.Container cont
		INNER JOIN sdb.Extraction_Type et 
			on et.extraction_type_id = cont.extraction_type_id
		inner join sdb.study stud
			on stud.study_id = cont.study_id
		inner join sdb.subject sub
			on sub.subject_id = cont.subject_id
	where cont.deprecated = 0
		and cont.extraction_type_id is not null
		and et.extraction_name IN ( 'RNA','DNA')
		---101

UNION ALL
	select
		NULL as barcode
		, NULL as [row]
		, NULL as [col]
		, [mothers study id]
		, '101 Mom'
	from spoint101.[EDC101Mother]
	UNION ALL
	select
		NULL as barcode
		, NULL as [row]
		, NULL as [col]
		, [Fathers Study ID]
		, '101 Father'
	from spoint101.[EDC101Father]
	UNION ALL
	select
		NULL as barcode
		, NULL as [row]
		, NULL as [col]
		, [infants study id]
		, '101 Newborn'
	from spoint101.[EDC101Newborn]
)
as A


--
UPDATE #eaSpecimen set itmiSubjectID = study_subject_number
where left(study_subject_number,3) IN ( '102','103')

UPDATE #eaSpecimen set itmiSubjectID = study_subject_number
FROM #eaSpecimen
where itmiSubjectID IS NULL
	and LEFT(study_subject_number,1) IN ('M','F', 'N')



---********************************************************
---*************EA Manifest********************************
---********************************************************
select
	itmiSubjectID as SubjectID
	, barcode
	, plateId
	, ColRow
	, CONVERT(varchar(100),NULL) as itmiSubjectID
	into #manifestEA
from manifestEa

Update #manifestEA set ITMIsubjectID  = subjectID

Update #manifestEA set ITMIsubjectID = 
	replace(replace(replace(replace(replace (subjectID, '_dm',''),'_s',''),'_mg',''),'mg',''),'_dna','')
from #manifestEA
where  subjectID like '%_dm%' or subjectID like '%_mg%' or subjectID like '%_s%' or subjectID like '%_dna%'



--select * FROM #manifestEA
---********************************************************
---*************EA AWS Files**********************************
---********************************************************
select  location,awsfilename, topBucket, CONVERT(varchar(100),NULL) as maniBarcode, CONVERT(Varchar(100),NULL) as itmiSubjectID
,i.AWSdateCreated, i.sizeInBytes
INTO #eaAWSFiles
from itmiAWSFile i
where  AWSVolume = 'itmi.ptb.ea'

UPDATE #eaAWSFiles SET  itmiSubjectID =  left(AwsfileName,15)
where left(AwsfileName,3) IN ('102','103')
	and itmisubjectID IS NULL

UPDATE #eaAWSFiles SET  itmiSubjectID =  left(AwsfileName,9)
FROM #eaAWSFiles
where itmisubjectID IS NULL
	and left(AwsfileName,2) IN ('M-','F-')

UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	and (location like '%batch_ea%' or location like '%batch.batch%' or location like '%test_%' or location like '%.test%'
		or location like '%h_sapiens%')

UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	and topBucket IN ( 'Docs', 'Living_Document')
	
UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	and awsfileName  = ''
		

UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK - Methylation'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	and (location like '%EA13021-Iyer (2013-06-06)%' OR location like '%EA13021/2013-06-07/23%'
	OR location like '%EA13021/2013-06-08/23%'  )

UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	and (location like '%Image Data (%' or location like '%Generated Data %')

UPDATE #eaAWSFiles SET  itmiSubjectID =  'NO LINK - Methylation'
FROM #eaAWSFiles
where itmisubjectID IS NULL
	and LEFT(location,7) = 'EA13021'


UPDATE #eaAWSFiles SET  itmiSubjectID =  left(itmiSubjectID,14)
From #eaAWSFiles
where itmiSubjectID like '%_s%'

UPDATE #eaAWSFiles SET  itmiSubjectID =  REPLACE(itmisubjectID,'_s','')
From #eaAWSFiles
where itmiSubjectID like '%_s%'

UPDATE #eaAWSFiles SET  itmiSubjectID =  REPLACE(itmisubjectID,'_mg','')
From #eaAWSFiles
where itmiSubjectID like '%_mg%'


--SELECT * FROM #eaAWSFiles where itmisubjectID IS NULL ORDER BY location,awsfilename
--select * FROM #manifestEA

---********************************************************
---*************Validation*********************************
---********************************************************

--*/
UPDATE #eaAWSFiles set maniBarcode = m.barcode
from #eaAWSFiles f
	LEFT JOIN #manifestEA m
		on LTRIM(RTRIM(m.itmiSubjectID)) = LTRIM(RTRIM(f.itmiSubjectID))
WHERE ISNULL(f.itmiSubjectID,'') not LIKE '%no link%'




---********************************************************
---*************Insert into File************************************
---********************************************************
/*
*/

INSERT INTO itmidw.dbo.[tblFile]([itmiFileName],[fileLocation],[fileCreateDate],[fileCreateBy],[fileModDate],[fileModBy],[fileSourceSystem],[matchSubjectID],[matchSpecimenID],[FileSizeinbytes],fileSizeInMB,fileSizeInGB)
SELECT
           --(<itmiFileName, varchar(255),>
aw.AwsfileName
           --,<fileLocation, varchar(555),>
, aw.location
           --,<fileCreateDate, datetime,>
, aw.AWSdateCreated
           --,<fileCreateBy, datetime,>
, NULL
           --,<fileModDate, datetime,>
, NULL
           --,<fileModBy, datetime,>
, NULL
           --,<fileSourceSystem, int,>
,8 --itmi aws
           --,<matchSubjectID, int,>
, sub.subjectID
           --,<matchSpecimenID, int,>
, NULL
           --,<fileSizeInBytes, float,>)
, aw.sizeInBytes
           --,<fileSizeInMB, float,>)
, ROUND(aw.sizeInBytes / 1024,3)
		   --,<fileSizeInGB, float,>)
, ROUND(aw.sizeInBytes / 1024/1024 , 3)
--select *
from #eaAWSFiles aw
	INNER JOIN itmidw.dbo.tblSubject sub
		ON sub.sourceSystemIDLabel = 
			case sub.studyID 
				WHEN 1 THEN aw.itmiSubjectID    
				WHEN 2 THEN LEFT(aw.itmiSubjectID ,4) + SUBSTRING(aw.itmiSubjectID ,8,10) 
			END
where itmisubjectID NOT LIKE '%no link%'
	--and sub.subjectID IS NULL



GO

USE [ITMIDW]
GO
--delete from [dbo].[tblEvent] where eventtype = 'EA File Recieved'

INSERT INTO [dbo].[tblEvent]
           ([subjectID]
           ,[sourceSystemEventID]
           ,[eventType]
           ,[eventName]
           ,[studyID]
           ,[orgSourceSystemID]
           ,[createDate]
           ,[createdBy])
SELECT DISTINCT
           --(<subjectID, int,>
subject.SubjectID
           --,<sourceSystemEventID, varchar(50),>
, 1
           --,<eventType, varchar(20),>
, 'EA File Recieved'
           --,<eventName, varchar(200),>
, 'EA File Recieved'
           --,<studyID, varchar(50),>
, subject.studyID
           --,<orgSourceSystemID, int,>
, files.fileSourceSystem
           --,<createDate, datetime,>
, getdate()
           --,<createdBy, varchar(20),>)
,'adb: SQL Script'
--select top 100*
FROM tblfile files
	INNER JOIN Tblsubject subject
		on subject.subjectID = files.matchSubjectID
where files.fileSourceSystem = 8

	
