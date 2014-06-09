
--Race
---*****************
--Field---**********
---*****************
UPDATE [dbo].[tblCrfTranslationField]
	SET preferredFieldName = 'RACE'
WHERE questiontext like '%race%'
	and preferredFieldName IS NULL

---*****************
--FieldValue---*****
---*****************
UPDATE [tblCrfTranslationFieldOptions] SET preferredName =  
	CASE opt.fieldValue
		WHEN 'Black' THEN 'Black or African American'
		WHEN 'Declined' THEN 'Unknown'
		WHEN 'White' THEN 'White or Caucasian'
		WHEN 'None' THEN 'Unknown'
	ELSE opt.fieldValue
	END
FROM [dbo].[tblCrfTranslationFieldOptions] opt	
	INNER JOIN [tblCrfTranslationField] f
		on f.crfTranslationFieldID = opt.crfTranslationFieldID
WHERE f.preferredFieldName = 'RACE'



--Father Birth Date
UPDATE [dbo].[tblCrfTranslationField]
	SET preferredFieldName = 'BIRTHDTEFATHER'
where [crfTranslationFieldID]  IN (
		select DISTINCT dd.[crfTranslationFieldID] 
		from tblCrfEventAnswers crfA
			inner join [dbo].[tblCrfTranslationField] dd
				on dd.[crfTranslationFieldID] = crfa.[crfTranslationFieldID]
		where sourceSystemFieldDataLabel IN 
			('ENBRTHDATF',
			'FPBRTHDATSR',
			'Date of Birth')
		and dd.crftype in (
			'FP: v1',
			'Study101 Father',
			'ENROLL: v1'
		)
)





--select *
--from [dbo].[tblCrfTranslationField]
--WHERE questiontext like '%race%'
