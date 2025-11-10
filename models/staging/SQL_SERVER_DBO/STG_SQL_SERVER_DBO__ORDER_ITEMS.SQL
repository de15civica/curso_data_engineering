
{{
  config(
    materialized = 'incremental',
    unique_key = 'ORDER_ID'
  )
}}

WITH SRC_ORDER_ITEMS AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ORDER_ITEMS') }}

{% if is_incremental() %}

    WHERE _FIVETRAN_SYNCED > (select max(DATETIME_ROW_LOADED) from {{ this }})

{% endif %}

    ),

RENAMED_ORDER_ITEMS AS (
    SELECT
        ORDER_ID,
        PRODUCT_ID,
        CAST(QUANTITY AS NUMBER(5,0)) AS QUANTITY,
        _FIVETRAN_DELETED AS IS_ROW_DELETED,
        CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS DATETIME_ROW_LOADED
    FROM SRC_ORDER_ITEMS
    )

SELECT * FROM RENAMED_ORDER_ITEMS

{% if is_incremental() %}

  WHERE DATETIME_ROW_LOADED > (select max(DATETIME_ROW_LOADED) from {{ this }})

{% endif %}