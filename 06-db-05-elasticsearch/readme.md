# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.
  
  
    $ docker exec -it elasticsearch bash
    [root@50ae47dd1fc7 elasticsearch]# curl -X GET 'localhost:9200/'
    {
      "name" : "50ae47dd1fc7",
      "cluster_name" : "docker-cluster",
      "cluster_uuid" : "BmlovxwmQuKROMniFV3Waw",
      "version" : {
        "number" : "7.12.1",
        "build_flavor" : "default",
        "build_type" : "docker",
        "build_hash" : "3186837139b9c6b6d23c3200870651f10d3343b7",
        "build_date" : "2021-04-20T20:56:39.040728659Z",
        "build_snapshot" : false,
        "lucene_version" : "8.8.0",
        "minimum_wire_compatibility_version" : "6.8.0",
        "minimum_index_compatibility_version" : "6.0.0-beta1"
      },
      "tagline" : "You Know, for Search"
    }
## Задача 2
Cоздаем индексы
   
    curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
    curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
    curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'

    [elasticsearch@50ae47dd1fc7 ~]$ curl -X GET 'http://localhost:9200/_cat/indices?v' 
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   ind-1 SXTTj9FOSCKPvvhNjUMS-g   1   0          0            0       208b           208b
    yellow open   ind-3 lFLyVqRATde6Q9dqFCp7Nw   4   2          0            0       832b           832b
    yellow open   ind-2 ig-aaLfeTeWyKtO6c5ZjpQ   2   1          0            0       416b           416b


    [elasticsearch@50ae47dd1fc7 ~]$ curl -XGET 'http://localhost:9200/_cluster/health'
    {
    "cluster_name":"docker-cluster",
    "status":"yellow",
    "timed_out":false,
    "number_of_nodes":1,
    "number_of_data_nodes":1,
    "active_primary_shards":7,
    "active_shards":7,
    "relocating_shards":0,
    "initializing_shards":0,
    "unassigned_shards":10,
    "delayed_unassigned_shards":0,
    "number_of_pending_tasks":0,
    "number_of_in_flight_fetch":0,
    "task_max_waiting_in_queue_millis":0,
    "active_shards_percent_as_number":41.17647058823529
    }

Часть индексов и кластер находится в состоянии yellow, потому что при создании индексов мы указали не нулевые реплики, а по факту сервер в кластере один и реплицировать некуда.


## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

    [root@50ae47dd1fc7 elasticsearch]# curl -X PUT localhost:9200/_snapshot/netology_backup -H 'Content-Type: application/json' -d'{"type": "fs", "settings": {         "location":"/usr/share/elasticsearch/snapshots" }}'
    
    
Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
**данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.**

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`
