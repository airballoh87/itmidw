USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblClinicalDataDates]    Script Date: 3/26/2014 2:02:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblClinicalDataDates](
	[clinicalDataDatesID] [int] IDENTITY(1,1) NOT NULL,
	[subjectID] [int] NULL,
	[CrfEventID] [int] NULL,
	[crfType] [varchar](200) NULL,
	[dateName] [varchar](200) NULL,
	[dateValue] [datetime] NULL,
	[dayOf] [varchar](2) NULL,
	[monthOf] [varchar](2) NULL,
	[yearOf] [varchar](4) NULL,
 CONSTRAINT [PK_tblClinicalDataDates] PRIMARY KEY CLUSTERED 
(
	[clinicalDataDatesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblCrf]    Script Date: 3/26/2014 2:02:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblCrf](
	[crfID] [int] IDENTITY(1,1) NOT NULL,
	[sourceSystemCrfID] [varchar](40) NULL,
	[crfTypeID] [int] NULL,
	[crfShortName] [nvarchar](255) NULL,
	[crfName] [nvarchar](255) NULL,
	[sourceSystemID] [int] NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblCrf] PRIMARY KEY CLUSTERED 
(
	[crfID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblCrf]  WITH CHECK ADD  CONSTRAINT [FK_tblCrf_tblCrfType] FOREIGN KEY([crfTypeID])
REFERENCES [dbo].[tblCrfType] ([crfTypeID])
GO

ALTER TABLE [dbo].[tblCrf] CHECK CONSTRAINT [FK_tblCrf_tblCrfType]
GO

USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblCrfDataDictionary]    Script Date: 3/26/2014 2:02:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblCrfDataDictionary](
	[crfDataDictionaryID] [int] IDENTITY(1,1) NOT NULL,
	[studyID] [int] NOT NULL,
	[studyName] [varchar](200) NULL,
	[crfID] [int] NULL,
	[crfType] [varchar](200) NULL,
	[crfVersionName] [varchar](200) NULL,
	[questionText] [nvarchar](200) NULL,
	[preferredFieldName] [varchar](100) NULL,
	[fieldOrder] [int] NULL,
	[mandatory] [nvarchar](255) NULL,
	[externalCDE] [varchar](50) NULL,
	[externalCDESource] [nchar](50) NULL,
	[fieldID] [int] NULL,
	[fieldName] [nvarchar](200) NULL,
	[fieldDescription] [nvarchar](200) NULL,
	[requiredDependency] [varchar](255) NULL,
	[requiredDependencyText] [varchar](255) NULL,
	[crfVersionID] [int] NOT NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblCrfDataDictionary] PRIMARY KEY CLUSTERED 
(
	[crfDataDictionaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblCrfDataDictionaryValues]    Script Date: 3/26/2014 2:02:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblCrfDataDictionaryValues](
	[CrfDataDictionaryValueID] [int] IDENTITY(1,1) NOT NULL,
	[crfDataDictionaryID] [int] NULL,
	[DataDictionarySourceName] [nvarchar](255) NULL,
	[CodedData] [nvarchar](255) NULL,
	[Ordinal] [nvarchar](255) NULL,
	[dataCodeStored] [nvarchar](255) NULL,
	[dataValue] [varchar](255) NULL,
 CONSTRAINT [PK_tblCrfDataDictionaryValues] PRIMARY KEY CLUSTERED 
(
	[CrfDataDictionaryValueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblCrfEvent]    Script Date: 3/26/2014 2:02:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblCrfEvent](
	[crfEventID] [int] IDENTITY(1,1) NOT NULL,
	[EventID] [int] NULL,
	[sourceSystemCrfEventID] [varchar](50) NULL,
	[parentCrfEventID] [int] NULL,
	[crfID] [int] NULL,
	[crfType] [varchar](200) NULL,
	[crfVersionID] [int] NULL,
	[subjectID] [int] NULL,
	[crfStatus] [varchar](200) NULL,
	[updatedDate] [datetime] NULL,
	[completedDate] [datetime] NULL,
	[studyID] [varchar](50) NULL,
	[eventCrfUUID] [varchar](50) NULL,
	[formOrdinal] [int] NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblCrfEvent] PRIMARY KEY CLUSTERED 
(
	[crfEventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblCrfEventAnswers]    Script Date: 3/26/2014 2:10:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblCrfEventAnswers](
	[crfEventAnswersID] [int] IDENTITY(1,1) NOT NULL,
	[sourceSystemFieldDataID] [int] NULL,
	[sourceSystemFieldDataLabel] [nvarchar](100) NULL,
	[eventCrfID] [int] NOT NULL,
	[crfVersionID] [int] NOT NULL,
	[fieldValue] [nvarchar](4000) NULL,
	[hadQuery] [bit] NULL,
	[openQuery] [bit] NULL,
	[fieldValueOrdinal] [int] NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblCrfEventAnswers] PRIMARY KEY CLUSTERED 
(
	[crfEventAnswersID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblCrfFieldOptions]    Script Date: 3/26/2014 2:10:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblCrfFieldOptions](
	[crfFieldOptionsID] [int] NOT NULL,
	[crfVersionID] [int] NOT NULL,
	[sourceSystemCrfVersionID] [int] NOT NULL,
	[fieldID] [int] NOT NULL,
	[optionLabel] [varchar](200) NOT NULL,
	[optionValue] [varchar](200) NOT NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblCrfFieldOptions] PRIMARY KEY CLUSTERED 
(
	[crfFieldOptionsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblCrfFieldOptions]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfFieldOptions_tblCrfFields] FOREIGN KEY([fieldID])
REFERENCES [dbo].[tblCrfFields] ([fieldID])
GO

ALTER TABLE [dbo].[tblCrfFieldOptions] CHECK CONSTRAINT [FK_tblCrfFieldOptions_tblCrfFields]
GO

ALTER TABLE [dbo].[tblCrfFieldOptions]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfFieldOptions_tblSourceSystem] FOREIGN KEY([orgSourceSystemID])
REFERENCES [dbo].[tblSourceSystem] ([sourceSystemID])
GO

