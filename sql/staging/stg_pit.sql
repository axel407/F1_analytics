CREATE OR REPLACE VIEW stg_pit AS
SELECT 
    session_key, 
    lap_number, 
    lane_duration AS pit_lane_s,
    stop_duration, 
    driver_number 
FROM read_json_auto('data/raw/pit/*.json');
