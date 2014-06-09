DROP TABLE #orgCntNew
select CONVERT(int,NULL) as rowCnt, CONVERT(varchar(100), NULL) as tableName  INTO #orgCntNew
/*
select 
'SELECT COUNT(*), ' +
''''+
CONVERT(varchar(100), ob.name) + 
''''+
' FROM itmidw.' +
CONVERT(varchar(100), ob.name) +
' UNION ALL'
from sys.sysobjects ob
	where ob.xtype = 'u'
		and ob.uid = '17'
order by ob.name
	*/
INSERT INTO #orgCntNew (rowCnt, tableName) 
SELECT COUNT(*), 'tblClinicalDataDates' FROM itmidw.tblClinicalDataDates UNION ALL
SELECT COUNT(*), 'tblCrf' FROM itmidw.tblCrf UNION ALL
SELECT COUNT(*), 'tblCrfAnswersForAnalysis' FROM itmidw.tblCrfAnswersForAnalysis UNION ALL
SELECT COUNT(*), 'tblCrfAnswersTranslationMap' FROM itmidw.tblCrfAnswersTranslationMap UNION ALL
SELECT COUNT(*), 'tblCrfDataDictionary' FROM itmidw.tblCrfDataDictionary UNION ALL
SELECT COUNT(*), 'tblCrfDataDictionaryValues' FROM itmidw.tblCrfDataDictionaryValues UNION ALL
SELECT COUNT(*), 'tblCrfEvent' FROM itmidw.tblCrfEvent UNION ALL
SELECT COUNT(*), 'tblCrfEventAnswerEnrich' FROM itmidw.tblCrfEventAnswerEnrich UNION ALL
SELECT COUNT(*), 'tblCrfEventAnswers' FROM itmidw.tblCrfEventAnswers UNION ALL
SELECT COUNT(*), 'tblCrfFieldOptions' FROM itmidw.tblCrfFieldOptions UNION ALL
SELECT COUNT(*), 'tblCrfFields' FROM itmidw.tblCrfFields UNION ALL
SELECT COUNT(*), 'tblCrfSemanticTriple' FROM itmidw.tblCrfSemanticTriple UNION ALL
SELECT COUNT(*), 'tblCrfSourceSystemMap' FROM itmidw.tblCrfSourceSystemMap UNION ALL
SELECT COUNT(*), 'tblCrfTranslationField' FROM itmidw.tblCrfTranslationField UNION ALL
SELECT COUNT(*), 'tblCrfTranslationFieldOptions' FROM itmidw.tblCrfTranslationFieldOptions UNION ALL
SELECT COUNT(*), 'tblCrfType' FROM itmidw.tblCrfType UNION ALL
SELECT COUNT(*), 'tblCrfVersion' FROM itmidw.tblCrfVersion UNION ALL
SELECT COUNT(*), 'tblEHRDiagnosis' FROM itmidw.tblEHRDiagnosis UNION ALL
SELECT COUNT(*), 'tblEHREventEncounter' FROM itmidw.tblEHREventEncounter UNION ALL
SELECT COUNT(*), 'tblEHREventLab' FROM itmidw.tblEHREventLab UNION ALL
SELECT COUNT(*), 'tblEHRLabComponentResult' FROM itmidw.tblEHRLabComponentResult UNION ALL
SELECT COUNT(*), 'tblEvent' FROM itmidw.tblEvent UNION ALL
SELECT COUNT(*), 'tblEventRules' FROM itmidw.tblEventRules UNION ALL
SELECT COUNT(*), 'tblFile' FROM itmidw.tblFile UNION ALL
SELECT COUNT(*), 'tblFileExternalDrive' FROM itmidw.tblFileExternalDrive UNION ALL
SELECT COUNT(*), 'tblModelObjects' FROM itmidw.tblModelObjects UNION ALL
SELECT COUNT(*), 'tblNoteCategory' FROM itmidw.tblNoteCategory UNION ALL
SELECT COUNT(*), 'tblNotes' FROM itmidw.tblNotes UNION ALL
SELECT COUNT(*), 'tblOrganization' FROM itmidw.tblOrganization UNION ALL
SELECT COUNT(*), 'tblOrganizationType' FROM itmidw.tblOrganizationType UNION ALL
SELECT COUNT(*), 'tblPerson' FROM itmidw.tblPerson UNION ALL
SELECT COUNT(*), 'tblPersonRelationship' FROM itmidw.tblPersonRelationship UNION ALL
SELECT COUNT(*), 'tblPersonRelationshipType' FROM itmidw.tblPersonRelationshipType UNION ALL
SELECT COUNT(*), 'tblPersonType' FROM itmidw.tblPersonType UNION ALL
SELECT COUNT(*), 'tblShipmentPlate' FROM itmidw.tblShipmentPlate UNION ALL
SELECT COUNT(*), 'tblSourceSystem' FROM itmidw.tblSourceSystem UNION ALL
SELECT COUNT(*), 'tblSpecimen' FROM itmidw.tblSpecimen UNION ALL
SELECT COUNT(*), 'tblSpecimenDataset' FROM itmidw.tblSpecimenDataset UNION ALL
SELECT COUNT(*), 'tblSpecimenEvent' FROM itmidw.tblSpecimenEvent UNION ALL
SELECT COUNT(*), 'tblSpecimenFamily' FROM itmidw.tblSpecimenFamily UNION ALL
SELECT COUNT(*), 'tblSpecimenHierarchy' FROM itmidw.tblSpecimenHierarchy UNION ALL
SELECT COUNT(*), 'tblSpecimenLineage' FROM itmidw.tblSpecimenLineage UNION ALL
SELECT COUNT(*), 'tblSpecimenOutgoingMap' FROM itmidw.tblSpecimenOutgoingMap UNION ALL
SELECT COUNT(*), 'tblSpecimenSampleType' FROM itmidw.tblSpecimenSampleType UNION ALL
SELECT COUNT(*), 'tblSpecimenSummary' FROM itmidw.tblSpecimenSummary UNION ALL
SELECT COUNT(*), 'tblStudy' FROM itmidw.tblStudy UNION ALL
SELECT COUNT(*), 'tblSubject' FROM itmidw.tblSubject UNION ALL
SELECT COUNT(*), 'tblSubjectDataset' FROM itmidw.tblSubjectDataset UNION ALL
SELECT COUNT(*), 'tblSubjectIdentifer' FROM itmidw.tblSubjectIdentifer UNION ALL
SELECT COUNT(*), 'tblSubjectOrganizationMap' FROM itmidw.tblSubjectOrganizationMap UNION ALL
SELECT COUNT(*), 'tblSubjectRules' FROM itmidw.tblSubjectRules UNION ALL
SELECT COUNT(*), 'tblSubjectWithDrawal' FROM itmidw.tblSubjectWithDrawal 

