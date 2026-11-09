SELECT
    session_key,
    driver_number,
    lap_number,
    lap_time_s
FROM stg_laps
WHERE lap_time_s NOT BETWEEN 60 AND 200;