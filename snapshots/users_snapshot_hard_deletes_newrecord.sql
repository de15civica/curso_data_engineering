{% snapshot users_snapshot_hard_deletes_newrecord %}

{{
    config(
      target_schema='snapshots',
      unique_key='DNI',
      strategy='timestamp',
      updated_at='FECHA_ALTA_SISTEMA',
      hard_deletes='new_record',
    )
}}

select * from {{ source('google_sheets', 'users') }}

{% endsnapshot %}