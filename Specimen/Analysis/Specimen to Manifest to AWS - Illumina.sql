use itmistaging
GO
--delete from dbo.ManifestWGSIllumina where ISNUMERIC(f1) = 0

---********************************************************
---*************WGS (Illumina)*****************************
---********************************************************

---********************************************************
---*************Specimen (sdb)*****************************
---********************************************************

DROP TABLE #illSpecimen
DROP TABLE #ManifestWGSIllumina
DROP TABLE #awsFiles

GO

--102, 103
SELECT 
		barcode
		, [row]
		, col
		, study_subject_number
		, study_name
		, CONVERT(Varchar(100),NULL) as itmiSubjectID
	INTO #illSpecimen
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
		and et.extraction_name = 'DNA'
--101
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

update #illSpecimen set itmiSubjectID = study_subject_number


---********************************************************
---*************Manifest***********************************
---********************************************************

select 
	[itmiSubjectID] as SubjectID
,  PlateId
,  RowCol
,  PlateRowCol
, CONVERT(varchar(100),NULL) as itmiSubjectID
INTO #ManifestWGSIllumina
from dbo.ManifestWGSIllumina 

--** this happens when not all the plate is filled with samples, but import brought in columns.
--select plateID, count(*)
--from #ManifestWGSIllumina
--where subjectID is NULL

update #ManifestWGSIllumina set itmiSubjectID = SubjectID
where subjectID IS NOT NULL


---********************************************************
---*************AWS Files**********************************
---********************************************************

select  awsfilename, topBucket, CONVERT(Varchar(100),NULL) as itmiSubjectID, CONVERT(varchar(100),NULL) as maniBarcode
,i.AWSdateCreated, i.sizeInBytes, i.location
INTO #awsFiles
from itmiAWSFile i
where  AWSVolume =    'itmi.ptb.illumina'

update #awsFiles set itmiSubjectID = wgsman.itmiSubjectID
from #awsFiles aws
	INNER JOIN #ManifestWGSIllumina wgsMan
		ON wgsman.PlateRowCol = aws.topBucket

update #awsFiles set itmiSubjectID = 'NO LINK'
from #awsFiles aws
where topBucket IN
('$RECYCLE.BIN', 'DataDeliveryManifest_08092013.xlsx','Docs','Genotyping_Files_Omni2.5'
, 'SIGNATURE.txt','System Volume Information')
or
(LEFT(topbucket,7) = 'Import-')
OR
(LEFT(topbucket,10) = 's3-import-')



--SELECT *
--from #awsFiles aws
--where itmiSubjectID is null
--and  LEFT(topBucket,9)
--IN ('LP6005599','LP6005671','LP6005601','LP6005600')
--ORDER BY topbucket

--select LEFT(topbucket,9),count(*)
--from #awsFiles aws
--where itmiSubjectID is null
--group by LEFT(topbucket,9)
--order by LEFT(topbucket,9)



---********************************************************
---*************Validation*********************************
---********************************************************

UPDATE #AWSFiles set maniBarcode = m.PlateRowCol
from #AWSFiles f
	INNER JOIN #ManifestWGSIllumina m
		on LTRIM(RTRIM(m.itmiSubjectID)) = LTRIM(RTRIM(f.itmiSubjectID))
WHERE ISNULL(f.itmiSubjectID,'') not LIKE '%no link%'




/**/

---********************************************************
---*************Details************************************
---********************************************************

--truncate table itmidw.dbo.[tblFile]
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
,10 --itmi aws
           --,<matchSubjectID, int,>
, sub.subjectID
           --,<matchSpecimenID, int,>
, NULL
           --,<fileSizeInBytes, float,>)
, aw.sizeInBytes
           --,<fileSizeInMB, float,>)
, ROUND(aw.sizeInBytes / 1024,3)
		   --,<fileSizeInGB, float,>)
, ROUND(aw.sizeInBytes / 1024/1024 , 3)from #AWSFiles aw
	INNER JOIN itmidw.dbo.tblSubject sub
		ON sub.sourceSystemIDLabel = 
			case sub.studyID 
				WHEN 1 THEN aw.itmiSubjectID    
				WHEN 2 THEN LEFT(aw.itmiSubjectID ,4) + SUBSTRING(aw.itmiSubjectID ,8,10) 
			END
where itmisubjectID NOT LIKE '%no link%'




USE [ITMIDW]
GO
--delete from [dbo].[tblEvent] where eventtype = 'Ill Data Recieved'
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
, 'Ill Data Recieved'
           --,<eventName, varchar(200),>
, 'Ill Data Recieved'
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
where files.fileSourceSystem = 10
