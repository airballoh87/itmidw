--futre dates
-- one date should never be before or after another
--detail for race, prenatal date and date of father birth(do we want to break those down?, do we want to make sure they match?)

select top 100 percent
	study.studyName
	,study.studyShortID
	, subject.sourceSystemIDLabel subjectID
	, analy.crfQuestion analysisQuestion
	, analy.crfAnswer analysisAnswer
	, crfa.fieldValue importedDataValueRaw
	,crfa.sourceSystemFieldDataID importedDataLabelRaw
	, deets.fieldName as difzName
	, deets.fieldValue as difzValue  
	
from  itmidw.[tblCrfAnswersForAnalysis] analy
	INNER JOIN itmidw.tblCrfEventAnswers crfA
		on crfA.crfEventAnswersID = analy.crfEventAnswersID
	INNER JOIN itmidw.tblsubject subject
		on analy.subjectID = subject.subjectID
	INNER JOIN itmidw.tblstudy study
		on study.studyID = subject.studyID
	LEFT JOIN difzDBcopy.PatientDataPointDetail deets
		on CONVERT(Varchar(100),deets.patientDataPointDetailID) = crfa.sourceSystemFieldDataID
ORDER BY CONVERT(INT,study.studyShortID), analy.crfQuestion,subject.sourceSystemIDLabel


--detail from Digitial Infusion (just Race)
select
	 deets.fieldName as difzName
	 ,deets.fieldValue as difzValue
	, COUNT(*) numberOfTimes
from  itmidw.[tblCrfAnswersForAnalysis] analy
	INNER JOIN itmidw.tblCrfEventAnswers crfA
		on crfA.crfEventAnswersID = analy.crfEventAnswersID
	INNER JOIN itmidw.tblsubject subject
		on analy.subjectID = subject.subjectID
	INNER JOIN itmidw.tblstudy study
		on study.studyID = subject.studyID
	INNER JOIN difzDBcopy.PatientDataPointDetail deets
		on CONVERT(Varchar(100),deets.patientDataPointDetailID) = crfa.sourceSystemFieldDataID
WHERE crfa.sourceSystemFieldDataLabel IN (
'FPRACE',
'Race'
)
GROUP BY  study.studyShortID,deets.fieldValue, deets.fieldName
ORDER BY  study.studyShortID,deets.fieldName desc,deets.fieldValue

--staged events without transatlation
select
	study.studyShortID
	, crfa.sourceSystemFieldDataLabel
	, crfa.fieldValue
	, COUNT(*)
from  itmidw.[tblCrfAnswersForAnalysis] analy
	INNER JOIN itmidw.tblCrfEventAnswers crfA
		on crfA.crfEventAnswersID = analy.crfEventAnswersID
	INNER JOIN itmidw.tblsubject subject
		on analy.subjectID = subject.subjectID
	INNER JOIN itmidw.tblstudy study
		on study.studyID = subject.studyID
WHERE crfa.sourceSystemFieldDataLabel IN (
'FPRACE',
'Race')
GROUP BY  study.studyShortID,	crfa.fieldValue
	, crfa.sourceSystemFieldDataLabel
ORDER BY  	crfa.fieldValue, crfa.sourceSystemFieldDataLabel desc
	
--analysis with the studyID included
select
	study.studyShortID
	, analy.crfQuestion
	, analy.crfAnswer
	, COUNT(*)
from  itmidw.[tblCrfAnswersForAnalysis] analy
	INNER JOIN itmidw.tblCrfEventAnswers crfA
		on crfA.crfEventAnswersID = analy.crfEventAnswersID
	INNER JOIN itmidw.tblsubject subject
		on analy.subjectID = subject.subjectID
	INNER JOIN itmidw.tblstudy study
		on study.studyID = subject.studyID
--WHERE crfa.sourceSystemFieldDataLabel IN (
--'FPRACE',
--'Race'
--)
GROUP BY  study.studyShortID,	analy.crfQuestion, analy.crfAnswer
ORDER BY  	analy.crfQuestion, analy.crfAnswer


--analysis without the studyID
select
	 analy.crfQuestion
	, analy.crfAnswer
	, COUNT(*)
from  itmidw.[tblCrfAnswersForAnalysis] analy
	INNER JOIN itmidw.tblCrfEventAnswers crfA
		on crfA.crfEventAnswersID = analy.crfEventAnswersID
	INNER JOIN itmidw.tblsubject subject
		on analy.subjectID = subject.subjectID
	INNER JOIN itmidw.tblstudy study
		on study.studyID = subject.studyID
--WHERE crfa.sourceSystemFieldDataLabel IN (
--'FPRACE',
--'Race'
--)
GROUP BY  analy.crfQuestion, analy.crfAnswer
ORDER BY  	analy.crfQuestion, analy.crfAnswer


---father birthdate more than once
select
	 LTRIM(RTRIM(subject.sourceSystemIDLabel)) as sourceSystemIDLabel
	, LTRIM(RTRIM(analy.crfQuestion)) as crfQuestion
	,analy.crfAnswer
	, COUNT(*) as cnt
from  itmidw.[tblCrfAnswersForAnalysis] analy
	INNER JOIN itmidw.tblCrfEventAnswers crfA
		on crfA.crfEventAnswersID = analy.crfEventAnswersID
	INNER JOIN itmidw.tblsubject subject
		on analy.subjectID = subject.subjectID
	INNER JOIN itmidw.tblstudy study
		on study.studyID = subject.studyID
	INNEr JOIN difzDBcopy.PatientDataPointDetail deets
		on CONVERT(Varchar(100),deets.patientDataPointDetailID) = crfa.sourceSystemFieldDataID
WHere analy.crfQuestion = 'Date of Birth for Father'
GROUP BY 	 
	LTRIM(RTRIM(subject.sourceSystemIDLabel))
	, LTRIM(RTRIM(analy.crfQuestion))
	, analy.crfAnswer
HAVING COUNT(*) > 1


--detail of father birthdates
select deets.*
from  itmidw.[tblCrfAnswersForAnalysis] analy
	INNER JOIN itmidw.tblCrfEventAnswers crfA
		on crfA.crfEventAnswersID = analy.crfEventAnswersID
	INNER JOIN itmidw.tblsubject subject
		on analy.subjectID = subject.subjectID
	INNER JOIN itmidw.tblstudy study
		on study.studyID = subject.studyID
	INNEr JOIN difzDBcopy.PatientDataPointDetail deets
		on CONVERT(Varchar(100),deets.patientDataPointDetailID) = crfa.sourceSystemFieldDataID
WHERE LTRIM(RTRIM(subject.sourceSystemIDLabel)) IN(
'102-00928-01',
'102-00292-01')






--DELETE
--select * from itmidw.tblcrfversion
--where crfID in  (
--39
--,40
--,41
--,42
--,43
--,44)

