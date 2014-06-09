IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[itmidw].[usp_Study101Organization]') AND type in (N'P', N'PC'))
DROP PROCEDURE itmidw.[usp_Study101Organization]
GO
/**************************************************************************
Created ON : 3/29/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study101Organization]
Functional : ITMI SSIS for Insert and Update for study 102 tblOrganization
 Which is attaching subjects to other entities, including family, original site WHERE the subject wAS enrolled.
History : Created ON 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101Organization]
--TRUNCATe table ITMIDW.[dbo].[tblOrganization] 
--SELECT * from ITMIDW.[dbo].[tblOrganization] 

**************************************************************************/
CREATE PROCEDURE [itmidw].[usp_Study101Organization]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101Organization][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[usp_Study101Organization]...'

--*************************************
--**************--drop temp table******
--*************************************
IF OBJECT_ID('tempdb..#sourceOrganization') IS NOT NULL
DROP TABLE #sourceOrganization

IF OBJECT_ID('tempdb..#obscureRef') IS NOT NULL
DROP TABLE #obscureRef


--*************************************--*************************************
--*************************************--*************************************
--*************************************--*************************************
--inserting list of organizations for the subjects from study 101 that were entered in study101Subject
SELECT  DISTINCT 
   (SELECT orgtype.organizationTypeID FROM itmidw.tblOrganizationType orgType WHERE OrganizationTypeName = 'Family' ) AS [organizationTypeID]
	, LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(sub.sourceSystemIDLabel,'NB-101-',''),'M-101-',''),'F-101-',''),'PO-101-',''),'101-',''),'NB-B-',''),'NB-A-',''),'NB-C-',''),3) AS [organizationCode]
	, LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(sub.sourceSystemIDLabel,'NB-101-',''),'M-101-',''),'F-101-',''),'PO-101-',''),'101-',''),'NB-B-',''),'NB-A-',''),'NB-C-',''),3) AS [organizationName]
    , (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'InfoPath') AS [orgSourceSystemID]
    , GETDATE() [createDate]
    , 'usp_Study101Organization' AS [createdBy]
INTO #sourceOrganization	
FROM itmidw.tblSubject sub
	INNER JOIN itmidw.tblperson	p
		ON p.personID = sub.personID
WHERE p.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH')

	
--*************************************
--Slowly changing dimension--**********
--*************************************
MERGE  ITMIDW.[tblOrganization] AS targetOrganization
USING #sourceOrganizatiON ss
	ON targetOrganization.organizationCode = ss.organizationCode
		AND targetOrganization.organizationTypeID = ss.organizationTypeID
		AND targetOrganization.[orgSourceSystemID] = ss.[orgSourceSystemID] --**add to guarantee uniqueness
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


UPDATE itmidw.tblOrganization SET itmiFamilyCode =  SUBSTRING(organizationCode,5,3)
FROM itmidw.tblOrganization
WHERE orgSourceSystemID =(SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'InfoPath') and 
organizationTypeID = (SELECT organizationTypeID FROM itmidw.tblOrganizationType WHERE organizationTypeName = 'Family')
AND itmiFamilyCode IS NULL

END



