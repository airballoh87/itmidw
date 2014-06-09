

--DROP TABLE [dbo].[Study102RaveExtract]
--GO

--CREATE TABLE [dbo].[Study102RaveExtract](
--	[Column 0] [varchar](77) NULL,
--	[Column 1] [bigint] NULL,
--	[Column 2] [varchar](231) NULL,
--	[Column 3] [bigint] NULL,
--	[Column 4] [varchar](66) NULL,
--	[Column 5] [bigint] NULL,
--	[Column 6] [bigint] NULL,
--	[Column 7] [varchar](121) NULL,
--	[Column 8] [bigint] NULL,
--	[Column 9] [varchar](583) NULL,
--	[Column 10] [varchar](66) NULL,
--	[Column 11] [varchar](77) NULL,
--	[Column 12] Varchar(230) NULL,
--	[Column 13] [varchar](341) NULL,
--	[Column 14] [bigint] NULL,
--	[Column 15] [bigint] NULL,
--	[Column 16] [varchar](88) NULL,
--	[Column 17] [varchar](275) NULL,
--	[Column 18] [float] NULL,
--	[Column 19] [varchar](11) NULL,
--	[Column 20] [bigint] NULL,
--	[Column 21] [varchar](330) NULL,
--	[Column 22] [bigint] NULL,
--	[Column 23] [varchar](11) NULL,
--	[Column 24] [varchar](77) NULL,
--	[Column 25] [bigint] NULL,
--	[Column 26] [varchar](242) NULL,
--	[Column 27] [varchar](242) NULL,
--	[Column 28] [varchar](242) NULL,
--	[Column 29] [bigint] NULL,
--	[Column 30] [varchar](429) NULL,
--	[Column 31] [varchar](132) NULL,
--	[Column 32] [varchar](308) NULL,
--	[Column 33] [varchar](231) NULL,
--	[Column 34] [varchar](308) NULL,
--	[Column 35] [varchar](242) NULL,
--	[Column 36] [varchar](572) NULL,
--	[Column 37] [varchar](407) NULL,
--	[Column 38] [varchar](308) NULL,
--	[Column 39] [varchar](220) NULL,
--	[Column 40] [varchar](209) NULL,
--	[Column 41] [varchar](572) NULL,
--	[Column 42] [varchar](407) NULL,
--	[Column 43] [varchar](319) NULL,
--	[Column 44] [varchar](242) NULL,
--	[Column 45] [varchar](242) NULL,
--	[Column 46] [varchar](429) NULL,
--	[Column 47] [varchar](121) NULL,
--	[Column 48] [varchar](242) NULL,
--	[Column 49] [varchar](242) NULL,
--	[Column 50] [varchar](242) NULL,
--	[Column 51] [varchar](242) NULL,
--	[Column 52] [varchar](88) NULL,
--	[Column 53] [varchar](209) NULL,
--	[Column 54] [varchar](242) NULL,
--	[Column 55] [varchar](242) NULL,
--	[Column 56] [varchar](242) NULL,
--	[Column 57] [varchar](286) NULL,
--	[Column 58] [varchar](165) NULL,
--	[Column 59] [varchar](99) NULL,
--	[Column 60] [varchar](429) NULL,
--	[Column 61] [varchar](121) NULL
--) ON [PRIMARY]

--GO

--SET ANSI_PADDING OFF
--GO
--select * from itmidw.[dbo].[tblCrfForms] crf

--update  [dbo].[Study102RaveExtract] set  raveFormID = replace(raveformID,'"','')  
--update  [dbo].[Study102RaveExtract] set  familyID = replace(familyID,'"','')  
--update  [dbo].[Study102RaveExtract] set  organization = replace(organization,'"','')  
--update  [dbo].[Study102RaveExtract] set  organizationID = replace(organizationID,'"','')  
--update  [dbo].[Study102RaveExtract] set  familyMemberName = replace(familyMemberName,'"','')  

--update  [dbo].[Study102RaveExtract] set  raveFormID = 'ENROLL' where raveFormID = 'NROLL'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'NB' where raveFormID = 'B'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'NB2' where raveFormID = 'B2'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'SC' where raveFormID = 'C'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'SC2' where raveFormID = 'C2'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'WD' where raveFormID = 'D'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'MED ' where raveFormID = 'ED'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'PF' where raveFormID = 'F'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'PFMC' where raveFormID = 'FMC'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'PG' where raveFormID = 'G'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'MHDM' where raveFormID = 'HDM'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'MHFH' where raveFormID = 'HFH'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'MHLE' where raveFormID = 'HLE'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'MHMH1' where raveFormID = 'HMH1'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'MHMH2' where raveFormID = 'HMH2'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'MHMH3' where raveFormID = 'HMH3'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'MHSH' where raveFormID = 'HSH'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'MHSS' where raveFormID = 'HSS'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'CM' where raveFormID = 'M'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'FP' where raveFormID = 'P'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'TRIOC' where raveFormID = 'RIOC'
--update  [dbo].[Study102RaveExtract] set  raveFormID = 'Fu' where raveFormID = 'U'
--select raveformID,crf.crfName, count(*)
--from  [dbo].[Study102RaveExtract] rave
--	LEFT JOIN itmidw.[dbo].[tblCrfForms] crf
--		on LTRIM(RTRIM(crf.crfShortName)) = LTRIM(RTRIM(rave.raveFormID))
--GROUP by raveFormID,crf.crfName
--order by crf.crfName, raveFormId

--[Column 5] all numeric
--[Column 6] 43 thru 56
--select [Column 25],count(*)
--from  [dbo].[Study102RaveExtract] rave
--	LEFT JOIN itmidw.[dbo].[tblCrfForms] crf
--		on LTRIM(RTRIM(crf.crfShortName)) = LTRIM(RTRIM(rave.raveFormID))
--Group by [Column 25]
--order by [Column 25]


select crf.crfName, Rave.*
from  [dbo].[Study102RaveExtract] rave
	LEFT JOIN itmidw.[dbo].[tblCrfForms] crf
		on LTRIM(RTRIM(crf.crfShortName)) = LTRIM(RTRIM(rave.raveFormID))



