SELECT session_key, driver_number, lap_number, COUNT(*) as n_laps
FROM stg_laps 
GROUP BY session_key, driver_number, lap_number
HAVING COUNT(*) > 1;