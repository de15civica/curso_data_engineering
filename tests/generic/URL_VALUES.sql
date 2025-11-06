{% test URL_VALUES(MODEL, COLUMN_NAME) %}
  
  SELECT *
  FROM {{ MODEL }}
  WHERE NOT {{ COLUMN_NAME }} ~ '^https://greenary\.com/product/[0-9a-fA-F-]$'
  
{% endtest %}