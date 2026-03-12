Я робив наше ТЗ з допомогою Докера

1а. Стягнути образ
docker pull postgres

2а. Заранити контейнер для Мастера
docker run -d --name postgres-db -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=mydb -p 5432:5432 -v postgres-data:/var/lib/postgresql postgres

3а. Увійти в консоль контейнера
docker exec -u 0 -it postgres-db bash

   3а1. Оновлення індексу встановлених пакетів
   apt-get update
   
   3а2. Встановлення pg_cron (для запуску регламентних задач)
   apt-get install -y postgresql-18-cron
   
   3а3. Оновлення значень в конфіг-файлі для правильної роботи pg_cron
   CONF_FILE=$(psql -U postgres -t -c "SHOW config_file;" | xargs)
   sed -i '/shared_preload_libraries/d' $CONF_FILE
   sed -i '/cron.database_name/d' $CONF_FILE
   echo "shared_preload_libraries = 'pg_cron'" >> $CONF_FILE
   echo "cron.database_name = 'mydb'" >> $CONF_FILE
   
   exit

4а. Оновлення значеня в конфіг-файлі для роботи Publisher-а для репліки
docker exec -u 0 -it postgres-db sed -i "s/^#*wal_level =.*/wal_level = logical/" /var/lib/postgresql/18/docker/postgresql.conf
docker restart postgres-db

5а. Створення мережі для роботи Майстер-сервера і Репліки
docker network create pg-repro-net

6а. Підключення контейнера до мережі
docker network connect pg-repro-net postgres-db

7а. Заранити контейнер для Репліки
docker run -d --name postgres-db-replica --network pg-repro-net -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=mydb -p 5433:5432 -v postgres-data-replica:/var/lib/postgresql postgres


POSTGRESS

1б. Створюємо партиційовану таблицю на Мастер-сервері
1_create_partitioning_table.sql

2б. Створити процедуру для генерації данних
2_generate_operations_data.sql

3б. Нагенерити данних
3_generate_data.sql

4б. Створення індексів
4_indexes.sql

5б. Створити процедуру для вставки одної операції в таблицю
5_insert_single_operation.sql

6б. Створення процедури для оновлення статусу за паритетом
6_update_status_by_parity.sql

7б. Створення таблиці для балансів клієнтів
7_create_table_client_balances.sql

8б. Синхронізувати початкові данні з таблиці Operation з таблицею ClientBalances
8_sync_data.sql

9б. Створення функції для оновлення суми балансу
9_update_incremental_balance.sql

10б. Створення тригеру на оновлення балансу
10_trg_update_balances_on_status.sql

11б. Створити pg_cron для нашої БД
11_create_pg_cron.sql

12б. Запусти таски для регламентних завдань
12_run_tasks.sql

13б. Publication батьківської таблиці
13_publication_parent_table.sql

14б. Створюємо партиційовану таблицю на Репліка-сервері
1_create_partitioning_table.sql

15б. Підписуємось на оновлення таблиці на Мастер-сервері
14_subscription.sql


