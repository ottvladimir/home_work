# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде - nosql документо-ориентированная;
- Склады и автомобильные дороги для логистической компании - сетевая БД;
- Генеалогические деревья - иерархическая nosql ;
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации - nosql ключ-значение ;
- Отношения клиент-покупка для интернет-магазина - sql;

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись) согласно CAP теореме - это система класса AP, согласно PACELC-теореме  PA/EL
- При сетевых сбоях, система может разделиться на 2 раздельных кластера   согласно CAP теореме - это система класса AP,  согласно PACELC-теореме PA / EC
- Система может не прислать корректный ответ или сбросить соединение согласно CAP теореме - это система класса CP, согласно PACELC-теореме  PA/EL

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему? Нет, так как принципы BASE (производительность) - противоречат принципам ACID (высокая надежность)

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?
Redis, memcashed
Из минусов - отсутствие полноценного SQL, требуется большое количество ОЗУ
Опубликованные сообщения испаряются, независимо от того, был ли какой-либо подписчик.
После подписки на канал клиент переводится в режим подписчика и не может выдавать команды, он становится доступным только для чтения.
