-- Grain: one row per session
CREATE OR REPLACE VIEW stg_sessions AS
SELECT
    session_key,
    meeting_key,
    year,
    circuit_short_name    AS circuit,      -- the short circuit name
    country_name          AS country,
    date_start::DATE      AS race_date,
    is_cancelled
FROM read_json_auto('data/raw/sessions/*.json');
