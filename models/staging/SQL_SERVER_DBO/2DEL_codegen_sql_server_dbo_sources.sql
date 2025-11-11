{{
    codegen.generate_source(
        schema_name = 'ALUMNO15',
        database_name = 'ALUMNO15_DEV_SILVER_DB',
        generate_columns = True,
        include_descriptions=True,
        include_data_types=True,
        include_database=True,
        include_schema=True,
        case_sensitive_databases=True,
        case_sensitive_schemas=True,
        case_sensitive_tables=True,
        case_sensitive_cols=True,
        )
}}