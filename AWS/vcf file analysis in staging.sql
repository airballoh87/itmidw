--create plate table
--create import script based on table below
--place within the tbfile table, and make it an insert \ NULL


select [#Chrom], COUNT(*)
FROM [dbo].[Parsed LP6005599-DNA_A01 Indels]
GROUP BY [#Chrom]
ORDER BY [#Chrom]


select  COUNT(*)
FROM [dbo].[Parsed LP6005599-DNA_A01 Indels]


select top 1000 * 
FROM [dbo].[Parsed LP6005599-DNA_A01 Indels]
where #CHROM = 'chr14'
order by pos

 pos = '19388803'




USE [ITMIStaging]
GO

/****** Object:  Table [itmidw].[tblShipmentPlate]    Script Date: 4/23/2014 11:20:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [itmidw].[tblFileExternalDrive](
	[FileExternalDriveID] [int] IDENTITY(1,1) NOT NULL,
	[shipDataDriveName] [varchar](100) NULL,
	[shipmentPlateName] [varchar](100) NULL,
	[shipToOrganization] [int] NULL,
	[shipToProcessingType] [varchar](100) NULL,
	[shipToAssemblyVersion] [varchar](100) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](20) NULL,

) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

