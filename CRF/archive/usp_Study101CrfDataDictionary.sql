IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Study101Data Dictionary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Study101Data Dictionary]
GO	
/**************************************************************************
Created On : 4/1/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study101Data Dictionary]
Functional : ITMI SSIS for Insert and Update for study 101 organizationMap	
Purpose : Import of study 101, This is mapping a subject to an organization, usually a family or a site.
History : Created on 4/1/2014
*************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101Data Dictionary]
--testing update and delete
**************************************************************************/
CREATE PROCEDURE [dbo].[usp_Study101Data Dictionary]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101Data Dictionary][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study101Data Dictionary]...'


--*************************************
--******************101****************
--*************************************
--**************************************************************************
--*********tblCrfDataDictionary*********************************************
--**************************************************************************

--DBCC CHECKIDENT('[tblCrfDataDictionary]', RESEED, 1)
--DELETE FROM [tblCrfDataDictionary] WHERE [orgSourceSystemID] = 6
--truncate table [tblCrfDataDictionary]
--*************************************
--******************101****************
--*************************************

delete from [tblCrfDataDictionary]
WHERE orgSourceSystemID = 6

INSERT INTO [dbo].[tblCrfDataDictionary]([studyID],[studyName],[crfID],[crfType],[crfVersionName],[questionText],[preferredFieldName],[fieldOrder],[mandatory],[externalCDE],[fieldID],[fieldName],[fieldDescription],[requiredDependency],[requiredDependencyText],[crfVersionID],[orgSourceSystemID],[createDate],[createdBy])
SELECT DISTINCT 
crfEvent.studyID
, LEFT(study.studyName,200) as StudyName
, crfEvent.crfID
, LEFT(ct.crfTypeName,200) as CrfTypeName
, LEFT(vers.crfVersionName,200) as CrfVersionName
, LEFT(ISNULL(f.questionText,f.fieldName),200) as questionText
, NULL AS preferredFieldName
, NULL AS fieldOrder
, NULL AS mandatory
, LEFT(LTRIM(RTRIM(f.cdeID)) + ': ' + f.sourceSystemFieldID,50) as cde
, crfA.sourceSystemFieldDataID
, LEFT(crfA.sourceSystemFieldDataID,200)
, LEFT(ISNULL(f.fieldDescription,f.fieldName),200) as fieldDescription
, NULL AS requiredDependency, NULL AS requiredDependencyText
, vers.crfVersionID as crfVersionID
, 6 AS orgSourceSystemID
, GETDATE() AS createDate,'usp_Study101Data Dictionary' AS createdBy
FROM tblCrfEventAnswers crfA
	INNER JOIN tblCrfEvent crfEvent
		ON crfEvent.crfEventID = crfA.eventCrfID
	INNER JOIN Tblstudy study
		ON study.studyID = crfEvent.studyID
	INNER JOIN Tblcrf crf
		ON crf.crfID = crfEvent.crfID
	INNER JOIN tblcrfType ct
		ON ct.crftypeID = crf.crfTypeID
	INNER JOIN tblcrfversiON vers
		ON vers.crfVersionID = crfEvent.crfVersionID
	LEFT JOIN tblCrfFields f
		ON f.fieldID = crfA.sourceSystemFieldDataID
WHERE crfA.orgSourceSystemID = 6


END