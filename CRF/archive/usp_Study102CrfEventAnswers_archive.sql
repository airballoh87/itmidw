IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Study102CrfEventAnswers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Study102CrfEventAnswers]
GO
/**************************************************************************
Created On : 3/29/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_Study102CrfEventAnswers]
Functional : ITMI SSIS for Insert and Update for study 102 tblCrfData
 THis is the detail data
History : Created on 3/29/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102CrfEventAnswers]
--TRUNCATe table ITMIDW.[dbo].[tblOrganization] 
--select * from ITMIDW.[dbo].[tblOrganization] 

**************************************************************************/
CREATE PROCEDURE [dbo].[usp_Study102CrfEventAnswers]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102CrfEventAnswers][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[usp_Study102CrfEventAnswers]...'

--*************************************
--******************102****************
--*************************************
--drop table
IF OBJECT_ID('tempdb..#sourceCrfData') IS NOT NULL
DROP TABLE #sourceCrfDat


SELECT 
           deets.patientDataPointDetailID as [sourceSystemFieldDataID]
           ,deets.fieldName as [sourceSystemFieldDataLabel]
           ,eve.crfEventID as  [eventCrfID]
           ,crf.crfID as [crfVersionID]
           ,deets.fieldValue as [fieldValue]
           ,NULL as [hadQuery]
           ,case when deets.queryStatus = 'Open' Then 1 ELSE 0 END as [openQuery]
           ,NULL as [fieldValueOrdinal]
           ,(SELECT ss.sourceSystemID FROM ITMIDW.DBO.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') as [orgSourceSystemID]
           ,GETDATE() [createDate]
           ,'usp_Study102CrfData' as [createdBy]
INTO #sourceCrfData
	FROM itmiDIFZ.genesis.PatientDataPointDetail as deets
		INNER JOIN ITMIDW.dbo.tblSubject subject
			ON subject.subjectId = deets.itmidwSubjectID
		INNER JOIn ITMIDW.dbo.tblCrf crf
			ON crf.crfName = deets.itmiFormName
		INNER JOIN ITMIDW.dbo.tblCrfEvent eve
			ON eve.sourceSystemCrfEventID = deets.recordID
	WHERE deets.isactive = 1	



--Slowly changing dimension
MERGE  ITMIDW.[dbo].[tblCrfEventAnswers] AS targetCrfData
USING #sourceCrfData ss
	ON targetCrfData.[sourceSystemFieldDataID] = ss.[sourceSystemFieldDataID]
      	
WHEN MATCHED
	AND (
           ss.[sourceSystemFieldDataID] <> targetCrfData.[sourceSystemFieldDataID] OR  
           ss.[sourceSystemFieldDataLabel] <> targetCrfData.[sourceSystemFieldDataLabel] OR  
           ss.[eventCrfID] <> targetCrfData.[eventCrfID] OR  
           ss.[crfVersionID] <> targetCrfData.[crfVersionID] OR  
           ss.[fieldValue] <> targetCrfData.[fieldValue] OR  
           ss.[hadQuery] <> targetCrfData.[hadQuery] OR  
           ss.[openQuery] <> targetCrfData.[openQuery] OR  
           ss.[fieldValueOrdinal] <> targetCrfData.[fieldValueOrdinal] OR  
		   ss.[orgSourceSystemID] <> targetCrfData.[orgSourceSystemID] OR  
		   ss.[createDate] <> targetCrfData.[createDate] OR
		   ss.[createdBy] <> targetCrfData.[createdBy] 
	)
THEN UPDATE SET
           [sourceSystemFieldDataID] = ss.[sourceSystemFieldDataID]
           , [sourceSystemFieldDataLabel] = ss.[sourceSystemFieldDataLabel]
           , [eventCrfID] = ss.[eventCrfID]
           , [crfVersionID] = ss.[crfVersionID]
           , [fieldValue] = ss.[fieldValue]
           , [hadQuery] = ss.[hadQuery]
           , [openQuery] = ss.[openQuery]
           , [fieldValueOrdinal] = ss.[fieldValueOrdinal]
		   , [orgSourceSystemID] = ss.[orgSourceSystemID]
	       , [createDate] = ss.[createDate] 
	       , [createdBy] = ss.[createdBy] 
WHEN NOT MATCHED THEN

INSERT (   [sourceSystemFieldDataID]
           ,[sourceSystemFieldDataLabel]
           ,[eventCrfID]
           ,[crfVersionID]
           ,[fieldValue]
           ,[hadQuery]
           ,[openQuery]
           ,[fieldValueOrdinal]
		   ,[orgSourceSystemID]
		   ,[createDate]
		   ,[createdBy])

VALUES (    ss.[sourceSystemFieldDataID]
           ,ss.[sourceSystemFieldDataLabel]
           ,ss.[eventCrfID]
           ,ss.[crfVersionID]
           ,ss.[fieldValue]
           ,ss.[hadQuery]
           ,ss.[openQuery]
           ,ss.[fieldValueOrdinal]
		   ,ss.[orgSourceSystemID]
		   ,ss.[createDate]
		   ,ss.[createdBy]);



END


