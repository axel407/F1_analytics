-- Grain: ___
CREATE OR REPLACE VIEW stg_results AS
SELECT
    session_key,
    driver_number,
    position                AS finish_position,   -- NULL = not classified
    points,
    number_of_laps          AS laps_completed,
    duration                AS race_time_s,
    dnf,
    dns,
    dsq,
    TRY_CAST(gap_to_leader AS DOUBLE) AS gap_to_leader_s,
    TRY_CAST(
        regexp_extract(gap_to_leader::VARCHAR, '\+(\d+) LAP', 1)
        AS INTEGER
    ) AS laps_behind
FROM read_json_auto('data/raw/session_result/*.json');
