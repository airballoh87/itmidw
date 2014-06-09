

/*
DROP TABLE [tblSubjectDataset]
DROP TABLE [tblSpecimenHierarchy]
DROP TABLE [tblNoteCategory]
DROP TABLE [tblNotes]
DROP TABLE [tblSpecimen]
DROP TABLE [tblOutgoingSpecimenMap]
DROP TABLE [tblSpecimenFamily]
DROP TABLE [tblSpecimenEvent]
DROP TABLE [tblSpecimenDataset]
DROP TABLE [tblSpecimenType]
DROP TABLE [tblSpecimenSummary]
DROP TABLE [tblSpecimenLineage]

*/


CREATE TABLE [dbo].[tblSubjectDataset](
	[subjectDatasetID] INT NOT NULL,
	[sourceSystemDatasetID] [varchar](20) NULL,
	[subjectID] [int] NOT NULL,
	[paramListID] [varchar](20) NOT NULL,
	[variantID] [varchar](20) NOT NULL,
	[paramName] [varchar](20) NOT NULL,
	[paramListVersionID] [varchar](20) NOT NULL,
	[dataset] [numeric](18, 0) NOT NULL,
	[enteredtext] [varchar](255) NULL,
	[enteredvalue] [numeric](28, 10) NULL,
	[datasetSequence] [numeric](18, 0) NULL,
	[dataItemSequence] [numeric](18, 0) NULL,
	[dataSetStatus] [varchar](20) NULL,
	[dataItemApproved] [varchar](1) NULL,
	[isMaxItem] [varchar](1) NULL,
	[doesMetricPass] Varchar(1) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [nchar](20) NULL
)




CREATE TABLE [dbo].[tblSpecimenHierarchy](
	[specimenID] [varchar](50) NOT NULL,
	[specimenFamilyID] [varchar](20) NULL,
	[subjectID] [varchar](20) NULL,
	[specimenSampleTypeID] [varchar](50) NULL,
	[limsBarcode] [varchar](80) NULL,
	[topSpecimenID] [varchar](50) NULL,
	[topSpecimenfamilyID] [varchar](20) NULL,
	[topSpecimenSampleTypeID] [varchar](50) NULL,
	[receivedDate] [datetime] NULL,
	[parentSpecimenID] [varchar](50) NULL,
	[depth] [int] NULL,
	[pooledFlag] [varchar](1) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [nchar](20) NULL
	)


