IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study101SubjectIdentifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101SubjectIdentifier]
GO	
/**************************************************************************
Created On : 4/1/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study101SubjectIdentifier]
Functional : ITMI SSIS for Insert and Update for study 101 subject Identifier
Purpose : Import of study 101, this shoudld be for MRN and other idnetifiers that need isolated
History : Created on 4/1/2014
*************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101SubjectIdentifier]
--testing update and delete
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study101SubjectIdentifier]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101SubjectIdentifier][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.[usp_Study101SubjectIdentifier]...'


--*************************************
--******************101****************
--*************************************

INSERT INTO itmidw.[tblSubjectIdentifer]([subjectID],[subjectIdentifier],[subjectIdentifierType],[orgSourceSystemID],[createDate],[createdBy])
SELECT sub.SubjectID, sourceSystemIDLabel,'itmi SubjectID', 6, GETDATE(), 'usp_Study101SubjectIdentifier' 
FROM itmidw.tblSubject sub 
	LEFT JOIN itmidw.tblSubjectIdentifer id
		ON id.subjectID = sub.subjectID
			and id.subjectIdentifier = sub.sourceSystemIDLabel
WHERE sub.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') 
	AND id.subjectIdentiferID IS NULL

--MRNs from extract
--Mom
INSERT INTO itmidw.[tblSubjectIdentifer]([subjectID],[subjectIdentifier],[subjectIdentifierType],[orgSourceSystemID],[createDate],[createdBy])
SELECT 
	sub.subjectID
	, m.[mom MRN]
	, 'MRN'
	, (select sourceSystemID from itmidw.tblSourceSystem where sourceSystemShortName = 	'ITMIClinical') 
	, GETDATE()
	, 'usp_Study101SubjectIdentifier'
FROM epic.epicMrn m
	INNER JOIN itmidw.tblSubject sub
		on sub.sourceSystemIDLabel = 'M-101-' + m.[study id]
	LEFT JOIN itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = m.[mom MRN]
			and sub.subjectID = id.subjectID
WHERE m.[mom mrn] IS NOT NULL
	and id.subjectIdentiferID IS NULL

	
--Baby 
INSERT INTO itmidw.[tblSubjectIdentifer]([subjectID],[subjectIdentifier],[subjectIdentifierType],[orgSourceSystemID],[createDate],[createdBy])
SELECT 
	sub.subjectID
	, m.[nb MRN]
	, 'MRN'
	, (select sourceSystemID from itmidw.tblSourceSystem where sourceSystemShortName = 	'ITMIClinical') 
	, GETDATE()
	, 'usp_Study101SubjectIdentifier'
FROM epic.epicMrn m
	INNER JOIN itmidw.tblSubject sub
		on sub.sourceSystemIDLabel = 'NB-101-' + m.[study id]
	LEFT JOIN itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = m.[nb MRN]
			and sub.subjectID = id.subjectID
WHERE m.[nb mrn] IS NOT NULL
	and id.subjectIdentiferID IS NULL

--baby dups 'A'
INSERT INTO itmidw.[tblSubjectIdentifer]([subjectID],[subjectIdentifier],[subjectIdentifierType],[orgSourceSystemID],[createDate],[createdBy])
SELECT 
	sub.subjectID
	, m.[nb MRN]
	, 'MRN'
	, (select sourceSystemID from itmidw.tblSourceSystem where sourceSystemShortName = 	'ITMIClinical') 
	, GETDATE()
	, 'usp_Study101SubjectIdentifier'
FROM epic.epicMrn m
	INNER JOIN itmidw.tblSubject sub
		ON sub.sourceSystemIDLabel = 'NB-A-101-' + m.[study id]
	LEFT JOIN itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = m.[nb MRN]
			and sub.subjectID = id.subjectID
WHERE m.[nb mrn] IS NOT NULL
	and id.subjectIdentiferID IS NULL

--baby dups b
INSERT INTO itmidw.[tblSubjectIdentifer]([subjectID],[subjectIdentifier],[subjectIdentifierType],[orgSourceSystemID],[createDate],[createdBy])
SELECT 
	sub.subjectID
	, m.[nbmrn2]
	, 'MRN'
	, (select sourceSystemID from itmidw.tblSourceSystem where sourceSystemShortName = 	'ITMIClinical') 
	, GETDATE()
	, 'usp_Study101SubjectIdentifier'
FROM epic.epicMrn m
	INNER JOIN itmidw.tblSubject sub
		ON sub.sourceSystemIDLabel = 'NB-B-101-' + m.[study id]
	LEFT JOIN itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = m.[nbmrn2]
			and sub.subjectID = id.subjectID
WHERE m.nbmrn2 IS NOT NULL
	and id.subjectIdentiferID IS NULL




--Father
INSERT INTO itmidw.[tblSubjectIdentifer]([subjectID],[subjectIdentifier],[subjectIdentifierType],[orgSourceSystemID],[createDate],[createdBy])
SELECT 
	sub.subjectID
	, m.[father MRN]
	, 'MRN'
	, (select sourceSystemID from itmidw.tblSourceSystem where sourceSystemShortName = 	'ITMIClinical') 
	, GETDATE()
	, 'usp_Study101SubjectIdentifier'
FROM epic.epicMrn m
	INNER JOIN itmidw.tblSubject sub
		on sub.sourceSystemIDLabel = 'F-101-' + m.[study id]
	LEFT JOIN itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = m.[father MRN]
			and sub.subjectID = id.subjectID
WHERE m.[father MRN] IS NOT NULL
	and id.subjectIdentiferID IS NULL


PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'


END