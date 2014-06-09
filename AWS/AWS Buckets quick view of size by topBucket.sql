
SELECT 
      
  
  [AWSVolume],
	ROUND(sum (sizeinbytes / 1024),3) as sizeInKB,
	ROUND(sum ((sizeinbytes / 1024)/1024),3) as sizeInMB,
	ROUND(sum (((sizeinbytes / 1024)/1024)/1024),3) as sizeInGB,
	ROUND(sum ((((sizeinbytes / 1024)/1024)/1024)/1024),3) as sizeInTB,
	ROUND(sum (((((sizeinbytes / 1024)/1024)/1024)/1024)/1024),3) as sizeInPB
	--,COUNT(*) 
  FROM itmistaging.[aws].[itmiAWSFile_staging]
	GROUP BY [AWSVolume]
	ORDER BY ROUND(sum (sizeinbytes / 1024),3) desc
