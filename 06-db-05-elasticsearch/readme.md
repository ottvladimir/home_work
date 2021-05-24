# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

Файл `elasticsearch.yml`(https://github.com/ottvladimir/home_work/edit/master/06-db-05-elasticsearch/elasticsearch.yml)

Dockerfile 

    FROM centos:7
    RUN yum install -y wget perl-Digest-SHA
    RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.12.1-linux-x86_64.tar.gz &&\
      wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.12.1-linux-x86_64.tar.gz.sha512 &&\
      shasum -a 512 -c elasticsearch-7.12.1-linux-x86_64.tar.gz.sha512 &&\
      tar -xzf elasticsearch-7.12.1-linux-x86_64.tar.gz
    RUN rm elasticsearch-7.12.1-*
    ADD elasticsearch.yml /elasticsearch-7.12.1/config/elasticsearch.yml
    RUN groupadd elasticsearch && useradd -g elasticsearch elasticsearch
    RUN chown -hR elasticsearch elasticsearch-7.12.1 && \
        mkdir /var/log/elasticsearch && chown -hR elasticsearch /var/log/elasticsearch &&\
        mkdir /var/lib/elasticsearch && chown -hR elasticsearch /var/lib/elasticsearch
    RUN mkdir /elasticsearch-7.12.1/snapshots && chown elasticsearch /elasticsearch-7.12.1/snapshots
    USER elasticsearch     
    CMD ["/elasticsearch-7.12.1/bin/elasticsearch"
  
    $ docker pull ottvladimir/elasticsearch:7
    $ docker run -rm -d -it ottvladimir/elasticsearch:7
    $ docker exec -it ottvladimir/elasticsearch bash
    [root@50ae47dd1fc7 elasticsearch]# curl -X GET 'localhost:9200/'
    {
      "name" : "netology_test",
      "cluster_name" : "elasticsearch",
      "cluster_uuid" : "KqsOVBq1R4m16shEn0j2Bw",
      "version" : {
        "number" : "7.12.1",
        "build_flavor" : "default",
        "build_type" : "tar",
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

Создал директорию средствами docker `/elasticsearch-7.12.1/snapshots`.
Регистрирую данную директорию как `snapshot repository` c именем `netology_backup`.

    $ curl -X PUT localhost:9200/_snapshot/netology_backup -H 'Content-Type: application/json' -d'{"type": "fs", "settings": {"location":"/elasticsearch-7.12.1/snapshots" }}'
    
    $ curl -X GET localhost:9200/_snapshot/netology_backup
    {"netology_backup":{"type":"fs","uuid":"2vCecpFySsWCoEu7z5BrOw","settings":{"location":"/elasticsearch-7.12.1/snapshots"}}}
    
Создаю индекс `test`:

    $ curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
    
    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test   qCQlD--GTd2EHvSSxqSSOA   1   0          0            0       208b           208b

Создаю `snapshot` состояния кластера `elasticsearch`.
      
    $ curl -X localhost:9200/PUT/_snapshot/netology_backup/snapshot_1?wait_for_completion=true

    $ ls /elasticsearch-7.12.1/snapshots/
    index-0  index.latest  indices  meta-ZnFNCrGxTo62gWxudRP1zA.dat  snap-ZnFNCrGxTo62gWxudRP1zA.dat

Удаляю индекс `test` и создаю индекс `test-2`:
    
    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test-2 LIzUtrbZRdSc_TPf8wSI7Q   1   0          0            0       208b           208b
    
Восстанавливаю состояние кластера `elasticsearch` из `snapshot`, созданного ранее. 

    $ curl -X POST 'http://localhost:9200/_snapshot/netology_backup/snapshot_1/_restore'
    $ curl -X GET 'http://localhost:9200/_cat/indices?v'e'
    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test-2 LIzUtrbZRdSc_TPf8wSI7Q   1   0          0            0       208b           208b
    green  open   test   qCQlD--GTd2EHvSSxqSSOA   1   0          0            0       208b           208b
