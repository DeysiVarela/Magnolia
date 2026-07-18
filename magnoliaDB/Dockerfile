FROM postgres:16
COPY 10_opcional1_legacy_pos_general.sql /docker-entrypoint-initdb.d/10_opcional1_legacy_pos_general.sql
COPY 11_opcional1_modelo_3fn.sql /docker-entrypoint-initdb.d/11_opcional1_modelo_3fn.sql
COPY 12_opcional1_migracion.sql /docker-entrypoint-initdb.d/12_opcional1_migracion.sql

ENV POSTGRES_USER=u_magnolia
ENV POSTGRES_PASSWORD=m4gn0l14
ENV POSTGRES_DB=db_magnolia
