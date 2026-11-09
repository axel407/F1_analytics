CREATE OR REPLACE VIEW stg_stints AS
SELECT 
    session_key,
    driver_number,
    stint_number,
    compound,
    lap_start,
    lap_end,
    tyre_age_at_start,
    lap_end - lap_start + 1 AS stint_laps
FROM read_json_auto('data/raw/stints/*.json')