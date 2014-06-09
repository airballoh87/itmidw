/*
select  eventType, COUNT(*)
from tblevent eve
	inner join tblsubject sub
		on sub.subjectID = eve.subjectID
GROUP BY  eventType





select 
	sourceSystemIDLabel as ITMIsubjectID
	, CGIeve.eventName as CGIdata
	, Illeve.eventName as Illdata
	, Eaeve.eventName Eadata
from tblsubject sub
--CGI
	LEFT JOIN tblevent CGIeve
		on sub.subjectID = CGIeve.subjectID
			AND CGIeve.eventtype = 'cgiData Recieved'
--Illumina
	LEFT JOIN tblevent Illeve
		on sub.subjectID = Illeve.subjectID
			AND Illeve.eventtype = 'Ill Data Recieved'
--EA
	LEFT JOIN tblevent eaEve
		on sub.subjectID = eaEve.subjectID
			AND eaEve.eventtype = 'EA File Recieved'
WHERE 
	 CGIeve.eventName IS NULL AND
	 Illeve.eventName IS NULL AND
	 Eaeve.eventName IS NULL 


SELECT LEN(sourceSystemIDLabel), sourceSystemIDLabel
, SUBSTRING(sourceSystemIDLabel,11,3)
from tblsubject
WHERE LEN(sourceSystemIDLabel) > 12
	AND SUBSTRING(sourceSystemIDLabel,11,3) NOT IN ('03a', '03b', '03c')
ORDER BY LEN(sourceSystemIDLabel) DESC
*/



INSERT INTO itmiDW.[dbo].[tblSpecimen]
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
     SELECT *
           --(<sourceSystemSpecimenID, varchar(50),>
           --,<subjectID, int,>
           --,<specimenFamilyID, int,>
           --,<specimenSampleTypeID, int,>
           --,<specimenPhysicalTypeID, varchar(50),>
           --,<location, varchar(200),>
           --,<prepType, varchar(200),>
           --,<specimenOriginalWeight, numeric(28,10),>
           --,<weightVolume, numeric(28,10),>
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
FROM ITMISTAGING.nautilus.ALIQUOT
