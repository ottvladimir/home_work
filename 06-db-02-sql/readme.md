Задача 1
Создаю volume

    $ docker volume create postgre_db
    postgre_bd
    $ docker volume create postgre_backup
    postgre_backup
    
Стартую PostgreSQL
    
     docker run -d -v postgre_db:/postgre_db \
                -v postgre_backup:/postgre_backup \
                -e POSTGRES_HOST_AUTH_METHOD=trust \
                -e PGDATA=postgre_db \
                postgres:12

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Задача 2

Создаю БД test_db

    postgres=# CREATE DATABASE test_db;
    CREATE DATABASE
    postgres=# \l
                                     List of databases
       Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
    -----------+----------+----------+------------+------------+-----------------------
     postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
     template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
     template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
     test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
     (4 rows)
     
Создаю пользователя test-admin-user и БД test_db

    postgres=# CREATE USER test_admin_user;
    CREATE ROLE
    postgres=#  GRANT ALL PRIVILEGES ON DATABASE test_db TO test_admin_user;
    GRANT

в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)

    CREATE TABLE orders (id SERIAL PRIMARY KEY, наименование TEXT цена INTEGER);
    CREATE TABLE clients (id SERIAL PRIMARY KEY, фамилия TEXT, страна проживания TEXT,заказ);

предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
создайте пользователя test-simple-user
предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
Таблица orders:

Приведите:

итоговый список БД после выполнения пунктов выше,
описание таблиц (describe)
SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
список пользователей с правами над таблицами test_db

#Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

INSERT INTO orders  (наименование, цена) VALUES ('Шоколад',10),('Принтер',3000),('Книга',500),('Монитор',7000),('Гитара',4000);
