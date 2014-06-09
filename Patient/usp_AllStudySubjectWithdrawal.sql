IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ITMIDW].[usp_AllStudySubjectWithdrawal]') AND type in (N'P', N'PC'))
DROP PROCEDURE ITMIDW.[usp_AllStudySubjectWithdrawal]
GO
/**************************************************************************
Created On : 3/17/2014
Created By : Aaron Black
Team Name : Informatics
Object name : [usp_AllStudySubjectWithdrawal]
Functional : ITMI SSIS for Insert legacy for Subject Withdrawals
Purpose : Takes data from spreadsheets provided by ITMI Clinical Team, adds it to a temp table #t.  Then inserts these subject withdrawals.
History : Created on 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC itmidw.[usp_AllStudySubjectWithdrawal]
select sub.* FROM [ITMIDW].[dbo].[tblSubjectWithDrawal] wi inner join tblsubject sub on sub.subjectID = wi.subjectID
**************************************************************************/
CREATE PROCEDURE [ITMIDW].[usp_AllStudySubjectWithdrawal]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedOn SMALLDATETIME
SET @UpdatedOn = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_AllStudySubjectWithdrawal][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [ITMIDW].[dbo].[tblSubjectWithDrawal]...'

--*********************************************
--drop temp table--****************************
--*********************************************

IF OBJECT_ID('tempdb..#T') IS NOT NULL
DROP TABLE #T  

--*************************************************
--Create blank temp table for eventual withdrawals--
--*************************************************

SELECT  CONVERT(varchar(100),NULL) AS Subject
,CONVERT(varchar(100),NULL) AS site
,CONVERT(varchar(100),NULL) AS sitenumber
,CONVERT(varchar(100),NULL) AS instanceName
,CONVERT(varchar(100),NULL) AS folderID
,CONVERT(varchar(100),NULL) AS WDDAT_RAW
,CONVERT(varchar(100),NULL) AS WDOTH
INTO #T

--*********************************************
--****insert DIFZ withdrawls into temp table--*
--*********************************************
INSERT INTO #t (subject, site)
SELECT
	sub.subjectID
	,  ParticipantWithdrawal.participantID
FROM itmidifz.genesis.ParticipantWithdrawal AS ParticipantWithdrawal
	INNER JOIN itmidw.TblSubject sub
		on sub.sourceSystemSubjectID = CONVERT(VARCHAR(100),ParticipantWithdrawal.participantID)
WHERE sub.orgSourceSystemID = (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ') 

--*********************************************--*********************************************
--insert study 101 data, this is manual for exported spreadsheet given by Clinical data team-
--*********************************************--*********************************************

INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-059','withdrew','','','','P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-098','withdrew','','','','P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-114','withdrew','MISSING DAD','B, S, A','','B, S, A, P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-133','withdrew','MISSING DAD','B, S, A','','B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-154','withdrew','','B, S, A','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-168','withdrew','(missing FOB)','B, S, A','','A) B, S, A                     B) B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-211','withdrew',' (missing FOB)','B, S, A','','A) B, S, A                     B) B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-291','withdrew','','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-294','withdrew','','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-340','withdrew','','B, S, A','','B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-345','withdrew','','B, S, A','','B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-366','withdrew','','','B, S, A','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-378','withdrew','','B, S, A','','B, S, A, P',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-383','withdrew','','','B, S, A','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-407','withdrew','','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-416','withdrew','','B','','C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-418','withdrew','','B','','P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-425','withdrew','','','B, S, A','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-429','withdrew','','','','B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-431','withdrew','','','','P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-442','withdrew','','B, S, A','','B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-453','withdrew',' ','','B, S, A','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-475','withdrew','','B, S, A','','B, S, A, P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-484','withdrew','','B, S, A','B, S, A','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-493','withdrew','','B, S, A','','B, S, A, P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-496','withdrew','','','','B, S, A, P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-540','withdrew','','B, A','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-573','withdrew','','B, S, A','','B, S, A, P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-655','withdrew',' prior to samples being collected','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-674','withdrew','','','','B',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-685','withdrew','','','','B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-690','withdrew','','','','S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-691','withdrew','','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-701','withdrew','','','','P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-707','withdrew','','B','','B, S, A, P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-721','withdrew','','B','','P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-727','withdrew','','B, S, A','','B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-737','withdrew','','B, S, A','S, A','A)                              B) S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-761','withdrew','','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-767','withdrew','','','S, A','P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-779','withdrew','','B, S, A','B, S, A','P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-829','withdrew','','S, A','B, S, A','B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-916','withdrew','','B, S, A','','B, S, A, P, C',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-939','withdrew','','B, S, A','','A) B, S, A                     B) B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-950','withdrew','','B, S, A','S, A','S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-960','withdrew','','B, S, A','','B, S, A',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-332 (a)','withdrew','','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-214 (a)','withdrew','','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-201 (a)','withdrew','','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-221 (a)','withdrew','','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-189 (a)','withdrew','','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT '101-120 (a)','withdrew','','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT	'101-038',	'withdrew',	'','','','',''
INSERT INTO #t (subject, site, sitenumber, instanceName, folderID, WDDAT_RAW, WDOTH) SELECT	'101-074',	'withdrew',	'','','','',''

