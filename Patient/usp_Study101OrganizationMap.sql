
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[itmidw].[usp_Study101OrganizationMap]') AND type in (N'P', N'PC'))
DROP PROCEDURE [itmidw].[usp_Study101OrganizationMap]
GO	
/**************************************************************************
Created On : 4/1/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study101OrganizationMap]
Functional : ITMI SSIS for Insert and Update for study 101 organizationMap	
Purpose : Import of study 101, This is mapping a subject to an organization, usually a family or a site.
History : Created on 4/1/2014
*************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study101OrganizationMap]
--testing update and delete
**************************************************************************/
CREATE PROCEDURE ITMIDW.[usp_Study101OrganizationMap]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study101OrganizationMap][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study101OrganizationMap]...'


--*************************************
--******************101****************
--*************************************
--DELETE FROM 
DELETE FROM itmidw.tblSubjectOrganizationMap WHERE subjectOrganizationMapID IN ( 
select wh.subjectOrganizationMapID
FROM itmidw.tblSubjectOrganizationMap WH
	INNER JOIN itmidw.TblSUbject sub
		on sub.subjectID = wh.subjectID
WHERE sub.studyID = (select studyid from itmidw.tblstudy where studyShortID = '101')
)


--*************************************
--****************Insert***************
--*************************************
INSERT INTO itmidw.[tblSubjectOrganizationMap]([subjectID],[organizationID],organizationTypeName)
SELECT DISTINCT sub.subjectID, org.[organizationID],oType.organizationTypeName
FROM itmidw.tblsubject sub
	INNER JOIN itmidw.[tblOrganization] org
		ON org.organizationCode = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(sub.sourceSystemIDLabel,'NB-101-',''),'M-101-',''),'F-101-',''),'PO-101-',''),'NB-B-101-',''),'NB-A-101-',''),'NB-C-101-','')
	INNER JOIN itmidw.tblOrganizationType oType
		ON oType.organizationTypeID = org.organizationTypeID
	INNER JOIN itmidw.tblperson p
		on p.personID = sub.personID
WHERE p.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH')

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ ' row(s) updated.'

END