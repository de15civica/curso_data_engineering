
{{
  config(
    MATERIALIZED = 'VIEW'
  )
}}

WITH SRC_EVENTS AS (
    SELECT DISTINCT(EVENT_TYPE) AS EVENT_TYPE_NAME
    FROM {{ source('SQL_SERVER_DBO', 'EVENTS') }}
    ),

RENAMED_EVENT_TYPE AS (
    SELECT
        --MD5(LOWER(EVENT_TYPE_NAME)) AS EVENT_TYPE_ID,
        {{ dbt_utils.generate_surrogate_key(['EVENT_TYPE_NAME']) }} AS EVENT_TYPE_ID,
        EVENT_TYPE_NAME
    FROM SRC_EVENTS
    )

SELECT * FROM RENAMED_EVENT_TYPE