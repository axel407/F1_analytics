-- sql/staging/stg_drivers.sql
-- Grain: one row per driver per session
CREATE OR REPLACE VIEW stg_drivers AS
SELECT
    session_key,
    driver_number,
    full_name,
    name_acronym   AS driver_code,
    team_name,
    '#' || team_colour AS team_color
FROM read_json_auto('data/raw/drivers/*.json');
