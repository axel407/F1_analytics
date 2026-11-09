SELECT 
    COUNT(*) AS n
FROM stg_sessions 
HAVING COUNT(*) <> 24
