# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1
Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

    $ docker volume create mysql_db
    $ docker run --name mysql -v mysql_db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -d mysql:8
    $ docker exec -it mysql bash
    mysql -uroot -p

Изучите [бэкап БД] и восстановитесь из него.

    mysql> CREATE DATABASE test_db;
    Query OK, 1 row affected (0.00 sec)

Перейдите в управляющую консоль `mysql` внутри контейнера.

    $ docker exec -it mysql mysql -uroot -p
    mysql> \s

    --------------
    mysql  Ver 8.0.25 for Linux on x86_64 (MySQL Community Server - GPL)


Подключитесь к восстановленной БД и получите список таблиц из этой БД.
  
    mysql> use test_db
    mysql> show tables;
    +-------------------+
    | Tables_in_test_db |
    +-------------------+
    | orders            |
    +-------------------+
    1 row in set (0.00 sec)

**Приведите в ответе** количество записей с `price` > 300.

    mysql> select * from orders where price > 300;
    +----+----------------+-------+
    | id | title          | price |
    +----+----------------+-------+
    |  2 | My little pony |   500 |
    +----+----------------+-------+
    1 row in set (0.00 sec)

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James".

Строка:
  
       mysql> CREATE USER 'test'@'localhost' 
            -> IDENTIFIED WITH mysql_native_password BY 'test-pass' 
            -> WITH MAX_QUERIES_PER_HOUR 100 
            -> PASSWORD EXPIRE INTERVAL 180 DAY 
            -> FAILED_LOGIN_ATTEMPTS 3 
            -> ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
        Query OK, 0 rows affected (0.00 sec)
    
Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
    mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost'
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 

    mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
    +------+-----------+---------------------------------------+
    | USER | HOST      | ATTRIBUTE                             |
    +------+-----------+---------------------------------------+
    | test | localhost | {"fname": "James", "lname": "Pretty"} |
    +------+-----------+---------------------------------------+
    1 row in set (0.00 sec)


## Задача 3

Установите профилирование `SET profiling = 1`.

    mysql> SET profiling = 1;
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` 
    
    mysql> SHOW CREATE TABLE orders;
    +--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | Table  | Create Table                                                                                                                                                                                                                              |
    +--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | orders | CREATE TABLE `orders` (
      `id` int unsigned NOT NULL AUTO_INCREMENT,
      `title` varchar(80) NOT NULL,
      `price` int DEFAULT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
    +--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    1 row in set (0.00 sec)

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`
.

    mysql> SHOW PROFILES;
    +----------+------------+--------------------------------------------------------------------+
    | Query_ID | Duration   | Query                                                              |
    +----------+------------+--------------------------------------------------------------------+
    |        1 | 0.00009125 | SHOW PROFILES ALL                                                  |
    |        2 | 0.00092650 | SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test' |
    |        3 | 0.00075525 | SHOW CREATE TABLE orders                                           |
    |        4 | 0.00010150 | ALTER DATABASE test_db ENGINE MyISAM                               |
    |        5 | 0.01897425 | ALTER TABLE orders ENGINE MyISAM                                   |
    |        6 | 0.02601075 | ALTER TABLE orders ENGINE innodb                                   |
    +----------+------------+--------------------------------------------------------------------+
## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.
   
       [mysqld]
        pid-file        = /var/run/mysqld/mysqld.pid
        socket          = /var/run/mysqld/mysqld.sock
        datadir         = /var/lib/mysql
        secure-file-priv= NULL
        innodb_flush_method=O_DSYNC;
        innodb_flush_log_at_trx_commit = 2
        innodb_file_per_table=1;
        innodb_log_buffer_size = 1M;
        inodb_buffer_pool_size=8G; #24 Gb memory
