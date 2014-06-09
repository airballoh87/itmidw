IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Study 102ClinicalDataDates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Study 102ClinicalDataDates]
GO
/**************************************************************************
Created On : 3/19/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study 102ClinicalDataDates]
Functional : ITMI SSIS for Insert and Update for study 102 clinical data dates	
Purpose : Import of study 101 people from data spoint101 schema for Mom, dad and baby
History : Created on 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study 102ClinicalDataDates]
--testing update and delete
--UPDATE tblPerson set studyID = 5 where sourceSystemIDLabel = 'F-101-066'
--select * from tblPerson where sourceSystemIDLabel = 'F-101-066'
--delete from tblPerson where sourceSystemIDLabel = 'F-101-201'
--select * from tblPerson where sourceSystemIDLabel = 'F-101-201'
**************************************************************************/
CREATE PROCEDURE [dbo].[usp_Study 102ClinicalDataDates]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study 102ClinicalDataDates][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study 102ClinicalDataDates]...'


--**************************************************************************
--*******[tblPerson]********DBCC CHECKIDENT('tblPerson', RESEED, 1)*******
--**************************************************************************
--drop table
IF OBJECT_ID('tempdb..#sourceDates') IS NOT NULL
DROP TABLE #sourcePerson  

SELECT
	subject.subjectID as SubjectID
	, ParticipantConsentID as dateEventID --**Change from crfEventID
	, NULL as CrfType  --** only if the data comes from a CRF
	, 'Consent' as [dateName]
	, ParticipantConsent.ConsentSigneddate as dateValue
	, ParticipantConsent.ConsentSigneddateDay as dayOf
	, ParticipantConsent.ConsentSigneddateMonth as monthOf
	, ParticipantConsent.ConsentSigneddateYear as yearOf
--INTO #sourceDates
FROM ITMIDIFZ.Genesis.ParticipantConsent as ParticipantConsent
	INNER JOIN TblSubject subject
		ON subject.sourceSystemSubjectID = ParticipantConsent.participantID  --**participants are subjecs in DIFZ data



--Slowly Changing dimension
MERGE  ITMIDW.[dbo].[tblClinicalDataDates] AS targetDates
USING #sourceDates sp
	ON targetDates.dateEventID = sp.dateEventID
WHEN MATCHED
	AND (
	sp.SubjectID <> targetPerson.SubjectID OR 
	sp.CrfType <> targetPerson.CrfType OR 
	sp.[dateName] <> targetPerson.[dateName] OR 
	sp.dayOf <> targetPerson.dayOf OR 
	sp.monthOf <> targetPerson.monthOf OR 
	sp.yearOf <> targetPerson.yearOf
	)
THEN UPDATE SET
	sp.SubjectID = targetPerson.SubjectID ,
	sp.CrfType = targetPerson.CrfType ,
	sp.[dateName] = targetPerson.[dateName] ,
	sp.dayOf = targetPerson.dayOf ,
	sp.monthOf = targetPerson.monthOf ,
	sp.yearOf = targetPerson.yearOf
WHEN NOT MATCHED THEN

INSERT (subjectID,dateEventID,CrfType,[dateName],dateValue,dayOf,monthOf,yearOf)
VALUES (subjectID,dateEventID,CrfType,[dateName],dateValue,dayOf,monthOf,yearOf);

END



