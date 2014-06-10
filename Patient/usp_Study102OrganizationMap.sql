IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[itmidw].[usp_Study102OrganizationMap]') AND type in (N'P', N'PC'))
DROP PROCEDURE [itmidw].[usp_Study102OrganizationMap]
GO
/**************************************************************************
Created ON : 3/29/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study102OrganizationMap]
Functional : ITMI SSIS for Insert and Update for study 102 tblOrganizationMap
 Which is attaching subjects to other entities, including family, original site where the subject was enrolled.  This is the map back
 to the subject
History : Created ON 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102OrganizationMap]
--TRUNCATe table ITMIDW.[dbo].[tblOrganization] 
--select * from ITMIDW.[dbo].[tblOrganization] 

**************************************************************************/
CREATE PROCEDURE [itmidw].[usp_Study102OrganizationMap]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102OrganizationMap][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[itmidw].[usp_Study102OrganizationMap]...'

--*************************************
--************--drop table*************
--*************************************
IF OBJECT_ID('tempdb..#sourceOrganization') IS NOT NULL
DROP TABLE #sourceOrganization



--*************************************
--************--family*****************
--*************************************
SELECT DISTINCT
		   sub.subjectID AS [subjectID]
           , org.organizationID AS [organizationID]
           , org.organizationName  AS [organizationTypeName]
INTO #sourceOrganization
	FROM difzDBcopy.Subject subject
		INNER JOIN difzDBcopy.Participant part
			ON part.subjectID = subject.subjectId
		INNER JOIN itmidw.tblSubject sub
			ON LTRIM(RTRIM(CONVERT(VARCHAR(100),sub.sourceSystemSubjectID))) = CONVERT(VARCHAR(100),part.participantID)
		INNER JOIN itmidw.tblOrganizatiON org
			ON CONVERT(VARCHAR(100),org.organizationCode) = CONVERT(VARCHAR(100),subject.subjectID)
	WHERE subject.isActive = 1
		
--*************************************
--************--organization***********
--*************************************
INSERT INTO #sourceOrganizatiON ([subjectID], [organizationID], [organizationTypeName])
	SELECT 
		   sub.subjectID AS [subjectID]
           , org.organizationID AS [organizationID]
           , org.organizationName  AS [organizationTypeName]
	FROM difzDBcopy.Subject subject
		INNER JOIN difzDBcopy.Participant part
			ON part.subjectID = subject.subjectId
		INNER JOIN itmidw.tblSubject sub
			ON LTRIM(RTRIM(CONVERT(VARCHAR(100),sub.sourceSystemSubjectID))) = CONVERT(VARCHAR(100),part.participantID)
		INNER JOIN difzDBcopy.studysite site
			ON site.studySiteID = subject.studySiteID
		INNER JOIN difzDBcopy.OrganizatiON difzOrg
			ON difzOrg.organizationID = site.OrganizationID
		INNER JOIN itmidw.tblOrganizatiON org
			ON CONVERT(VARCHAR(100),org.organizationCode) =  ISNULL(CONVERT(VARCHAR(50),DIFZorg.siteIdentifier), CONVERT(VARCHAR(50),DIFZorg.organizationID))
	WHERE subject.isActive = 1
		

--*************************************
--********--Slowly changing dimension**
--*************************************
INSERT INTO ITMIDW.[tblSubjectOrganizationMap] ([subjectID],[organizationID],[organizationTypeName])
SELECT 
	ss.[subjectID]
	,ss.[organizationID]
	,ss.[organizationTypeName] 
FROM #sourceOrganizatiON ss
	LEFT JOIN ITMIDW.[tblSubjectOrganizationMap] map
		on map.[subjectID] = ss.[subjectID]
			and map.[organizationID] = ss.[organizationID]
WHERE map.subjectID IS NULL

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'


END


