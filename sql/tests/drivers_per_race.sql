SELECT
    session_key,
    COUNT(*) AS n_drivers
FROM stg_drivers
GROUP BY session_key
HAVING COUNT(*) NOT BETWEEN 18 AND 20;