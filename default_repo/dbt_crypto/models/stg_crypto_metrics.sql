{{ config(
    materialized='table',
    partition_by={
      "field": "ingested_at",
      "data_type": "timestamp",
      "granularity": "day"
    }
) }}

WITH raw_data AS (
    SELECT * 
    FROM `cryptopipe-project.cryptopipe_raw_data.top_crypto_prices`
)

SELECT 
    CAST(id AS STRING) AS coin_id,
    CAST(symbol AS STRING) AS symbol,
    CAST(name AS STRING) AS name,
    CAST(current_price AS FLOAT64) AS current_price,
    CAST(market_cap AS INT64) AS market_cap,
    CAST(total_volume AS INT64) AS total_volume,
    CAST(last_updated AS TIMESTAMP) AS last_updated,

    -- dbt generates the ingestion timestamp instead of Python
    CURRENT_TIMESTAMP() AS ingested_at,
    
    -- Business Logic
    ROUND(CAST(total_volume AS FLOAT64) / CAST(market_cap AS FLOAT64) * 100, 2) AS volume_to_mcap_ratio_pct,
    
    CASE 
        WHEN CAST(market_cap AS INT64) > 100000000000 THEN 'Mega Cap'
        WHEN CAST(market_cap AS INT64) > 10000000000 THEN 'Large Cap'
        ELSE 'Mid Cap'
    END AS market_cap_tier

FROM raw_data