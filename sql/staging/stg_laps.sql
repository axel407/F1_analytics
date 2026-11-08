CREATE OR REPLACE VIEW stg_laps AS
SELECT
    session_key,
    driver_number,
    lap_number,
    date_start          AS lap_started_at,
    lap_duration        AS lap_time_s,
    duration_sector_1   AS sector_1_s,
    duration_sector_2   AS sector_2_s,
    duration_sector_3   AS sector_3_s,
    is_pit_out_lap,
    st_speed            AS speed_trap_kph
FROM read_json_auto('data/raw/laps/*.json');