ALTER TABLE [dbo].[tblCrfFieldOptions] CHECK CONSTRAINT [FK_tblCrfFieldOptions_tblSourceSystem]
GO



USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblCrfFields]    Script Date: 3/26/2014 2:10:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblCrfFields](
	[fieldID] [int] IDENTITY(1,1) NOT NULL,
	[crfVersionID] [int] NULL,
	[sourceSystemFieldID] [varchar](150) NOT NULL,
	[fieldName] [nvarchar](500) NULL,
	[fieldDescription] [nvarchar](500) NULL,
	[cdeID] [varchar](50) NULL,
	[questionText] [nvarchar](500) NULL,
	[crfSourceSystemFieldOrder] [int] NULL,
	[dataType] [varchar](200) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblCrfFields] PRIMARY KEY CLUSTERED 
(
	[fieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblCrfFields]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfFields_tblCrfVersion] FOREIGN KEY([crfVersionID])
REFERENCES [dbo].[tblCrfVersion] ([crfVersionID])
GO

ALTER TABLE [dbo].[tblCrfFields] CHECK CONSTRAINT [FK_tblCrfFields_tblCrfVersion]
GO

ALTER TABLE [dbo].[tblCrfFields]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfFields_tblSourceSystem] FOREIGN KEY([orgSourceSystemID])
REFERENCES [dbo].[tblSourceSystem] ([sourceSystemID])
GO

ALTER TABLE [dbo].[tblCrfFields] CHECK CONSTRAINT [FK_tblCrfFields_tblSourceSystem]
GO



USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblCrfType]    Script Date: 3/26/2014 2:10:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblCrfType](
	[crfTypeID] [int] NOT NULL,
	[crfTypeName] [varchar](100) NULL,
	[crfTypeCode] [varchar](10) NULL,
 CONSTRAINT [PK_tblCrfType] PRIMARY KEY CLUSTERED 
(
	[crfTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblCrfVersion]    Script Date: 3/26/2014 2:11:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblCrfVersion](
	[crfVersionID] [int] IDENTITY(1,1) NOT NULL,
	[sourceSystemCrfVersionID] [int] NOT NULL,
	[sourceSystemVersionID] [int] NOT NULL,
	[crfID] [int] NOT NULL,
	[crfVersionName] [nvarchar](200) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblCrfVersion] PRIMARY KEY CLUSTERED 
(
	[crfVersionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblCrfVersion]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfVersion_tblCrf] FOREIGN KEY([crfID])
REFERENCES [dbo].[tblCrf] ([crfID])
GO

ALTER TABLE [dbo].[tblCrfVersion] CHECK CONSTRAINT [FK_tblCrfVersion_tblCrf]
GO

ALTER TABLE [dbo].[tblCrfVersion]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfVersion_tblSourceSystem] FOREIGN KEY([orgSourceSystemID])
REFERENCES [dbo].[tblSourceSystem] ([sourceSystemID])
GO

ALTER TABLE [dbo].[tblCrfVersion] CHECK CONSTRAINT [FK_tblCrfVersion_tblSourceSystem]
GO


USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblEvent]    Script Date: 3/26/2014 2:11:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblEvent](
	[eventID] [int] IDENTITY(1,1) NOT NULL,
	[subjectID] [int] NULL,
	[sourceSystemEventID] [varchar](50) NULL,
	[eventType] [varchar](20) NOT NULL,
	[eventName] [varchar](200) NULL,
	[studyID] [varchar](50) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblEvent] PRIMARY KEY CLUSTERED 
(
	[eventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblOrganization]    Script Date: 3/26/2014 2:11:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblOrganization](
	[organizationID] [int] IDENTITY(1,1) NOT NULL,
	[organizationTypeID] [int] NULL,
	[organizationCode] [varchar](10) NULL,
	[organizationName] [varchar](100) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [date] NULL,
	[createdBy] [nchar](20) NULL,
 CONSTRAINT [PK_tblOrganization] PRIMARY KEY CLUSTERED 
(
	[organizationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblOrganization]  WITH CHECK ADD  CONSTRAINT [FK_tblOrganization_tblOrganizationType] FOREIGN KEY([organizationTypeID])
REFERENCES [dbo].[tblOrganizationType] ([organizationTypeID])
GO

ALTER TABLE [dbo].[tblOrganization] CHECK CONSTRAINT [FK_tblOrganization_tblOrganizationType]
GO

ALTER TABLE [dbo].[tblOrganization]  WITH CHECK ADD  CONSTRAINT [FK_tblOrganization_tblSourceSystem] FOREIGN KEY([orgSourceSystemID])
REFERENCES [dbo].[tblSourceSystem] ([sourceSystemID])
GO

ALTER TABLE [dbo].[tblOrganization] CHECK CONSTRAINT [FK_tblOrganization_tblSourceSystem]
GO


USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblOrganizationType]    Script Date: 3/26/2014 2:11:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblOrganizationType](
	[organizationTypeID] [int] NOT NULL,
	[organizationTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_tblOrganizationType] PRIMARY KEY CLUSTERED 
(
	[organizationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblPerson]    Script Date: 3/26/2014 2:11:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblPerson](
	[personID] [int] IDENTITY(1,1) NOT NULL,
	[personTypeID] [int] NULL,
	[ssn] [varchar](12) NULL,
	[mrn] [varchar](50) NULL,
	[raceCode] [varchar](50) NULL,
	[ethnicityCode] [varchar](50) NULL,
	[sex] [varchar](50) NULL,
	[DateOfBirth] [varchar](50) NULL,
	[maritalStatusCode] [int] NULL,
	[educationStatusCode] [int] NULL,
	[birthCountryCode] [int] NULL,
	[birthOrder] [int] NULL,
	[deadFlag] [bit] NULL,
	[personAlias] [int] NULL,
	[orgSourceSystemUniqueID] [varchar](50) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](20) NULL,
 CONSTRAINT [PK_tblPerson] PRIMARY KEY CLUSTERED 
(
	[personID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblPersonRelationship]    Script Date: 3/26/2014 2:11:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblPersonRelationship](
	[personRelationshipID] [int] IDENTITY(1,1) NOT NULL,
	[personRelationshipTypeID] [int] NOT NULL,
	[referencePersonID] [int] NOT NULL,
	[relatedPersonID] [int] NOT NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](50) NULL,
 CONSTRAINT [PK_tblPersonRelationship] PRIMARY KEY CLUSTERED 
(
	[personRelationshipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblPersonRelationship]  WITH CHECK ADD  CONSTRAINT [FK_tblPersonRelationship_tblPersonRelationshipType] FOREIGN KEY([personRelationshipTypeID])
REFERENCES [dbo].[tblPersonRelationshipType] ([personRelationTypeID])
GO

ALTER TABLE [dbo].[tblPersonRelationship] CHECK CONSTRAINT [FK_tblPersonRelationship_tblPersonRelationshipType]
GO

ALTER TABLE [dbo].[tblPersonRelationship]  WITH CHECK ADD  CONSTRAINT [FK_tblPersonRelationship_tblSourceSystem] FOREIGN KEY([orgSourceSystemID])
REFERENCES [dbo].[tblSourceSystem] ([sourceSystemID])
GO

ALTER TABLE [dbo].[tblPersonRelationship] CHECK CONSTRAINT [FK_tblPersonRelationship_tblSourceSystem]
GO


USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblPersonRelationshipType]    Script Date: 3/26/2014 2:12:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblPersonRelationshipType](
	[personRelationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[personITMIRelationshipCode] [varchar](10) NULL,
	[personRelationshipName] [varchar](100) NULL,
	[isFamilyFlag] [bit] NULL,
	[nciRelationshipCode] [varchar](255) NULL,
	[cdiscName] [varchar](255) NULL,
	[cDiscDescription] [varchar](255) NULL,
 CONSTRAINT [PK_tblPersonRelationshipType] PRIMARY KEY CLUSTERED 
(
	[personRelationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblPersonType]    Script Date: 3/26/2014 2:12:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblPersonType](
	[personTypeID] [int] IDENTITY(1,1) NOT NULL,
	[personTypeCode] [varchar](10) NULL,
	[personTypeDesc] [varchar](50) NULL,
 CONSTRAINT [PK_tblPersonType] PRIMARY KEY CLUSTERED 
(
	[personTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblStudy]    Script Date: 3/26/2014 2:12:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblStudy](
	[studyID] [int] NOT NULL,
	[studyShortID] [varchar](20) NULL,
	[studyName] [varchar](50) NULL,
	[studyStartDate] [datetime] NULL,
	[studyEndDate] [datetime] NULL,
 CONSTRAINT [PK_tblStudy] PRIMARY KEY CLUSTERED 
(
	[studyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblSubject]    Script Date: 3/26/2014 2:12:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblSubject](
	[SubjectID] [int] IDENTITY(1,1) NOT NULL,
	[sourceSystemSubjectID] [varchar](50) NULL,
	[sourceSystemIDLabel] [varchar](50) NULL,
	[studyID] [int] NULL,
	[personID] [int] NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [nchar](20) NULL,
 CONSTRAINT [PK_tblSubject] PRIMARY KEY CLUSTERED 
(
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblSubjectDataset]    Script Date: 3/26/2014 2:12:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblSubjectDataset](
	[subjectDatasetID] [int] IDENTITY(1,1) NOT NULL,
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
	[doesMetricPass] [varchar](1) NULL,
	[orgSourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [nchar](20) NULL,
 CONSTRAINT [PK_tblSubjectDataset] PRIMARY KEY CLUSTERED 
(
	[subjectDatasetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblSubjectDataset]  WITH CHECK ADD  CONSTRAINT [FK_tblSubjectDataset_tblSourceSystem] FOREIGN KEY([orgSourceSystemID])
REFERENCES [dbo].[tblSourceSystem] ([sourceSystemID])
GO

ALTER TABLE [dbo].[tblSubjectDataset] CHECK CONSTRAINT [FK_tblSubjectDataset_tblSourceSystem]
GO

USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblSubjectIdentifer]    Script Date: 3/26/2014 2:12:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblSubjectIdentifer](
	[subjectIdentiferID] [int] IDENTITY(1,1) NOT NULL,
	[subjectID] [int] NULL,
	[subjectIdentifier] [varchar](100) NULL,
	[subjectIdentifierType] [varchar](20) NULL,
	[sourceSystemID] [int] NULL,
	[createDate] [datetime] NULL,
	[createdBy] [varchar](50) NULL,
 CONSTRAINT [PK_tblSubjectIdentifer] PRIMARY KEY CLUSTERED 
(
	[subjectIdentiferID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblSubjectOrganizationMap]    Script Date: 3/26/2014 2:13:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblSubjectOrganizationMap](
	[subjectOrganizationMapID] [int] IDENTITY(1,1) NOT NULL,
	[subjectID] [int] NULL,
	[organizationID] [int] NULL,
	[organizationTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_tblSubjectOrganizationMap] PRIMARY KEY CLUSTERED 
(
	[subjectOrganizationMapID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblSubjectOrganizationMap]  WITH CHECK ADD  CONSTRAINT [FK_tblSubjectOrganizationMap_tblOrganization] FOREIGN KEY([organizationID])
REFERENCES [dbo].[tblOrganization] ([organizationID])
GO

ALTER TABLE [dbo].[tblSubjectOrganizationMap] CHECK CONSTRAINT [FK_tblSubjectOrganizationMap_tblOrganization]
GO

ALTER TABLE [dbo].[tblSubjectOrganizationMap]  WITH CHECK ADD  CONSTRAINT [FK_tblSubjectOrganizationMap_tblOrganization1] FOREIGN KEY([organizationID])
REFERENCES [dbo].[tblOrganization] ([organizationID])
GO

ALTER TABLE [dbo].[tblSubjectOrganizationMap] CHECK CONSTRAINT [FK_tblSubjectOrganizationMap_tblOrganization1]
GO

USE [ITMIDW]
GO

/****** Object:  Table [dbo].[tblSubjectWithDrawal]    Script Date: 3/26/2014 2:13:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblSubjectWithDrawal](
	[subjectWithDrawalID] [int] IDENTITY(1,1) NOT NULL,
	[subjectID] [int] NULL,
	[subjectWithReason] [varchar](100) NULL,
	[SourceSystemID] [int] NULL,
	[createdDate] [datetime] NULL,
	[createdBy] [varchar](100) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


