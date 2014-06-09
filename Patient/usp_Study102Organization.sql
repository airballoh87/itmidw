IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'itmidw.[usp_Study102Organization]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study102Organization]
GO
/**************************************************************************
Created ON : 3/29/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study102Organization]
Functional : ITMI SSIS for Insert and Update for study 102 tblOrganization
 Which is attaching subjects to other entities, including family, original site WHERE the subject was enrolled.
History : Created ON 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102Organization]
--TRUNCATe table itmidw.[tblOrganization] 
--select * FROM itmidw.[tblOrganization] 
update itmidw.[tblSubjectIdentifer]   set subjectIdentifier  = 'memaw' WHERE subjectID = 6626
select * FROM itmidw.[tblSubjectIdentifer]  WHERE subjectID = 6626
delete FROM itmidw.[tblSubjectIdentifer]  WHERE subjectID = 6621
select * FROM itmidw.[tblSubjectIdentifer]  WHERE subjectID = 6621
**************************************************************************/
CREATE PROCEDURE itmidw.[usp_Study102Organization]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102Organization][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].itmidw.[usp_Study102Organization]...'

--*************************************
--******************102****************
--*************************************
--drop table
IF OBJECT_ID('tempdb..#sourceOrganization') IS NOT NULL
DROP TABLE #sourceOrganization

IF OBJECT_ID('tempdb..#tempParent') IS NOT NULL
DROP TABLE #tempParent
--Family ID - ITMI Specific

SELECT DISTINCT
           (select orgtype.organizationTypeID FROM itmidw.tblOrganizationType orgType WHERE OrganizationTypeName = 'Family' ) AS [organizationTypeID]
           , CONVERT(VARCHAR(100),subject.SubjectID) AS [organizationCode]
           , subject.subjectNumber AS [organizationName]
		   , CONVERT(varchar(100),NULL) AS organizationParentID
           ,3 AS [orgSourceSystemID]
           ,GETDATE() [createDate]
           ,'usp_Study102Organization' AS [createdBy]
INTO #sourceOrganization
	FROM difzDBcopy.Subject subject
		WHERE subject.isActive = 1
		
--Organization
INSERT INTO #sourceOrganizatiON ([organizationTypeID], [organizationCode], [organizationName],organizationParentID,[orgSourceSystemID],[createDate],[createdBy])
SELECT DISTINCT
           (select orgtype.organizationTypeID FROM itmidw.tblOrganizationType orgType WHERE OrganizationTypeName = 'Clinical Site' ) AS [organizationTypeID]
           , ISNULL(CONVERT(varchar(50),org.siteIdentifier), CONVERT(varchar(50),org.organizationID)) AS [organizationCode]
           , org.organizationName AS [organizationName]
		   , org.partOfOrganizationID  AS organizationParentID
           , 3 AS [orgSourceSystemID]
           , GETDATE() [createDate]
           ,'usp_Study102Organization' AS [createdBy]
	FROM difzDBcopy.[Organization] org
	WHERE org.isactive = 1



--Slowly changing dimension
MERGE  itmidw.[tblOrganization] AS targetOrganization
USING #sourceOrganizatiON ss
	ON targetOrganization.organizationCode = ss.organizationCode
		AND targetOrganization.organizationTypeID = ss.organizationTypeID
WHEN MATCHED
	AND (
		ss.organizationName <> targetOrganization.organizationName OR
		ss.[orgSourceSystemID] <> targetOrganization.[orgSourceSystemID] OR  
		ss.[createDate] <> targetOrganization.[createDate] OR
		ss.[createdBy] <> targetOrganization.[createdBy] 
	)
THEN UPDATE SET
	 organizationName = ss.organizationName
	, [orgSourceSystemID] = ss.[orgSourceSystemID]
	, [createDate] = ss.[createDate] 
	, [createdBy] = ss.[createdBy] 
WHEN NOT MATCHED THEN

INSERT ([organizationTypeID], [organizationCode], [organizationName],[orgSourceSystemID],[createDate],[createdBy])
VALUES (ss.[organizationTypeID], ss.[organizationCode], ss.[organizationName],ss.[orgSourceSystemID],ss.[createDate],ss.[createdBy]);


--update parent organization
SELECT org.organizationID, parUpdate.organizationID AS ParentID
INTO #tempParent
FROM itmidw.tblOrganizatiON org
	INNER JOIN #sourceOrganizatiON so
		ON so.organizationCode = org.organizationCode
	INNER JOIN #sourceOrganizatiON parent
		ON parent.organizationCode = so.organizationParentID
	INNER JOIN itmidw.tblOrganizatiON parUpdate
		ON parUpdate.organizationCode = parent.organizationCode
WHERE org.organizationTypeID = (select orgtype.organizationTypeID FROM itmidw.tblOrganizationType orgType WHERE OrganizationTypeName = 'Clinical Site' )

UPDATE itmidw.tblOrganizatiON set organizationParentID = tp.ParentID
FROM itmidw.tblOrganizatiON org
	INNER JOIN #tempParent tp
		ON tp.organizationID = org.organizationID

--update familyID
UPDATE itmidw.tblOrganization SET itmiFamilyCode =  SUBSTRING(organizationName,5,5)
FROM itmidw.tblOrganization
WHERE orgSourceSystemID =(SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') 
	and organizationTypeID = (SELECT organizationTypeID FROM itmidw.tblOrganizationType WHERE organizationTypeName = 'Family')

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'


END


