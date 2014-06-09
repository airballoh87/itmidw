
ALTER TABLE [dbo].[tblCrfDataDictionary]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfDataDictionary_tblCrf] FOREIGN KEY([crfID])
REFERENCES [dbo].[tblCrf] ([crfID])
GO

ALTER TABLE [dbo].[tblCrfDataDictionary] CHECK CONSTRAINT [FK_tblCrfDataDictionary_tblCrf]
GO

ALTER TABLE [dbo].[tblCrfDataDictionary]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfDataDictionary_tblCrfFields] FOREIGN KEY([fieldID])
REFERENCES [dbo].[tblCrfFields] ([fieldID])
GO

ALTER TABLE [dbo].[tblCrfDataDictionary] CHECK CONSTRAINT [FK_tblCrfDataDictionary_tblCrfFields]
GO

ALTER TABLE [dbo].[tblCrfDataDictionary]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfDataDictionary_tblCrfVersion] FOREIGN KEY([crfVersionID])
REFERENCES [dbo].[tblCrfVersion] ([crfVersionID])
GO

ALTER TABLE [dbo].[tblCrfDataDictionary] CHECK CONSTRAINT [FK_tblCrfDataDictionary_tblCrfVersion]
GO

ALTER TABLE [dbo].[tblCrfDataDictionary]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfDataDictionary_tblStudy] FOREIGN KEY([studyID])
REFERENCES [dbo].[tblStudy] ([studyID])
GO

ALTER TABLE [dbo].[tblCrfDataDictionary] CHECK CONSTRAINT [FK_tblCrfDataDictionary_tblStudy]
GO
USE [ITMIDW]
GO



ALTER TABLE [dbo].[tblCrfEventAnswers]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfEventAnswers_tblCrf] FOREIGN KEY([crfVersionID])
REFERENCES [dbo].[tblCrf] ([crfID])
GO

ALTER TABLE [dbo].[tblCrfEventAnswers] CHECK CONSTRAINT [FK_tblCrfEventAnswers_tblCrf]
GO

ALTER TABLE [dbo].[tblCrfEventAnswers]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfEventAnswers_tblCrfEvent] FOREIGN KEY([eventCrfID])
REFERENCES [dbo].[tblCrfEvent] ([crfEventID])
GO

ALTER TABLE [dbo].[tblCrfEventAnswers] CHECK CONSTRAINT [FK_tblCrfEventAnswers_tblCrfEvent]
GO

ALTER TABLE [dbo].[tblCrfEventAnswers]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfEventAnswers_tblCrfFields] FOREIGN KEY([sourceSystemFieldDataID])
REFERENCES [dbo].[tblCrfFields] ([fieldID])
GO

ALTER TABLE [dbo].[tblCrfEventAnswers] CHECK CONSTRAINT [FK_tblCrfEventAnswers_tblCrfFields]
GO

ALTER TABLE [dbo].[tblCrfEventAnswers]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfEventAnswers_tblSourceSystem] FOREIGN KEY([orgSourceSystemID])
REFERENCES [dbo].[tblSourceSystem] ([sourceSystemID])
GO

ALTER TABLE [dbo].[tblCrfEventAnswers] CHECK CONSTRAINT [FK_tblCrfEventAnswers_tblSourceSystem]
GO


ALTER TABLE [dbo].[tblCrfEvent]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfEvent_tblEvent] FOREIGN KEY([EventID])
REFERENCES [dbo].[tblEvent] ([eventID])
GO

ALTER TABLE [dbo].[tblCrfEvent] CHECK CONSTRAINT [FK_tblCrfEvent_tblEvent]
GO

ALTER TABLE [dbo].[tblCrfEvent]  WITH CHECK ADD  CONSTRAINT [FK_tblCrfEvent_tblSourceSystem] FOREIGN KEY([orgSourceSystemID])
REFERENCES [dbo].[tblSourceSystem] ([sourceSystemID])
GO

ALTER TABLE [dbo].[tblCrfEvent] CHECK CONSTRAINT [FK_tblCrfEvent_tblSourceSystem]
GO

ALTER TABLE [dbo].[tblSubject]  WITH CHECK ADD  CONSTRAINT [FK_tblSubject_tblPerson] FOREIGN KEY([personID])
REFERENCES [dbo].[tblPerson] ([personID])
GO

ALTER TABLE [dbo].[tblSubject] CHECK CONSTRAINT [FK_tblSubject_tblPerson]
GO

ALTER TABLE [dbo].[tblSubject]  WITH CHECK ADD  CONSTRAINT [FK_tblSubject_tblSourceSystem] FOREIGN KEY([orgSourceSystemID])
REFERENCES [dbo].[tblSourceSystem] ([sourceSystemID])
GO

ALTER TABLE [dbo].[tblSubject] CHECK CONSTRAINT [FK_tblSubject_tblSourceSystem]
GO

ALTER TABLE [dbo].[tblSubject]  WITH CHECK ADD  CONSTRAINT [FK_tblSubject_tblStudy] FOREIGN KEY([studyID])
REFERENCES [dbo].[tblStudy] ([studyID])
GO

ALTER TABLE [dbo].[tblSubject] CHECK CONSTRAINT [FK_tblSubject_tblStudy]
GO

