drop table #tt
GO
select  crfa.sourceSystemFieldDataLabel,dd.questionText,crf.crfName
,MIN(crfa.fieldValue) as minVal
,MAX(crfa.fieldValue) as maxVal
,COUNT(*) as cnt
,SUM(CASE WHEN ISNULL(crfa.fieldValue,'') <>  '' THEN 1 ELSE 0 END) as FilledIn
,ROUND(((SUM(CASE WHEN ISNULL(crfa.fieldValue,'') <>  '' THEN 1 ELSE 0 END)+0.00)/COUNT(*)+0.00)*100,2) pctFilledIn
, MIN(distinctValue.cnt) as distinctValue
, MIN(dd.[crfTranslationFieldID]) as minDDid
, MAX(dd.[crfTranslationFieldID]) as maxDDid
--select top 10000*
--into #tt
from itmidw.tblCrfEventAnswers crfA
	inner join itmidw.[tblCrfTranslationField] dd
		on dd.[crfTranslationFieldID] = crfa.[crfTranslationFieldID]
	INNER JOIN itmidw.Tblcrf crf
		on crf.crfID = dd.crfID
	INNER JOIN 
		(select sourceSystemFieldDataLabel, COUNT(*) as cnt FROM 
		(
		SELECT sourceSystemFieldDataLabel,FieldValue FROM itmidw.tblCrfEventAnswers GROUP BY sourceSystemFieldDataLabel,FieldValue
		) as A GROUP BY sourceSystemFieldDataLabel)   
			as distinctValue
		ON distinctValue.sourceSystemFieldDataLabel = crfA.sourceSystemFieldDataLabel
GROUP BY crfa.sourceSystemFieldDataLabel,dd.questionText,crf.crfName
ORDER BY crf.crfName,crfa.sourceSystemFieldDataLabel,dd.questionText



UPDATE itmidw.[tblCrfTranslationField]  SET [preferredFieldName] =  ana.[preferred Name]
from [dbo].[crfFieldsForAnalysis20140512] ana	
	INNER JOIN #tt t
		on t.crfName = ana.crfname
		and t.sourceSystemFieldDataLabel = ana.sourceSystemFieldDataLabel
		and t.questionText = ana.questionText
	INNER JOIN itmidw.[tblCrfTranslationField] map
		on map.crfTranslationFieldID = t.minDDid


SELECT ana.*
from [dbo].[crfFieldsForAnalysis20140512] ana	
	LEFT JOIN #tt t
		on t.crfName = ana.crfname
		and t.sourceSystemFieldDataLabel = ana.sourceSystemFieldDataLabel
		and t.questionText = ana.questionText
	LEFT JOIN itmidw.[tblCrfTranslationField] map
		on map.crfTranslationFieldID = t.minDDid
WHERE map.preferredFieldName IS NULL


select * FROM #tt t where 
	--crfname = 'Sharepoint: Mother: 101' AND 
	sourceSystemFieldDataLabel like '%zip%'
