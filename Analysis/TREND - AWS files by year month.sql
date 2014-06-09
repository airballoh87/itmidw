select MonthCreated, YearCreated, AWSVolume, COUNT(*) fileCnt
, SUM(sizeinBytes/1024/1024) sizeInMB
, SUM(sizeinBytes/1024/1024/1024) sizeInGB
, CONVERT(VARCHAR(4),yearCreated) +'-'+ CASE WHEN LEN(MonthCreated) = 1 THEN '0'+ CONVERT(VARCHAR(2),MonthCreated) ELSE CONVERT(VARCHAR(2),MonthCreated)  END as dateSort
from itmistaging.aws.itmiAWSFile
GROUP BY MonthCreated, YearCreated, AWSVolume
ORDER BY CONVERT(VARCHAR(4),yearCreated) +'-'+ CASE WHEN LEN(MonthCreated) = 1 THEN '0'+ CONVERT(VARCHAR(2),MonthCreated) ELSE CONVERT(VARCHAR(2),MonthCreated)  END