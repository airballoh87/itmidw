--subjects --for 101, the mom \ dad \ baby must be imported.
--subjects - for 102 - the site ID is not present, either need to add that to import of 102 , or take that way from sdb
--specimenFamilyFirstID
--specimenTypeID must be imported

--select LEFT(sub.sourceSystemIDLabel,4) + SUBSTRING(sub.sourceSystemIDLabel,8,10), * from itmidw.dbo.tblsubject sub where studyID = 2
/*
INSERT INTO [dbo].[tblSpecimen]
           ([sourceSystemSpecimenID]
           ,[subjectID]
           ,[specimenFamilyID]
           ,[specimenSampleTypeID]
           ,[specimenPhysicalTypeID]
           ,[location]
           ,[prepType]
           ,[specimenOriginalWeight]
           ,[weightVolume]
           ,[units]
           ,[pooledFlag]
           ,[disposedFlag]
           ,[receivedFromOutSideOrgFlag]
           ,[createdInErrorFlag]
           ,[isActiveFlag]
           ,[specimenUUID]
           ,[lastNonZeroWeightVolume]
           ,[custodyDate]
           ,[orgSourceSystemID]
           ,[createDate]
           ,[createdBy])
*/
SELECT
           --(<sourceSystemSpecimenID, varchar(50),>
	cont.barcode
           --,<subjectID, int,>
	, sub.subjectID
           --,<specimenFamilyID, int,>
	, NULL -- JOIN specimenfamilyTable
           --,<specimenSampleTypeID, int,>
	, NULL
           --,<specimenPhysicalTypeID, varchar(50),>
	, NULL
           --,<location, varchar(200),>
	, NULL
           --,<prepType, varchar(200),>
	, NULL
           --,<specimenOriginalWeight, numeric(28,10),>
	, NULL
           --,<weightVolume, numeric(28,10),>
	, NULL
           --,<units, varchar(50),>
           --,<pooledFlag, varchar(1),>
           --,<disposedFlag, varchar(1),>
           --,<receivedFromOutSideOrgFlag, varchar(1),>
           --,<createdInErrorFlag, varchar(1),>
           --,<isActiveFlag, varchar(1),>
           --,<specimenUUID, varchar(40),>
           --,<lastNonZeroWeightVolume, numeric(28,10),>
           --,<custodyDate, datetime,>
           --,<orgSourceSystemID, int,>
           --,<createDate, datetime,>
           --,<createdBy, nchar(20),>)
--** sample
--** then outgoingshipmentmap
--102-04-00102-02
--SELECT cont.*
from [sdb].[Container] cont
	inner join sdb.Container_Type ct
		on ct.container_type_id = cont.container_type_id
	INNER JOIN sdb.study stud
		on stud.study_id = cont.study_id
	LEFT JOIN [sdb].[Extraction_Type] et
		on et.extraction_type_id = cont.extraction_type_id
	INNER JOIN sdb.subject sdbSub
		ON sdbSub.subject_id = cont.subject_id
	INNER JOIN itmidw.dbo.tblsubject sub
		ON sub.sourceSystemIDLabel = LEFT(sdbsub.study_subject_number,4) + SUBSTRING(sdbsub.study_subject_number,8,10)
WHERE ct.container_name  = 'Tube'
		 and cont.deprecated = 0
		 and cont.extraction_type_id IS NOT NULL
		 