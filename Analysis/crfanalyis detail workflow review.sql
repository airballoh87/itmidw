
--SELECT displayname,preferredFieldName,* FROM itmidw.tblCrfDataDictionary dd

GO
DECLARE @FieldID varchar(100) set @FieldId = 'NBAPGARMIN5'
DECLARE @ssID varchar(100) set @ssID = '2CCDD7B8-5FBC-4837-9779-920AEB35A91D'

SELECT 'DIFZ Raw', datapagename, fieldName, fieldValue,*  FROM  difzDBcopy.PatientDataPointDetail deets where fieldName = @FieldId and fieldValue <> ''


SELECT 'difz one value',datapagename, fieldName, fieldValue,* FROM  difzDBcopy.PatientDataPointDetail deets where patientDataPointDetailID = @ssID
SELECT 'tbleventanwers by ID',crfa.fieldValue,* FROM itmidw.tblCrfEventAnswers crfA where sourceSystemFieldDataID= @ssID

select  'tblfieldOptions', optionLabel, OptionValue,* from itmidw.tblCrfFields f 
inner join itmidw.tblCrfFieldOptions o ON f.fieldID = o.fieldID where f.sourceSystemFieldID = @FieldId


SELECT 'translation field',transF.preferredFieldName, transf.* 
FROM [itmidw].[tblCrfTranslationField] transF 
LEFT JOIN itmidw.[tblCrfTranslationFieldOptions] o on transf.crfTranslationFieldID = o.crfTranslationFieldID 
where transf.fieldname = @FieldID

SELECT 'data dictionary',displayname,preferredFieldName,* FROM itmidw.tblCrfDataDictionary dd where preferredFieldName = @FieldId

SELECT 'analysis table',* FROM itmidw.[tblCrfAnswersForAnalysis] analy where analy.sourceSystemFieldID = @ssID



SELECT 'analysis table',* FROM itmidw.[tblCrfAnswersForAnalysis] analy where analy.crfQuestion = 
(SELECT displayname FROM itmidw.tblCrfDataDictionary dd where preferredFieldName = @FieldId)



--something about filed name being blank

SELECT 'translation field',transF.preferredFieldName, transf.* 
FROM [itmidw].[tblCrfTranslationField] transF 
where transF.preferredFieldName IS NOT NULL
ORDER BY transF.preferredFieldName 



--     SELECT
----(,<crfEventAnswersID, int,>
--	crfA.crfEventAnswersID
----,<crfAnswerPivot, int,>
--	, crfA.eventCrfID
----,<crfQuestion, varchar(100),>
--	, dd.displayName
----,<crfAnswer, varchar(250),>
--	, ISNULL(opt.preferredName,crfa.fieldValue) as crfAnswer
----,<SubjectID, int,>)
--	, crfa.subjectID
----sourceSystemFieldID
--	, crfA.sourceSystemFieldDataID
--SELECT crfa.fieldValue,Field.*
--FROM itmidw.tblCrfEventAnswers crfA
--	INNER JOIN itmidw.tblCrfDataDictionary dd
--		ON crfa.crfDataDictionaryID = dd.crfDataDictionaryID
--	INNER JOIN itmidw.[tblCrfTranslationField] field
--		ON field.crfTranslationFieldID = crfA.CrfTranslationFieldID
----	LEFT JOIN itmidw.[tblCrfTranslationFieldOptions] opt
--		--ON opt.CrfTranslationFieldID = field.CrfTranslationFieldID
----			AND opt.FieldValue = crfa.fieldValue
--WHERE 
--crfA.crfEventAnswersID = 971960
--AND dd.preferredFieldName IS NOT NULL
--	AND ISNULL(crfA.fieldValue,'') <> ''


select stud.studyShortID,crfquestion, crfAnswer
FROM itmidw.[tblCrfAnswersForAnalysis]	anal
	INNER JOIN itmidw.tblSubject sub
		on sub.subjectiD = anal.subjectID
	inner join itmidw.tblstudy stud
		on stud.studyid = sub.studyID

