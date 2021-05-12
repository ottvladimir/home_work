# Домашнее задание к занятию "5.3. Контейнеризация на примере Docker"

## Задача 1 

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование докера? Или лучше подойдет виртуальная машина, физическая машина? Или возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение должно лучше запускать на физической машине, для минимизации затрат на гипервизор, с другой стороны, для возможности быстрого масштабирования и отвязки от железных вендоров можно использовать виртуальные машины; 
- Go-микросервис для генерации отчетов лучше всего использовать докер, это сэкономит ресурсы и позволит отвязаться от вендора ОС;
- Nodejs веб-приложение - докер позволит масштабироваться в зависимости от нагрузки;
- Мобильное приложение c версиями для Android и iOS - если об эмуляции то однозначно ВМ, т.к. требуется обработка графики;
- База данных postgresql используемая, как кэш - БД рекомендуется ставить на железо, тем более кэш;
- Шина данных на базе Apache Kafka в зависимости от критичности данных ВМ или докер;
- Очередь для Logstash на базе Redis - докер, так как Redis высокопроизводительная СУБД работающая в оперативной памяти и не требующая для работы хранилища;
- Elastic stack для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana - вполне подойдет и решение на ВМ и в doker ;
- Мониторинг-стек на базе prometheus и grafana - doker с отдельно вынесеной БД prometheus;
- Mongodb, как основное хранилище данных для java-приложения в зависимости от нагрузки на приложение можно использовать ВМ или физический сервер;
- Jenkins-сервер - докер.

## Задача 2
    docker pull ottvladimir/hey_netology:v0.1
## Задача 3
#### Задача выполнялась на https://labs.play-with-docker.com/
Скачиваем образы   

    [node1] (local) root@192.168.0.15 ~
    $ docker pull debian:latest
    latest: Pulling from library/debian
    bd8f6a7501cc: Pull complete 
    Digest: sha256:ba4a437377a0c450ac9bb634c3754a17b1f814ce6fa3157c0dc9eef431b29d1f
    Status: Downloaded newer image for debian:latest
    docker.io/library/debian:latest

Я выбрал centos 7

    [node1] (local) root@192.168.0.15 ~
    $ docker pull centos:7
    7: Pulling from library/centos
    2d473b07cdd5: Pull complete 
    Digest: sha256:0f4ec88e21daf75124b8a9e5ca03c37a5e937e0e108a255d890492430789b60e
    Status: Downloaded newer image for centos:7
    docker.io/library/centos:7

Создал папку на хосте

    [node1] (local) root@192.168.0.15 ~
    $ mkdir info
Запускаю контейнеры с расшареными папками

    [node1] (local) root@192.168.0.15 ~
    $ docker run -dit -v /root/info:/share/info/ --name=centos centos:7 bash
    14620c371d329f5265d4a5b0c55939b3bdbb5f40b129061ce000019d8ffba698
    [node1] (local) root@192.168.0.15 ~
    $ docker run -dit -v /root/info:/share/info/ --name=debian debian:latest bash
    f4c036ddd8f32be3380fc35461c49e79c492da305a3cb14ca140867e53d5458d
  
Захожу в centos, создаю файл:

    $ docker attach centos
    [root@14620c371d32 /]# echo "My test file" >> /share/info/test 

Проверяю файл на хосте. 

    [node1] (local) root@192.168.0.15 ~
    $ ls /root/info/
    test

Создаю новый файл 

    [node1] (local) root@192.168.0.15 ~
    $ vi info/from_host
    
Проверяю файлы на debian

    [node1] (local) root@192.168.0.15 ~
    $ docker attach debian
    root@f4c036ddd8f3:/# ls share/info/
    from_host  test
    root@f4c036ddd8f3:/# cd share/info/
    root@f4c036ddd8f3:/share/info# cat  
    from_host  test       
    root@f4c036ddd8f3:/share/info# cat test 
    My test file
    root@f4c036ddd8f3:/share/info# cat from_host 
    my test file from host
