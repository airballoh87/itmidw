

---*****************
---*****META********
---*****************
--Tables
tblModelObjects	 	 	 	 

--Patient
tblNoteCategory	 	 	 	 
tblNotes	 	 	 	 
--EDC
tblCrf	 	 	 	 
tblCrfVersion	 	 	 	 
tblCrfType	 	 	 	 
tblCrfFields	 	 	 	 
tblCrfFieldOptions	 	 	 	 


---*****************
---*****Master********
---*****************
tblStudy	 	
tblSourceSystem	 	 	 	 
tblOrganization	 	 	 	 
tblOrganizationType	 	 	 	 


---*****************
---*****Patient********
---*****************
	 	 	 
TRUNCATE TABLE tblPerson	 	 	 	 
TRUNCATE TABLE tblSubject	 	 	 	 
TRUNCATE TABLE tblEvent	 
TRUNCATE TABLE tblSubjectIdentifer	 	 	 	 
TRUNCATE TABLE tblSubjectOrganizationMap	 	 	 	 
TRUNCATE TABLE tblSubjectRules

--Enrichment
--TRUNCATE TABLE tblPersonRelationshipType	 	 	 	 
--Truncate table tblPersonType	 	 	 	 
--TRUNCATE TABLE tblPersonRelationship	 

---*****************
---*****EDC********
---*****************
TRUNCATE TABLE tblCrfEvent	 	 	 	 
TRUNCATE TABLE tblCrfEventAnswers	 	 	 	 
TRUNCATE TABLE tblCrfSourceSystemMap	 	 	 	 
TRUNCATE TABLE tblClinicalDataDates	 	 	 	 
TRUNCATE TABLE tblCrfEventAnswerEnrich	 	 	 	 
TRUNCATE TABLE tblCrfAnswersForAnalysis	 	 	 	 
TRUNCATE TABLE tblCrfAnswersTranslationMap	 	 	 	 
TRUNCATE TABLE tblCrfDataDictionary	 	 	 	 
TRUNCATE TABLE tblCrfDataDictionaryValues	 	 	 	 
TRUNCATE TABLE tblCrfSemanticTriple	 	 

---*****************
---*****Specimen****
---*****************
SELECT * FROM tblSpecimen	 	 	 	 
SELECT * FROM tblSpecimenDataset	 	 	 	 
SELECT * FROM tblSpecimenEvent	 	 	 	 
SELECT * FROM tblSpecimenFamily	 	 	 	 
SELECT * FROM tblSpecimenHierarchy	 	 	 	 
SELECT * FROM tblSpecimenLineage	 	 	 	 
SELECT * FROM tblSpecimenOutgoingMap	 	 	 	 
SELECT * FROM tblSpecimenSampleType	 	 	 	 
SELECT * FROM tblSpecimenSummary	 	 	 	 
 	 	 



