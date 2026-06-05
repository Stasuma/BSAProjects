# официальный образ PostgreSQL
FROM postgres:17

# пакеты
RUN apt update && apt install -y \
    postgresql-contrib \
    vim\
    && rm -rf /var/lib/apt/lists/*

# устанавить переменные окружения
ENV POSTGRES_DB=Korotkova
ENV POSTGRES_USER=KorotkovaUser
ENV POSTGRES_PASSWORD=12345
ENV PGDATA=/var/lib/postgresql/data/pgdata

# создать директорию для хранения данных
RUN mkdir -p $PGDATA && chown -R postgres:postgres $PGDATA

# указать порт
EXPOSE 5432

# установить место, которое контейнер будет использовать для постоянной работы и хранения файлов
VOLUME [«$PGDATA»]

# запуск PostgreSQL
CMD ["postgres"]
