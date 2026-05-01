-- 1. ADV 센서 데이터 테이블
CREATE TABLE IF NOT EXISTS hydrological_data_adv (
    id BIGSERIAL PRIMARY KEY,
    station_code VARCHAR(50) NOT NULL,
    observed_at TIMESTAMP WITH TIME ZONE NOT NULL,
    water_level NUMERIC,
    voltage NUMERIC,
    cell_velocity NUMERIC, -- V_EW
    status VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ADV 데이터 중복 방지 인덱스
CREATE UNIQUE INDEX IF NOT EXISTS idx_adv_station_observed_at ON hydrological_data_adv(station_code, observed_at);


-- 2. ESV 센서(전자파 표면유속계) 데이터 테이블
CREATE TABLE IF NOT EXISTS hydrological_data_esv (
    id BIGSERIAL PRIMARY KEY,
    station_code VARCHAR(50) NOT NULL,
    observed_at TIMESTAMP WITH TIME ZONE NOT NULL,
    water_level NUMERIC,
    voltage NUMERIC,
    surface_velocity NUMERIC, -- EWSV_V
    status VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ESV 데이터 중복 방지 인덱스
CREATE UNIQUE INDEX IF NOT EXISTS idx_esv_station_observed_at ON hydrological_data_esv(station_code, observed_at);


-- 3. 수집 결과 요약 및 로그 테이블
CREATE TABLE IF NOT EXISTS collection_logs (
    id BIGSERIAL PRIMARY KEY,
    batch_id VARCHAR(100) NOT NULL,
    station_code VARCHAR(50) NOT NULL,
    target_month VARCHAR(6) NOT NULL, -- YYYYMM 형식
    file_type VARCHAR(10) NOT NULL,   -- 'ADV' 또는 'ESV'
    total_files INTEGER NOT NULL,
    valid_records INTEGER NOT NULL,   -- 전체 레코드 수
    valid_wl_count INTEGER NOT NULL,  -- 수위 데이터가 있는 레코드 수
    valid_vel_count INTEGER NOT NULL, -- 유속 데이터가 있는 레코드 수
    missing_count INTEGER NOT NULL,
    missing_times JSONB, -- 결측 시간 리스트를 JSON 형태로 저장
    processed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
