--delete from dbo.ManifestWGSIllumina where ISNUMERIC(f1) = 0

---********************************************************
---*************WGS (Illumina)*****************************
---********************************************************

---********************************************************
---*************Specimen (sdb)*****************************
---********************************************************

--102, 103
	WITH illWGS as (
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
		and study_name = 'Longitudinal Study'
--101
--UNION ALL
--	select
--		NULL as barcode
--		, NULL as [row]
--		, NULL as [col]
--		, [mothers study id]
--		, '101 Mom'
--	from spoint101.[EDC101Mother]
--	UNION ALL
--	select
--		NULL as barcode
--		, NULL as [row]
--		, NULL as [col]
--		, [Fathers Study ID]
--		, '101 Father'
--	from spoint101.[EDC101Father]
--	UNION ALL
--	select
--		NULL as barcode
--		, NULL as [row]
--		, NULL as [col]
--		, [infants study id]
--		, '101 Newborn'
--	from spoint101.[EDC101Newborn]

)

---********************************************************
---*************Manifest***********************************
---********************************************************
, ManifestWGSIllumina as (
	select distinct
	ITMISubjectID as subjectID
	, PlateId
	, RowCol
	,  PlateRowCol
from dbo.ManifestWGSIllumina 
)

---********************************************************
---*************AWS Files**********************************
---********************************************************
, awsFiles as (
select  awsfilename, topBucket
from itmiAWSFile i
where  AWSVolume =    'itmi.ptb.illumina'
) 

, awsFilesAggregate as (
select   topBucket,COUNT(*) as numFiles
from itmiAWSFile i
where  AWSVolume =    'itmi.ptb.illumina'
GROUP BY topBucket
) 

---********************************************************
---*************Validation*********************************
---********************************************************
, SubjectList as (
select 
	sub.subjectID
	, sourceSystemIDLabel
from itmidw.dbo.tblsubject sub
	inner join itmidw.dbo.tblstudy stud
		on stud.studyID = sub.studyID
	LEFT JOIN itmidw.dbo.tblSubjectWithDrawal draw
		on draw.subjectID  = sub.subjectID
where stud.studyShortID = '102'
	and draw.subjectID is null
	and sub.sourcesystemIDLabel is not null
	and substring(sub.sourceSystemIDLabel, 5,1) <> '9'

--************************************************
--****************nautilus****************************
--************************************************
) , nautlius as (
select 
	COUNT(*) specimenCount
	, replace(LEFT(sa.EXTERNAL_REFERENCE,4) + SUBSTRING(sa.EXTERNAL_REFERENCE,8,10),'[','') as itmiSubjectID
from [nautilus].[ALIQUOT] al
	inner join nautilus.sample sa
		on sa.SAMPLE_ID = al.SAMPLE_ID
	INNER JOIN [nautilus].[CONTAINER_TYPE] ct
		on ct.CONTAINER_TYPE_ID = al.CONTAINER_TYPE_ID
	INNER JOIN nautilus.[ALIQUOT_TEMPLATe] alTemplate
		on alTemplate.ALIQUOT_TEMPLATE_ID = al.ALIQUOT_TEMPLATE_ID
where LEFT(sa.EXTERNAL_REFERENCE,3) = '102'
	AND al.matrix_type IN (
	'Whole Blood'
	, 'Whole Blood + RNAlater'
	, 'Blood')
GROUP BY replace(LEFT(sa.EXTERNAL_REFERENCE,4) + SUBSTRING(sa.EXTERNAL_REFERENCE,8,10),'[','') 
)
		

, detail as (
select 
	list.subjectID
	, list.sourceSystemIDLabel as WebPortal
	, nautlius.specimenCount as Nautilus
	, illwgs.study_subject_number as SDB
	, ManifestWGSIllumina.subjectID as Manifest
	, ManifestWGSIllumina.PlateRowCol
	, aws.topBucket
from subjectList list
	LEFT JOIN illWGS 
		ON  LEFT(illWGS.study_subject_number,4) + SUBSTRING(illWGS.study_subject_number,8,12) = list.sourceSystemIDLabel
	LEFT JOIN ManifestWGSIllumina
		ON LEFT(ManifestWGSIllumina.subjectID,4) + SUBSTRING(ManifestWGSIllumina.subjectID,8,12)  = list.sourceSystemIDLabel
	LEFT JOIN awsFilesAggregate aws
		ON aws.topbucket = ManifestWGSIllumina.PlateRowCol
	LEFT JOIN nautlius 
		ON nautlius.itmiSubjectID = list.sourceSystemIDLabel
)
--manifest but on not in bucket
--select *
--from detail 
--where subjectID in (
--select subjectID
--from detail
--where manifest is not null
--and topbucket is null
--)
--ORDER BY webPortal

--select *
--from detail 
--where subjectID in (
select distinct subjectID,*
from detail
where 
--SDB IS NULL and 
SUBSTRING(webportal,6,1) NOT IN ( '8','7')

--)
ORDER BY webPortal

	


		

--select topbucket, COUNT(*)
--FROM ManifestWGSIllumina wgsMan
--	INNER JOIN illWGS
--		ON illWGS.study_subject_number= wgsMan.subjectID
--	INNER JOIN awsFiles aws
--		ON aws.topbucket = wgsMan.PlateRowCol
----whERE topbucket = 'LP6005639-DNA_G09'
--GROUP BY topbucket
--ORDER BY COUNT(*) 

--Select * FROM ManifestWGSIllumina wgsMan
/*
*/

---********************************************************
---*************Details************************************
---********************************************************
/*

--**Query to find duplicate specimens shipped, 
select sub.study_subject_number,COUNT(*)
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
GROUP BY sub.study_subject_number
having count(*) > 1
ORDER BY COUNT(*) DESC
**example
WHERE plateRowCol = 'LP6005639-DNA_G09'




--delete from dbo.ManifestWGSIllumina where ISNUMERIC(f1) = 0

---********************************************************
---************EA******************************************
---********************************************************

---********************************************************
---*************Specimen (sdb)*****************************
---********************************************************

WITH EaSpecimen as (
--101,102
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
		and et.extraction_name = 'RNA'
		---101

UNION ALL
	select
		NULL as barcode
		, NULL as [row]
		, NULL as [col]
		, [mothers study id]
		, '101 Mom'
	from [dbo].[EDC101Mother]
	UNION ALL
	select
		NULL as barcode
		, NULL as [row]
		, NULL as [col]
		, [Fathers Study ID]
		, '101 Father'
	from [dbo].[EDC101Father]
	UNION ALL
	select
		NULL as barcode
		, NULL as [row]
		, NULL as [col]
		, [infants study id]
		, '101 Newborn'
	from [dbo].[EDC101Newborn]


)
---********************************************************
---*************EA Manifest********************************
---********************************************************
, eaManifest as (
)

---********************************************************
---*************EA AWS Files**********************************
---********************************************************
, eaAWSFiles as (
select  awsfilename, topBucket
from itmiAWSFile i
where  AWSVolume =  'itmi.ptb.ea'
) 

---********************************************************
---*************Validation*********************************
---********************************************************
/*
*/

---********************************************************
---*************Details************************************
---********************************************************
/*
*/
*/