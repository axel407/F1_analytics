WITH stint_totals AS (
SELECT session_key, driver_number, SUM(stint_laps) AS stint_total 
FROM stg_stints
GROUP BY session_key, driver_number),
lap_totals AS (
SELECT session_key, driver_number, MAX(lap_number) AS laps_driven
FROM stg_laps
GROUP BY session_key, driver_number
)
SELECT
    s.session_key,
    s.driver_number,
    s.stint_total,
    l.laps_driven,
    s.stint_total - l.laps_driven AS diff
FROM stint_totals s
JOIN lap_totals l USING (session_key, driver_number)
WHERE ABS(s.stint_total - l.laps_driven) > 1