--*********************************************--*********************************************--*********************************************
--delete any row where the subject is NULL, done to remove blank record inserted to create temp table--**************************************
--*********************************************--*********************************************--*********************************************
DELETE FROM #T where subject IS NULL

--*********************************************--
--**Truncate table --table refreshed each time*--
--*********************************************--
TRUNCATE TABLE [ITMIDW].[tblSubjectWithDrawal]

--*************************************************
--**INSERT Statement into ITMIDW table-- 101*******
--*************************************************
INSERT INTO  [ITMIDW].[tblSubjectWithDrawal]
           ([subjectID]
           ,[subjectWithReason]
           ,[SourceSystemID]
           ,[createdDate]
           ,[createdBy])
SELECT
 --(<subjectID, int,>
sub.subjectID
 --,<subjectWithReason, varchar(100),>
, CASE WHEN LEN(wdoth) =  0 THEN site ELSE wdoth END AS withReason
 --,<SourceSystemID, int,>
, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'INFOPATH') 
 --,<createdDate, datetime,>
, GETDATE()
 --,<createdBy, varchar(100),>)
, 'usp_AllStudySubjectWithdrawal'
FROM #t	t
	 JOIN ITMIDW.tblsubject sub
		ON t.subject = 
			CASE
				WHEN LEFT(t.subject,3) = '101' 
					THEN REPLACE(REPLACE(REPLACE(sub.sourceSystemIDLabel,'F-',''),'M-',''),'NB-','')  --stripping family characters
				ELSE LEFT(sub.sourceSystemIDLabel,9) --stripping off the the family codes from the right side of ID
			END
	WHERE site = 'withdrew'

	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ 'Study 101 row(s) updated.'

--*************************************************
--**INSERT Statement into ITMIDW table-- 102**************
--*************************************************


INSERT INTO  [ITMIDW].[tblSubjectWithDrawal]
           ([subjectID]
           ,[subjectWithReason]
           ,[SourceSystemID]
           ,[createdDate]
           ,[createdBy])
SELECT
 --(<subjectID, int,>
sub.subjectID
 --,<subjectWithReason, varchar(100),>
, CASE WHEN LEN(wdoth) =  0 THEN site ELSE wdoth END AS withReason
 --,<SourceSystemID, int,>
, (SELECT ss.sourceSystemID FROM itmidw.tblSourceSystem ss WHERE ss.sourceSystemSHortName = 'DIFZ')  
 --,<createdDate, datetime,>
, GETDATE()
 --,<createdBy, varchar(100),>)
, 'usp_AllStudySubjectWithdrawal'
FROM #t	t
	 JOIN ITMIDW.tblsubject sub
		ON t.subject =  sub.subjectID
WHERE site <> 'withdrew'

PRINT CAST(@@ROWCOUNT AS VARCHAR(10))+ 'Study 102 row(s) updated.'

END
GO