IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Study101Prep]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Study101Subject]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**************************************************************************
Created ON : 3/29/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study101Prep]
Functional : ITMI SSIS for preperatiON of staging files FROM DIFZ that will help in subsequent etl processes.
Purpose : Import of study 102 events for reporting and analysis
History : Created ON 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101Prep]
--testing update and delete
**************************************************************************/
CREATE PROCEDURE [dbo].[usp_Study101Prep]
AS
BEGIN


SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101Prep][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study101Prep]...'


--**************************************************************************
--drop table
--****************************************************************
--**update to set subjectID from the epic staging tables**********
--****************************************************************
update [EPIC].[epicMOMDiags] set matchSubjectID = sub.subjectID
FROM [EPIC].[epicMOMDiags] Diag
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),diag.mrn)
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where diag.matchSubjectID is null


update [EPIC].[epicMOMDiags] set matchSubjectID = sub.subjectID
FROM [EPIC].[epicMOMDiags] Diag
	INNER join itmidw.tblSubjectIdentifer id
		on id.subjectIdentifier = CONVERT(varchar(100),diag.provided_mrn)
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where diag.matchSubjectID is null

--Match SubjectID for I3E extract
update [EPIC].[epicMOMDiagsI3E] set matchSubjectID = sub.subjectID
FROM [EPIC].[epicMOMDiagsI3E] diag
	inner join itmidw.tblSubjectIdentifer id
		on LTRIM(RTRIM(id.subjectIdentifier)) = RTRIM(LTRIM(diag.I3E_PAT_MRN))
			and id.subjectIdentifierType = 'MRN'
	INNER join itmidw.tblsubject sub
		on sub.subjectID = id.subjectID
where diag.matchSubjectID is null

END


