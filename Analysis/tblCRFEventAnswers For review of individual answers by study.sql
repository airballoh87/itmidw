SELECT study.studyShortID, crfa.crfQuestion,crfa.crfAnswer, COUNT(*) as ansCnt
--select *
	from itmidw.tblCrfAnswersForAnalysis crfA
INNER JOIN itmidw.tblsubject sub
	ON SUB.subjectId = crfA.subjectID	
INNER JOIN itmidw.tblstudy study
	on study.studyID = sub.studyID
GROUP BY study.studyShortID, crfa.crfQuestion,crfa.crfAnswer
ORDER By study.studyShortID, crfa.crfQuestion,crfa.crfAnswer
