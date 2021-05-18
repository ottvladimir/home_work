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
    
Создаю пользователя test-admin-user

    postgres=# CREATE USER "test-admin-user";

В БД test_db создаю таблицу orders и clients 

    CREATE TABLE orders (id SERIAL PRIMARY KEY, наименование TEXT, цена INTEGER);
    CREATE TABLE clients (id SERIAL PRIMARY KEY, ФИО TEXT, "страна проживания" TEXT,заказ TEXT);

предоставляю привилегии на все операции пользователю test-admin-user на таблицы БД test_db

    GRANT ALL PRIVILEGES ON DATABASE test_db TO "test-admin-user";

создайте пользователя test-simple-user
  
    CREATE USER "test-admin-user";

предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

    GRANT SELECT,INSERT,UPDATE,DELETE ON orders,clients TO "test-simple-user";

Приведите:

итоговый список БД после выполнения пунктов выше,
    
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
    
описание таблиц (describe)

    test_db=# \d
                   List of relations
     Schema |      Name      |   Type   |  Owner   
    --------+----------------+----------+----------
     public | clients        | table    | postgres
     public | clients_id_seq | sequence | postgres
     public | orders         | table    | postgres
     public | orders_id_seq  | sequence | postgres
    (4 rows)

    test_db=# \d orders
                                   Table "public.orders"
        Column    |  Type   | Collation | Nullable |              Default               
    --------------+---------+-----------+----------+------------------------------------
     id           | integer |           | not null | nextval('orders_id_seq'::regclass)
     наименование | text    |           |          | 
     цена         | integer |           |          | 
    Indexes:
        "orders_pkey" PRIMARY KEY, btree (id)

    
    test_db=# \d clients
                                      Table "public.clients"
          Column       |  Type   | Collation | Nullable |               Default               
    -------------------+---------+-----------+----------+-------------------------------------
     id                | integer |           | not null | nextval('clients_id_seq'::regclass)
     фамилия           | text    |           |          | 
     страна проживания | text    |           |          | 
     заказ             | text    |           |          | 
    Indexes:
        "clients_pkey" PRIMARY KEY, btree (id)

SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
 
     SELECT grantee, privilege_type, table_name FROM information_schema.role_table_grants WHERE table_name='orders' OR table_name='clients';

список пользователей с правами над таблицами test_db

    test_db=# \dp orders
                                          Access privileges
     Schema |  Name  | Type  |         Access privileges          | Column privileges | Policies 
    --------+--------+-------+------------------------------------+-------------------+----------
     public | orders | table | postgres=arwdDxt/postgres         +|                   | 
            |        |       | "test-simple-user"=arwd/postgres  +|                   | 
            |        |       | "test-admin-user"=arwdDxt/postgres |                   | 
    (1 row)

    test_db=# \dp clients
                                          Access privileges
     Schema |  Name   | Type  |         Access privileges          | Column privileges | Policies 
    --------+---------+-------+------------------------------------+-------------------+----------
     public | clients | table | postgres=arwdDxt/postgres         +|                   | 
            |         |       | "test-simple-user"=arwd/postgres  +|                   | 
            |         |       | "test-admin-user"=arwdDxt/postgres |                   | 
    (1 row)

#Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

    INSERT INTO orders  (наименование, цена) VALUES ('Шоколад','10'),('Принтер',3000),('Книга',500),('Монитор',7000),('Гитара',4000);
    INSERT INTO clients (ФИО,"страна проживания") VALUES ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
    
    SELECT * FROM orders;
     id | наименование | цена 
    ----+--------------+------
      1 | Шоколад      |   10
      2 | Принтер      | 3000
      3 | Книга        |  500
      4 | Монитор      | 7000
      5 | Гитара       | 4000
    (5 rows)

    test_db=#  SELECT count(*) FROM orders;
     count 
    -------
         5
    (1 row)

    test_db=#  SELECT count(*) FROM clients;
     count 
    -------
         5
    (1 row)
4

    ALTER TABLE clients ADD order_id INTEGER REFERENCES orders (id);
    test_db=# UPDATE clients SET order_id = 3 WHERE ФИО = 'Иванов Иван Иванович'; 
    UPDATE 1
    test_db=# UPDATE clients SET order_id = 4 WHERE ФИО = 'Петров Петр Петрович'; 
    UPDATE 1
    test_db=# UPDATE clients SET order_id = 5 WHERE ФИО = 'Иоганн Себастьян Бах'; 
    UPDATE 1
    test_db=# SELECT clients.ФИО, orders.наименование AS заказ FROM clients JOIN orders  ON clients.order_id=orders.id;
             ФИО          |  заказ  
    ----------------------+---------
     Иванов Иван Иванович | Книга
     Петров Петр Петрович | Монитор
     Иоганн Себастьян Бах | Гитара
    (3 rows)

## Задача 5

    test_db=# EXPLAIN SELECT clients.ФИО, orders.наименование AS заказ FROM clients JOIN orders  ON clients.order_id=orders.id;
                                  QUERY PLAN                               
    -----------------------------------------------------------------------
     Hash Join  (cost=37.00..54.71 rows=610 width=64)
       Hash Cond: (clients.order_id = orders.id)
       ->  Seq Scan on clients  (cost=0.00..16.10 rows=610 width=36)
       ->  Hash  (cost=22.00..22.00 rows=1200 width=36)
             ->  Seq Scan on orders  (cost=0.00..22.00 rows=1200 width=36)
    (5 rows)
## Задача 6

    sudo -u postgres pg_dump test_db > /postgre_backup/test.sql
    docker stop magical_swartz 
    magical_swartz
    docker run -d -v postgre_backup:/postgre_backup -e POSTGRES_HOST_AUTH_METHOD=trust postgres:12
    docker exec -it wonderful_kepler psql -U postgres
    postgres=# CREATE DATABASE newdb;
    docker exec -it wonderful_kepler psql -U postgres -d newdb -f /postgre_backup/test.sql
    
    SET
    SET
    SET
    SET
    SET
     set_config 
    ------------

    (1 row)

    SET
    SET
    SET
    SET
    SET
    SET
    CREATE TABLE
    ALTER TABLE
    CREATE SEQUENCE
    ALTER TABLE
    ALTER SEQUENCE
    CREATE TABLE
    ALTER TABLE
    CREATE SEQUENCE
    ALTER TABLE
    ALTER SEQUENCE
    ALTER TABLE
    ALTER TABLE
    COPY 5
    COPY 5
     setval 
    --------
          5
    (1 row)

     setval 
    --------
          5
    (1 row)

    ALTER TABLE
    ALTER TABLE
    ALTER TABLE
    psql:/postgre_backup/test.sql:177: ERROR:  role "test-simple-user" does not exist
    psql:/postgre_backup/test.sql:178: ERROR:  role "test-admin-user" does not exist
    
