
{{
  config(
    MATERIALIZED = 'VIEW'
  )
}}

WITH SRC_PROMOS AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'PROMOS') }}
    ),

RENAMED_PROMOS AS (
    SELECT
        --MD5(PROMO_ID) AS PROMO_ID,
        {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} AS PROMO_ID,
        PROMO_ID AS PROMO_NAME,
        DISCOUNT AS DISCOUNT_AMOUNT_USD,
        STATUS,
        _FIVETRAN_DELETED AS IS_ROW_DELETED,
        CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS DATETIME_ROW_LOADED
    FROM SRC_PROMOS
    )

SELECT * FROM RENAMED_PROMOS

UNION ALL

SELECT  --MD5('no promo') AS PROMO_ID, 
        {{ dbt_utils.generate_surrogate_key(['\"no promo\"']) }} AS PROMO_ID,
        'no promo' AS PROMO_NAME, 
        0 AS DISCOUNT_AMOUNT_USD, 
        'active' AS STATUS, 
        null AS IS_ROW_DELETED,
        CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP(9)) AS DATETIME_ROW_LOADED