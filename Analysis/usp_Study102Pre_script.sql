/****** Object:  StoredProcedure [itmidw].[usp_Study102Pre_script]    Script Date: 3/29/2014 6:39:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**************************************************************************
Created ON : 3/17/2014
Created By : AarON Black
Team Name : Informatics
Object name : [usp_Study102Pre_script]
Functional : ITMI SSIS for Insert and Update for study 102 subjects
Purpose : Import of study 101 subjects from data difz schema for all forms, taking the distinct list of SubjectID's and making an insert.
History : Created ON 3/17/2014
**************************************************************************
Date Modified By QC# Purposes
**************************************************************************
#Date #Comment
**************************************************************************
USE CASE:
EXEC [usp_Study102Pre_script]
--checking both delete and insert component of slowing changing dimension
DELETE FROM  tblsubject where sourceSystemSubjectID = '102-00250-02'
SELECT * FROM  tblsubject where sourceSystemSubjectID = '102-00250-02'
SELECT * FROM  tblsubject where subjectID = '13121'
UPDATE tblsubject set createdby = 'boo..' where subjectID = '13121'

**************************************************************************/
CREATE PROCEDURE [itmidw].[usp_Study102Pre_script]
AS
BEGIN
SET NOCOUNT ON;
DECLARE @UpdatedON SMALLDATETIME
SET @UpdatedON = CAST(GETDATE() AS SMALLDATETIME)
PRINT CONVERT(CHAR(23), @UpdatedOn, 121) + ' [usp_Study102Pre_script][' + @@SERVERNAME + '][' + SYSTEM_USER + ']'
PRINT 'INSERT [itmidw].[usp_Study102Pre_script]...'

--*************************************
--******************101****************
--*************************************

--**Fill in here


END