CREATE TABLE [dbo].[tblNoteCategory](
	[noteCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[noteCategoryName] [varchar](50) NOT NULL,
	[noteCategoryLongname] [varchar](2000) NOT NULL)


CREATE TABLE [dbo].[tblNotes](
	[caseNoteID] [int] NULL,
	[caseNoteTitle] [nvarchar](200) NULL,
	[caseNoteText] [nvarchar](4000) NULL,
	[dateEntered] [datetime] NULL,
	[enteredBy] [varchar](50) NULL,
	[dateUpdated] [datetime] NULL,
	[updatedBy] [varchar](50) NULL,
	[subjectID] [int] NULL,
	[specimenID] [nvarchar](50) NULL,
	[noteCategoryID] [int] NULL,
	[resolved] [varchar](1) NULL
	)



CREATE TABLE [dbo].[tblOutgoingSpecimenMap](
	[outGoingSpecimenMapID] INT  NOT NULL,
	[specimenID] INT NOT NULL,
	[limsMatrixPlateId] [varchar](50) NULL,
	[limsBoxId] [varchar](50) NULL,
	[shippedOrganizationID] [varchar](50) NULL,
	[packageId] [varchar](50) NULL,
	[shippedDate] [datetime] NULL,
	[wellRow] [char](1) NULL,
	[wellColumn] [int] NULL,
	[limsBarcodeNumber] [varchar](80) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [nchar](20) NULL)


CREATE TABLE [dbo].[tblSpecimen](
	[specimenID] INT NOT NULL,
	[sourceSystemSpecimenID] varchar(50),
	[subjectID] [int] NULL,
	[specimenFamilyID] INT NULL,
	[specimenSampleTypeID] [varchar](50) NULL, -- this would be if the sample has a specific disease assocaited with it, or if it is a normal or control sample (
	[specimenPhysicalTypeID]  [varchar](50) NULL, --is it tissue, blood, urine, placenta
	[location] [varchar](200) NULL,
	[prepType] [varchar](200) NULL,
	[specimenOriginalWeight] [numeric](28, 10) NULL,
	[weightVolume] [numeric](28, 10) NULL,
	[units] [varchar](50) NULL,
	[pooledFlag] [varchar](1) NULL,
	[disposedFlag] [varchar](1) NULL,
	[receivedFromOutSideOrgFlag] [varchar](1) NULL,
	[createdInErrorFlag] [varchar](1) NULL,
	[isActiveFlag] [varchar](1) NULL,
	[specimenUUID] [varchar](40) NULL,	
	[lastNonZeroWeightVolume] [numeric](28, 10) NULL,
	[custodyDate] [datetime] NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [nchar](20) NULL)


CREATE  TABLE [dbo].[tblSpecimenDataset](
	[specimenDataSetID] INT,
	[specimenID] [varchar](50) NOT NULL,
	[subjectID] [int] NULL,
	[paramListID] [varchar](20) NOT NULL,
	[variantID] [varchar](20) NOT NULL,
	[paramName] [varchar](20) NOT NULL,
	[paramListVersionID] [varchar](20) NOT NULL,
	[dataset] [numeric](18, 0) NOT NULL,
	[enteredtext] [varchar](255) NULL,
	[enteredvalue] [numeric](28, 10) NULL,
	[datasetSequence] [numeric](18, 0) NULL,
	[approvedDate] [datetime] NULL,
	[approvedBy] [varchar](20) NULL,
	[dataItemSequence] [numeric](18, 0) NULL,
	[dataSetStatus] [varchar](20) NULL,
	[dataItemReleased] [varchar](1) NULL,
	[isMaxItem] [varchar](1) NULL,
	[doesMetricPass] [varchar](1) NULL,
	[specimenPhysicalTypeID] [varchar](50) NULL,--**
	[studyID] [varchar](50) NULL,
	[isMaxCompleted] [varchar](1) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [nchar](20) NULL)


CREATE TABLE [dbo].[tblSpecimenEvent](
	[eventID] INT NOT NULL,
	[subjectID] [int] NOT NULL,
	[specimenID] [varchar](50) NOT NULL,
	[eventType] [varchar](80) NOT NULL,
	[eventDate] [datetime] NOT NULL,
	[custody] [varchar](80) NULL,
	[storageLocation] [varchar](80) NULL,
	[previousEventID] [varchar](20) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [nchar](20) NULL)



CREATE TABLE [dbo].[tblSpecimenFamily](
	[specimenFamilyID] INT NOT NULL,
	[sourceSystemSpecimenFamilyID] [varchar](50) NULL,
	[subjectID] [int] NULL,
	[receivedDate] [datetime] NULL,
	[sourceOrganizationID] [varchar](50) NULL,
	[specimenPhysicalTypeID] [varchar](40) NULL,
	[specimenSampleTypeID] [varchar](40) NULL,
	[specimenAnatomicalSiteID] INT NULL, 
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [nchar](20) NULL)
 

 CREATE TABLE [dbo].[tblSpecimenLineage](
	[SpecimenLineageID] INT NOT NULL,
	[specimenID] [varchar](50) NOT NULL,
	[descendantSpecimenID] [varchar](50) NOT NULL,
	[depth] [int] NULL,
	[topSpecimenFlag] [varchar](1) NULL)

CREATE TABLE [dbo].[tblSpecimenSummary](
	[specimenID] [varchar](50) NOT NULL,
	[subjectID] [int] NULL,
	[specimenFamilyID] [varchar](50) NULL,
	[limsBarcode] [varchar](50) NULL,
	[specimenPhysicalTypeID] [varchar](50) NULL,
	[topSpecimenPhysicalTypeID] [varchar](50) NULL,
	[location] [varchar](200) NULL,
	[prepType] [varchar](200) NULL,
	[specimenOriginalWeight] [numeric](28, 10) NULL,
	[weightVolume] [numeric](28, 10) NULL,
	[units] [varchar](50) NULL,
	[depth] [int] NULL,
	[categoryDepth] [int] NULL,
	[shipped] [varchar](1) NULL,
	[hasQCValues] [varchar](1) NULL,
	[qcValueOne] [varchar](200) NULL,
	[qcValueTwo] [varchar](200) NULL,
	[qcValueThree] [varchar](200) NULL,
	[qcValueFour] [varchar](200) NULL,
	[qcValueFive] [varchar](200) NULL,
	[pooledFlag] [varchar](1) NULL,
	[parentOfPooledFlag] [varchar](1) NULL,
	[disposedFlag] [varchar](1) NULL,
	[receivedFromOutsideOrganizationFlag] [varchar](1) NULL,
	[createdInErrorFlag] [varchar](1) NULL,
	[isActiveFlag] [varchar](1) NULL,
	[specimenUUID] [varchar](40) NULL,
	[rvsiID] [varchar](80) NULL,
	[sourceOrganizationID] [varchar](50) NULL,
	[lastNonZeroWeightVolume] [numeric](28, 10) NULL,
	[custodyDate] [datetime] NULL,
	[daysInCurrentDepartment] [int] NULL,
	[orgSourceSystemID] [int] NULL,
	[createdDate] [datetime] NULL,
	[createdBy] [varchar](200) NULL
	)


CREATE TABLE [dbo].[tblSpecimenType](
	[specimenTypeID] [varchar](50) NOT NULL,
	[specimenTypeName] [varchar](200) NULL,
	[qualificationCategory] [varchar](20) NULL,
	[physicalCategory] [varchar](20) NULL,
	[externalLabel] [varchar](20) NULL)