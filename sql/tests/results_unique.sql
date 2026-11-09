SELECT session_key, driver_number, COUNT(*) as n_results 
FROM stg_results 
GROUP BY session_key, driver_number
HAVING COUNT(*) > 1;