SELECT l.session_key, l.driver_number
FROM stg_laps l
LEFT JOIN stg_drivers d USING (session_key, driver_number)
 WHERE d.driver_number IS NULL;