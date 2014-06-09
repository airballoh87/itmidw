use itmistaging
GO
--delete from dbo.ManifestWGSIllumina where ISNUMERIC(f1) = 0

---********************************************************
---*************WGS (CGi)*****************************
---********************************************************

---********************************************************
---*************Specimen (sdb)*****************************
---********************************************************

DROP TABLE #cgiSpecimen
DROP TABLE #ManifestWGSCGI
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
	INTO #cgiSpecimen
--***********
	FROM (
--101
	select
		NULL as barcode
		, NULL as [row]
		, NULL as [col]
		, [mothers study id] as study_name
		, '101 Mom' as study_subject_number
	from [spoint101].[EDC101Mother]
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

update #cgiSpecimen set itmiSubjectID = study_subject_number

---********************************************************
---*************Manifest***********************************
---********************************************************

select 
	SubjectID
	, LEFT(PlateRowCol,7) as PlateId
	, RowCol
	, PlateRowCol
	, barcode
	, CONVERT(varchar(100),NULL) as itmiSubjectID
 INTO #ManifestWGSCGI
from manifestCGI
	WHERE barcode not in ('standardSample')

UPDATE #ManifestWGSCGI set ITMIsubjectID  = subjectID

---********************************************************
---*************AWS Files**********************************
---********************************************************

select  
	awsfilename
	, topBucket
	, CONVERT(Varchar(100),NULL) as itmiSubjectID
	, CONVERT(varchar(100),NULL) as maniBarcode
	, i.AWSdateCreated
	, i.sizeInBytes
	, i.location
	, SUBSTRING(i.location,33,15) as PlateColRow
	--GS000020156-DID/GS000015801-ASM/GS01731-DNA_E01/ASM/REF/coverageRefScore-chr14-GS000015801-ASM.tsv.bz2
into #awsFiles
from itmiAWSFile i
where  AWSVolume = 'itmi.ptb'
	and LEFT(SUBSTRING(i.location,33,7),2) = 'GS' --everything else is a manifest or read me file.

update #awsFiles set itmiSubjectID = mani.itmiSubjectID
from #awsFiles aws
	INNER JOIN #ManifestWGSCGI mani
		on aws.platecolrow = mani.PlateRowCol



---********************************************************
---*************Validation*********************************
---********************************************************

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
,9 --itmi aws
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
--select itmiSubjectID    ,*
from #AWSFiles aw
	INNER JOIN itmidw.dbo.tblSubject sub
		ON sub.sourceSystemIDLabel = 
			case sub.studyID 
				WHEN 1 THEN aw.itmiSubjectID    
				WHEN 2 THEN LEFT(aw.itmiSubjectID ,4) + SUBSTRING(aw.itmiSubjectID ,8,10) 
			END
where itmisubjectID NOT LIKE '%no link%'
	


USE [ITMIDW]
GO
--delete from tblevent where orgSourceSystemID IN (8,9,10)
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
files.matchSubjectID
           --,<sourceSystemEventID, varchar(50),>
, 1
           --,<eventType, varchar(20),>
, 'cgiData Recieved'
           --,<eventName, varchar(200),>
, 'cgiData Recieved'
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
where files.fileSourceSystem = 9


