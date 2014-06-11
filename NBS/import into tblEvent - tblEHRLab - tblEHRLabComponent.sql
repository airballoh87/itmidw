--alter table for itmiconvertedsubject

/*
INSERT INTO [itmidw].[tblEHREventLab]
           ([eventID]
           ,[sourcesystemEventID]
           ,[subjectID]
           ,[labOrderDate]
           ,[labResultDate]
           ,[labLengthInDays]
           ,[labOrder]
           ,[labComponentCnt]
           ,[orgSourceSystemID]
           ,[createDate]
           ,[createdBy])
  */
  SELECT*
           --(<eventID, int,>
           --,<sourcesystemEventID, varchar(100),>
           --,<subjectID, int,>
           --,<labOrderDate, datetime,>
           --,<labResultDate, datetime,>
           --,<labLengthInDays, int,>
           --,<labOrder, varchar(100),>
           --,<labComponentCnt, int,>
           --,<orgSourceSystemID, int,>
           --,<createDate, datetime,>
           --,<createdBy, varchar(100),>)
FROM [dbo].[nbsAbnormal]

