DO $$ 
<<create_modify_role>>
BEGIN
    IF NOT EXISTS ( SELECT FROM pg_catalog.pg_user WHERE usename = '${DB_USER_APPROVAL}' ) THEN
        CREATE ROLE ${DB_USER_APPROVAL} LOGIN PASSWORD '${DB_PWD_APPROVAL}';
    ELSE
        ALTER USER approvaluser WITH PASSWORD 'approvaluser';
    END IF;
END create_modify_role $$;

CREATE DATABASE ${DB_NAME_APPROVAL} WITH OWNER=${DB_USER_APPROVAL} TEMPLATE=template0 ENCODING='UTF8';
          
\c ${DB_NAME_APPROVAL}

DO $$
<<create_schema>>
BEGIN
    IF NOT EXISTS ( SELECT schema_name FROM information_schema.schemata WHERE schema_name = '${DB_USER_APPROVAL}' ) THEN
        CREATE SCHEMA ${DB_USER_APPROVAL};
        GRANT ALL PRIVILEGES ON SCHEMA ${DB_USER_APPROVAL} TO ${DB_USER_APPROVAL};
    END IF;
END create_schema $$;
