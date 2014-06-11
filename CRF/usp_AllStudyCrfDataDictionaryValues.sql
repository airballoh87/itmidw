IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.usp_AllStudyCrfDataDictionaryValues') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.usp_AllStudyCrfDataDictionaryValues
GO
/**************************************************************************
Created ON : 4/12/2014
Created By : AarON Black
Team Name : Informatics
Object name : usp_AllStudyCrfDataDictionaryValues
Functional : ITMI SSIS for Insert AND Update for study 102 crf data dictionary

History : Created ON 4/12/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC itmidw.usp_AllStudyCrfDataDictionaryValues
--TRUNCATe table itmidw.[tblCrfDataDictionaryValues] 
select  * FROM itmidw.[tblCrfDataDictionaryValues] 
**************************************************************************/
CREATE PROCEDURE itmidw.usp_AllStudyCrfDataDictionaryValues
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' usp_AllStudyCrfDataDictionaryValues[' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.usp_AllStudyCrfDataDictionaryValues...'

--*************************************
--******************102****************
--*************************************
--Preferred name update
---*****************
--FieldValue---*****
---*****************

UPDATE itmidw.[tblCrfTranslationFieldOptions] SET preferredName =  
	CASE opt.fieldValue
		WHEN 'Black' THEN 'Black or African American'
		WHEN 'Declined' THEN 'Unknown'
		WHEN 'White' THEN 'White or Caucasian'
		WHEN 'None' THEN 'Unknown'
	ELSE opt.fieldValue
	END
FROM itmidw.[tblCrfTranslationFieldOptions] opt	
	INNER JOIN itmidw.[tblCrfTranslationField] f
		on f.crfTranslationFieldID = opt.crfTranslationFieldID
WHERE f.preferredFieldName = 'RACE';

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' update to preferred Name for Race row(s) updated.'	

--*************************************
--DD values insert--*******************
--*************************************

INSERT INTO itmidw.[tblCrfDataDictionaryValues]
   ([crfDataDictionaryID]
   ,[CodedData]
   ,[dataCodeStored]
   ,[dataValue])
SELECT
	dd.crfDataDictionaryID
	, MAX(transFoptions.codedData) codedData
	, transFoptions.preferredName
    , transFoptions.preferredName
FROM itmidw.tblCrfDataDictionary dd
	INNER JOIN itmidw.[tblCrfTranslationField] transF
		ON dd.preferredFieldName = transF.preferredFieldName
	INNER JOIN itmidw.[tblCrfTranslationFieldOptions] transFoptions
		ON transF.crfTranslationFieldID = transFoptions.CrfTranslationFieldID	
	LEFT JOIN itmidw.[tblCrfDataDictionaryValues] ddVal	
		ON ddVal.crfDataDictionaryID = dd.crfDataDictionaryID
			AND transFoptions.preferredName = ddval.dataCodeStored
WHERE transFoptions.preferredName IS NOT NULL
	AND ddVal.crfDataDictionaryID IS NULL --only bringing in new records that are not in DD already
GROUP BY transFoptions.preferredName,	dd.crfDataDictionaryID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

END



