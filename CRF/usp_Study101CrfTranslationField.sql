IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study101CrfTranslationField]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101CrfTranslationField]
GO	
/**************************************************************************
Created On : 4/1/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study101CrfTranslationField]
Functional : ITMI SSIS for Insert and Update for study 101 organizationMap	
Purpose : Import of study 101, This is mapping a subject to an organization, usually a family or a site.
History : Created on 4/1/2014
*************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101CrfTranslationField]
--testing update and delete
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study101CrfTranslationField]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101CrfTranslationField][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.[usp_Study101CrfTranslationField]...'


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


delete from ITMIDW.[tblCrfTranslationField] WHERE orgSourceSystemID = 6


INSERT INTO itmidw.[tblCrfTranslationField]
           ([studyID]
           ,[studyName]
           ,[crfID]
           ,[crfType]
           ,[crfVersionName]
           ,[questionText]
		   ,[preferredFieldName]
           ,[fieldID]
           ,[crfVersionID]
           ,[orgSourceSystemID]
           ,[createDate]
           ,[createdBy])
SELECT DISTINCT 
crfEvent.studyID
, LEFT(study.studyName,200) as StudyName
, crfEvent.crfID
, LEFT(ct.crfTypeName,200) as CrfTypeName
, LEFT(vers.crfVersionName,200) as CrfVersionName
, LEFT(ISNULL(f.questionText,f.fieldName),200) as questionText
--
, NULL AS preferredFieldName
, crfA.sourceSystemFieldDataID
, vers.crfVersionID as crfVersionID
, 6 AS orgSourceSystemID
, GETDATE() AS createDate
,'usp_Study101CrfTranslationField' AS createdBy

FROM ITMIDW.tblCrfEventAnswers crfA
	INNER JOIN ITMIDW.tblCrfEvent crfEvent
		ON crfEvent.crfEventID = crfA.eventCrfID
	INNER JOIN ITMIDW.Tblstudy study
		ON study.studyID = crfEvent.studyID
	INNER JOIN ITMIDW.Tblcrf crf
		ON crf.crfID = crfEvent.crfID
	INNER JOIN ITMIDW.tblcrfType ct
		ON ct.crftypeID = crf.crfTypeID
	INNER JOIN ITMIDW.tblcrfversiON vers
		ON vers.crfVersionID = crfEvent.crfVersionID
	LEFT JOIN ITMIDW.tblCrfFields f
		ON f.fieldID = crfA.sourceSystemFieldDataID
WHERE crfA.orgSourceSystemID = 6

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

--update to tblCrfTranslationField
UPDATE itmidw.tblCrfEventAnswers SET [crfTranslationFieldID] = transF.[crfTranslationFieldID]
	from itmidw.tblCrfEventAnswers crfa
	INNER JOIN itmidw.tblCrfEvent crfEvent
		ON crfEvent.crfEventID = crfA.eventCrfID
	INNER JOIN itmidw.Tblstudy study
		ON study.studyID = crfEvent.studyID
	INNER JOIN itmidw.Tblcrf crf
		ON crf.crfID = crfEvent.crfID
	INNER JOIN itmidw.tblcrfType ct
		ON ct.crftypeID = crf.crfTypeID
	INNER JOIN itmidw.tblcrfversiON vers
		ON vers.crfVersionID = crfEvent.crfVersionID
	INNER JOIN itmidw.tblCrfFields f
		ON f.fieldID = crfA.sourceSystemFieldDataID
	INNER JOIN itmidw.tblCrfTranslationField transF
		on transF.crfID = crf.crfID
			AND sourceSystemFieldDataID = transF.fieldId
	where crfa.[crfTranslationFieldID] IS NULL
		and crfa.orgSourceSystemID = 6

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' translationID  row(s) updated.'

END