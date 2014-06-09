--create plate table


--CREATE TABLE itmidw.tblShipmentPlate (
--shipmentPlateID INT IDENTITY(1,1) 
--, shipmentPlateName VARCHAR(100) NULL
--, shipToOrganization INT NULL
--, shipToProcessingType VARCHAR(100) NULL
--, shipToAssemblyVersion VARCHAR(100) NULL
--, shipToDataAnalyisVersion VARCHAR(100) NULL 
--, [orgSourceSystemID] [int] NULL
--, [createDate] [datetime] NULL
--, [createdBy] [varchar](20) NULL
--)


--ALTER  TABLE itmidw.tblShipmentPlate ADD shipDate DATETIME
--ALTER  TABLE itmidw.tblShipmentPlate ADD shipDataDriveName VARCHAR(100)

--create import script based on table below
--place within the tbfile table, and make it an insert \ NULL

INSERT INTO itmidw.tblShipmentPlate (

 shipmentPlateName 
, shipToOrganization
, shipToProcessingType
, shipToAssemblyVersion
, shipToDataAnalyisVersion
, shipDate
, shipDataDriveName
, [orgSourceSystemID]
, [createDate]
, [createdBy]
)

SELECT DISTINCT
	LEFT(IlluminaID,9)
	, (select organizationID from itmidw.tblOrganization WHERE organizationName = 'Illumina') as shipToOrganization
	, 'WGS'
	, [Assembly]
	, NULL as shipToDataAnalyisVersion
	, dateShipped
	, DriveBarcode  as shipDataDriveName
	, -1
	, GETDATE() 
	, 'usp_AllstudyFiles'
--select *
FROM [dbo].[DataDeliveryManifest] dm
	LEFT JOIN itmidw.tblShipmentPlate sp
		ON sp.shipmentPlateName = LEFT(IlluminaID,9)
WHERE sp.shipmentPlateID IS NULL






--INSERT INTO itmidw.tblOrganizationType (
--INSERT INTO itmidw.tblOrganization (organizationTypeID, organizationCode, OrganizationName, orgSourceSystem, createDate, createBy)


