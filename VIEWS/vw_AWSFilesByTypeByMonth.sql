
--CREATE drop view  vw_AWSFilesByTypeByMonth
--AS
SELECT  TOP 100 PERCENT
       SUM(fileSizeInGB) AS fileSize, 
       CONCAT(yearCreated, ' year ', CASE LEN(monthCreated) WHEN 1 THEN '0' + monthCreated ELSE monthCreated END, ' month') As Time,
       fileExtension,
       analysisType,
       variantType,
       awsVolume
FROM itmidw.tblFile
GROUP BY 
       monthCreated, 
       yearCreated,
       fileExtension,	
       analysisType,
       variantType,
       awsVolume
ORDER BY 
       CONCAT(yearCreated, ' year ', CASE LEN(monthCreated) WHEN 1 THEN '0' + monthCreated ELSE monthCreated END, ' month')
