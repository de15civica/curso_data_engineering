
{{
  config(
    MATERIALIZED = 'VIEW'
  )
}}

WITH SRC_ADDRESSES AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'ADDRESSES') }}
    ),

RENAMED_ADDRESSES AS (
    SELECT
        ADDRESS_ID,
        ADDRESS,
        -- CITY
        STATE,
        ZIPCODE AS ZIP_CODE,
        --MD5(LOWER(COUNTRY)) AS COUNTRY_ID,
        {{ dbt_utils.generate_surrogate_key(['COUNTRY']) }} AS COUNTRY_ID,
        -- IS_ACTIVE
        _FIVETRAN_DELETED AS IS_ROW_DELETED,
        CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS DATETIME_ROW_LOADED
    FROM SRC_ADDRESSES
    )

SELECT * FROM RENAMED_ADDRESSES

/*se podria anadir ADDRESS_TYPE_ID, para definir si es la direccion principal (misma de la residaencia) o secundaria de envio
Demographics: The median household income segun zipcode, ciudad
Descarga los datos del Census Bureau:

Ve al portal oficial: data.census.gov - ACS Detailed Tables.
Busca tablas como:
https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.2020.html#zcta
B19013: Median Household Income by ZIP Code Tabulation Area.
B19001: Household Income by Gross Amount (desglose por tramos).
B19301: Per Capita Income.*/