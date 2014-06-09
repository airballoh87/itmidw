use itmistaging
Go
-cleanup


truncate table itmidw.tblsubject
truncate table itmidw.tblsubjectDataSet
truncate table itmidw.tblperson
truncate table itmidw.tblorganization
truncate table itmidw.tblsubjectWithdrawal
truncate table itmidw.tblSubjectIdentifer
truncate table itmidw.tblEvent
truncate table itmidw.tblCrfEvent
truncate table itmidw.[tblCrfEventAnswers]
truncate table itmidw.[tblspecimen]
truncate table itmidw.[tblSubjectOrganizationMap]
truncate table itmidw.[tblFile]
TRUNCATE TABLE itmidw.[tblCrfTranslationField]
TRUNCATE TABLE itmidw.[tblCrfTranslationFieldOptions]
TRUNCATE TABLE [itmidw].[tblCrfAnswersForAnalysis]
TRUNCATE TABLE [itmidw].[tblCrfDataDictionary]
TRUNCATE TABLE [itmidw].[tblCrfDataDictionaryValues]
TRUNCATE TABLE itmidw.tblSubjectDataSet


-102
--subjects
exec itmidw.usp_Study102Subject

--people

exec itmidw.[usp_Study102Person]

--Prep
exec [itmidw].[usp_Study102Prep]

--subjects more
EXEC [itmidw].[usp_Study102SubjectIdentifier]
EXEC [itmidw].[usp_Study102Organization]
EXEC itmidw.[usp_Study102OrganizationMap]
exec [itmidw].[usp_Study102SubjectDataset]

--Events
exec itmidw.usp_Study102Event

--crf data
exec usp_Study102Crf
exec itmidw.[usp_Study102CrfEvent]
exec itmidw.[usp_Study102CrfEventAnswers]
--UPDATE itmidw.tblCrfEventAnswers SET [crfTranslationFieldID] = NULL
exec itmidw.[usp_Study102CrfTranslationField]
exec itmidw.[usp_Study102CrfTranslationFieldOptions]

--specimens
exec itmidw.[usp_Study102Specimen_SpecimenFamily]

--exec 101

exec itmidw.[usp_Study101Subject]
exec itmidw.usp_Study101SubjectIdentifier

-people
exec itmidw.[usp_Study101Person]
exec itmidw.usp_Study101Organization
EXEC itmidw.usp_Study101OrganizationMap
EXEC itmidw.usp_Study101SubjectDataset

-events
exec itmidw.[usp_Study101Event]---**

--crf
exec usp_Study101Crf
exec itmidw.[usp_Study101CrfEvent]---**
exec itmidw.[usp_Study101CrfEventAnswers]---**
exec itmidw.[usp_Study101CrfTranslationField]
EXEC itmidw.[usp_Study101CrfTranslationFieldOptions]


--specimen
exec itmidw.[usp_Study101Specimen_SpecimenFamily]

--All Studies

exec itmidw.[usp_AllStudiesFile]
exec [itmidw].[usp_AllStudySubjectWithdrawal]
exec [itmidw].[usp_AllStudyCrfDataDictionary]
exec [itmidw].[usp_AllStudyCrfDataDictionaryValues]
exec [itmidw].[usp_AllStudyCrfAnswersForAnalysis]

--analysis
--datadictionary

--crfValuesforAnalysis


SELECT COUNT(*) as subjects FROM  itmidw.tblsubject
SELECT COUNT(*) as people FROM itmidw.tblPerson
SELECT COUNT(*) as organization FROM itmidw.tblorganization
SELECT COUNT(*) as withdraws FROM itmidw.tblsubjectWithdrawal
SELECT COUNT(*) as subjectIDs FROM itmidw.tblSubjectIdentifer
SELECT COUNT(*) as Events FROM itmidw.tblEvent
SELECT COUNT(*) as organizationMap FROM itmidw.tblSubjectOrganizationMap
SELECT COUNT(*) as spectype FROM itmidw.tblSpecimenSampleType
SELECT COUNT(*) as crfEvent FROM itmidw.tblCrfEvent
SELECT COUNT(*) as [tblCrfEventAnswers] FROM itmidw.[tblCrfEventAnswers]
SELECT COUNT(*) as [tblspecimen] FROM itmidw.[tblspecimen]
SELECT COUNT(*) as [tblFile] FROM itmidw.[tblFile]
SELECT COUNT(*) as [tblCrfTranslationField] FROM itmidw.tblCrfTranslationField
SELECT COUNT(*) as [tblCrfTranslationField] FROM itmidw.tblCrfTranslationFieldOptions

SELECT COUNT(*) as [tblCrfDataDictionary] FROM [itmidw].[tblCrfDataDictionary]
SELECT COUNT(*) as [tblCrfDataDictionaryValues] FROM [itmidw].[tblCrfDataDictionaryValues]
SELECT COUNT(*) as [tblCrfAnswersForAnalysis] FROM [itmidw].[tblCrfAnswersForAnalysis]
SELECT COUNT(*) as [tblSubjectDataSet] FROM itmidw.tblSubjectDataSet
-exec [itmidw].[usp_AllStudyCrfAnswersForAnalysis]
-SELECT * FROM [itmidw].[tblCrfAnswersForAnalysis]  order by crfquestion desc

select
	study.studyShortID
	, sub.sourceSystemIDLabel
	, crfQuestion
	, crfAnswer
	, cc.*

from [itmidw].[tblCrfAnswersForAnalysis] cc
	inner join [itmidw].tblSubject sub
		on sub.subjectID = cc.subjectID
	INNER JOIN [itmidw].tblStudy study
		on study.studyID = sub.studyID
where crfQuestion LIke '%GESTAGEWK%'
order by sourceSystemIDLabel



/*
-SELECT 
-	CONVERT(varchar(100),ss.[sourceSystemFieldDataID]) as sourceSystemFieldDataID
-	, CONVERT(varchar(100),ss.[sourceSystemFieldDataLabel]) as [sourceSystemFieldDataLabel]
-	, ss.crfVersionID
-	, ss.subjectID
-	, ss.eventCrfID
-	, COUNT(*)
-FROM #sourceCrfData ss
-GROUP BY
-	CONVERT(varchar(100),ss.[sourceSystemFieldDataID])
-	, CONVERT(varchar(100),ss.[sourceSystemFieldDataLabel])
-	, ss.crfVersionID
-	, ss.subjectID
-	, ss.eventCrfID
-HAVING COUNT(*) > 1
-ORDER BY sourceSystemFieldDataID,ss.subjectID

		
			select *

		FROM #sourceCrfData
		where 
		sourceSystemFieldDataID = '3124'
		and 
		subjectID = 79
		and eventCrfID = 54469

		*/
		