delete from #orgCntNew where rowcnt is null

SELECT *
from #orgCntNew



--SELECT COUNT(*) as tblCrf FROM itmidw.tblCrf
--SELECT COUNT(*) as tblCrfAnswersForAnalysis FROM itmidw.tblCrfAnswersForAnalysis
--SELECT COUNT(*) as tblCrfAnswersTranslationMap FROM itmidw.tblCrfAnswersTranslationMap
--SELECT COUNT(*) as tblCrfDataDictionary FROM itmidw.tblCrfDataDictionary
--SELECT COUNT(*) as tblCrfDataDictionaryValues FROM itmidw.tblCrfDataDictionaryValues
--SELECT COUNT(*) as tblCrfEvent FROM itmidw.tblCrfEvent
--SELECT COUNT(*) as tblCrfEventAnswers FROM itmidw.tblCrfEventAnswers
--SELECT COUNT(*) as tblCrfFieldOptions FROM itmidw.tblCrfFieldOptions
--SELECT COUNT(*) as tblCrfFields FROM itmidw.tblCrfFields
--SELECT COUNT(*) as tblCrfSourceSystemMap FROM itmidw.tblCrfSourceSystemMap
--SELECT COUNT(*) as tblCrfTranslationField FROM itmidw.tblCrfTranslationField
--SELECT COUNT(*) as tblCrfTranslationFieldOptions FROM itmidw.tblCrfTranslationFieldOptions
--SELECT COUNT(*) as tblCrfType FROM itmidw.tblCrfType
--SELECT COUNT(*) as tblCrfVersion FROM itmidw.tblCrfVersion
--SELECT COUNT(*) as tblEvent FROM itmidw.tblEvent
--SELECT COUNT(*) as tblEventRules FROM itmidw.tblEventRules
--SELECT COUNT(*) as tblFile FROM itmidw.tblFile
--SELECT COUNT(*) as tblFileExternalDrive FROM itmidw.tblFileExternalDrive
--SELECT COUNT(*) as tblModelObjects FROM itmidw.tblModelObjects
--SELECT COUNT(*) as tblOrganization FROM itmidw.tblOrganization
--SELECT COUNT(*) as tblOrganizationType FROM itmidw.tblOrganizationType
--SELECT COUNT(*) as tblPerson FROM itmidw.tblPerson
--SELECT COUNT(*) as tblPersonRelationshipType FROM itmidw.tblPersonRelationshipType
--SELECT COUNT(*) as tblPersonType FROM itmidw.tblPersonType
--SELECT COUNT(*) as tblShipmentPlate FROM itmidw.tblShipmentPlate
--SELECT COUNT(*) as tblSourceSystem FROM itmidw.tblSourceSystem
--SELECT COUNT(*) as tblSpecimen FROM itmidw.tblSpecimen
--SELECT COUNT(*) as tblSpecimenSampleType FROM itmidw.tblSpecimenSampleType
--SELECT COUNT(*) as tblStudy FROM itmidw.tblStudy
--SELECT COUNT(*) as tblSubject FROM itmidw.tblSubject
--SELECT COUNT(*) as tblSubjectDataset FROM itmidw.tblSubjectDataset
--SELECT COUNT(*) as tblSubjectIdentifer FROM itmidw.tblSubjectIdentifer
--SELECT COUNT(*) as tblSubjectOrganizationMap FROM itmidw.tblSubjectOrganizationMap
--SELECT COUNT(*) as tblSubjectWithDrawal FROM itmidw.tblSubjectWithDrawal


select new.tablename, new.rowCnt as newRowCnt, old.rowcnt as orgRowCnt
from #orgCntNew new
	LEFT JOIN #orgCntNew old
		on old.tablename = new.tableName
where new.rowcnt <> old.rowcnt


select *
from etl.ErrorLogs

