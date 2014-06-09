USE [ITMIStaging]
GO
/****** Object:  StoredProcedure [itmidw].[usp_Study102Prep]    Script Date: 6/1/2014 4:19:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [itmidw].[usp_Study102Prep]
AS
BEGIN


SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102Prep][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study102Prep]...'

--/*
--**************************************************************************
--drop table
IF OBJECT_ID('tempdb..#metaForm') IS NOT NULL
DROP TABLE #metaForm  

BEGIN
IF EXISTS(SELECT * FROM itmistaging.sys.columns c
				INNER JOIN  itmistaging.sys.objects o
					ON o.object_id = c.object_id
            WHERE c.Name = 'itmidwSubjectID' and o.name ='PatientDataPointDetail')
ALTER TABLE difzDBCopy.PatientDataPointDetail DROP COLUMN  itmidwSubjectID 

IF EXISTS(SELECT * FROM itmistaging.sys.columns c
				INNER JOIN  itmistaging.sys.objects o
					ON o.object_id = c.object_id
            WHERE c.Name = 'itmiFormName' and o.name ='PatientDataPointDetail')
ALTER TABLE difzDBCopy.PatientDataPointDetail DROP COLUMN  itmiFormName 

IF EXISTS(SELECT * FROM itmistaging.sys.columns c
				INNER JOIN  itmistaging.sys.objects o
					ON o.object_id = c.object_id
            WHERE c.Name = 'itmiFieldName' and o.name ='PatientDataPointDetail')
ALTER TABLE difzDBcopy.PatientDataPointDetail DROP COLUMN  itmiFieldName 


IF EXISTS(SELECT * FROM itmistaging.sys.columns c
				INNER JOIN  itmistaging.sys.objects o
					ON o.object_id = c.object_id
            WHERE c.Name = 'itmiFieldValue' and o.name ='PatientDataPointDetail')
ALTER TABLE difzDBcopy.PatientDataPointDetail DROP COLUMN  itmiFieldValue 

IF EXISTS(SELECT * FROM itmistaging.sys.columns c
				INNER JOIN  itmistaging.sys.objects o
					ON o.object_id = c.object_id
            WHERE c.Name = 'itmiFieldID' and o.name ='PatientDataPointDetail')
ALTER TABLE difzDBcopy.PatientDataPointDetail DROP COLUMN  itmiFieldID
END



ALTER TABLE difzDBcopy.PatientDataPointDetail ADD itmidwSubjectID INT
ALTER TABLE difzDBcopy.PatientDataPointDetail ADD itmiFormName VARCHAR(100)
ALTER TABLE difzDBcopy.PatientDataPointDetail ADD itmiFieldName VARCHAR(100)
ALTER TABLE difzDBcopy.PatientDataPointDetail ADD itmiFieldValue VARCHAR(100)
ALTER TABLE difzDBcopy.PatientDataPointDetail ADD itmiFieldID VARCHAR(100)

--*/

--Temp table creatiON for form Data
SELECT 
	LTRIM(RTRIM(REPLACE(substring(crf.crfName,CHARINDEX(':',crf.crfName)+1,50),': 101','))) as FormName
	, LTRIM(RTRIM(field.fieldname)) as FieldName
	, field.fieldDescription
	, field.fieldID
INTO #metaForm
FROM itmidw.tblcrffields  field 
	INNER JOIN itmidw.tblcrfVersiON vers
		ON vers.crfVersionID = field.crfVersionID
	INNER JOIN itmidw.tblcrf crf
		ON crf.crfID = vers.crfID
WHERE field.fieldname <> '
	and vers.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ')


UPDATE difzDBcopy.PatientDataPointDetail SET itmidwSubjectID = subject.subjectID
	FROM difzDBcopy.PatientDataPointDetail as deets
	INNER JOIN #metaForm mf
		ON MF.fieldName = deets.fieldName
			and mf.formName = 
					CASE WHEN CHARINDEX(' -',deets.dataPageName) = 0 THEN deets.datapageName else 
						LEFT(deets.dataPageName,CHARINDEX(' -',deets.dataPageName)) END 
	INNER JOIN itmidw.tblSubject subject
		ON LTRIM(RTRIM(subject.sourceSystemIDLabel)) =  
			CASE deets.datapageName 
				WHEN 'Enrollment' THEN  deets.patientIdentifier + '-01'  
				WHEN 'Trio Contact' THEN deets.patientIdentifier + '-01'  
				WHEN 'Mother Socio-Economic Status ' THEN deets.patientIdentifier + '-01'  
					ELSE deets.patientIdentifier + '-' + LTRIM(RTRIM(SUBSTRING(deets.dataPageName, CHARINDEX('-',deets.datapageName)+1,5)))
			END 
WHERE deets.isactive = 1	

--fORM

UPDATE difzDBcopy.PatientDataPointDetail   
	SET itmiFormName = CASE WHEN CHARINDEX(' -',dataPageName) = 0 THEN datapageName else 
	LEFT(dataPageName,CHARINDEX(' -',dataPageName)) END 
FROM difzDBcopy.PatientDataPointDetail as deets
	INNER JOIN itmidw.tblSubject subject
		ON subject.subjectId = deets.itmidwSubjectID
WHERE deets.isactive = 1	

--more descriptive fieldName
--itmiFieldName

UPDATE difzDBcopy.PatientDataPointDetail   
	SET itmiFieldName = MF.fieldDescription
		, itmiFieldID = mf.fieldID
FROM #metaForm mf
	INNER JOIN difzDBcopy.PatientDataPointDetail as deets
		ON deets.itmiFormName = mf.formName
			AND deets.fieldName = mf.FieldName
	INNER JOIN itmidw.tblSubject subject
		ON subject.subjectId = deets.itmidwSubjectID
WHERE deets.isactive = 1		
	

--coded value update
UPDATE difzDBcopy.PatientDataPointDetail   
	SET itmiFieldValue =  dd.userDataString
FROM difzDBcopy.PatientDataPointDetail as deets
	INNER JOIN itmidw.tblSubject subject
		ON subject.subjectId = deets.itmidwSubjectID
	INNER JOIN itmidw.tblCrf crf
		ON crf.crfName = deets.itmiFormName
	LEFT JOIN itmistaging.[dbo].[Study102Fields] F
		on f.fieldOID = deets.fieldName
			and crf.crfShortName = f.formOID
	INNER JOIN itmistaging.[dbo].[DataDictionaryEntries] dd
		ON dd.datadictionaryName = f.datadictionaryName 
			and deets.fieldValue = dd.codedData
WHERE deets.isactive = 1	

END
