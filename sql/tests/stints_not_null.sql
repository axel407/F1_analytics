SELECT * FROM stg_stints
WHERE compound IS NULL 
OR lap_start IS NULL OR lap_end IS NULL;