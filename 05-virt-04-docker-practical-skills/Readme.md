# Домашнее задание к занятию "5.4. Практические навыки работы с Docker"
## Задача 1
Ни на последней Ubuntu (нет ppa репозитория), ни на Арче последнем(проблемы с правами на /var/lib/pacman) запустить не удалось. Поэтому проверил на Ubuntu 18.04.  
Dockerfile:

        FROM archlinux:base-20201129.0.10056
        RUN pacman -Sy ponysay --noconfirm && \
            pacman -Sy --noconfirm glibc
        ENTRYPOINT ["/usr/bin/ponysay"]
        CMD ["Hey, netology"]

#Тут будут скриншоты

    docker pull ottvladimir/ponysay_arch
    
## Задача 2 Решение

### Dockerfile Amazoncorretto:

        FROM amazoncorretto:latest

        RUN yum update -y && \
            yum install -y wget && \
            yum install -y java-11-amazon-corretto
        RUN wget https://get.jenkins.io/war-stable/2.277.3/jenkins.war -nv
        RUN yum clean all
        ENTRYPOINT ["/usr/bin/java", "-jar", "jenkins.war"]

        EXPOSE 8080/tcp
        EXPOSE 50000/tcp
        
        docker pull ottvladimir/amazoncorretto:ver1
        
##Здесь будут скриншоты
- Скриншоты логов запущенных вами контейнеров (из командной строки)
- Скриншоты веб-интерфейса Jenkins запущенных вами контейнеров (достаточно 1 скриншота на контейнер)

### Dockerfile Ubuntu:

        FROM ubuntu:latest

        RUN apt-get update && \
            apt-get install -y wget && \
            apt-get install -y openjdk-11-jdk
        RUN wget https://get.jenkins.io/war-stable/2.277.3/jenkins.war -nv
        RUN apt-get clean && rm -rf /var/lib/apt/lists/*
        ENTRYPOINT ["/usr/bin/java", "-jar", "jenkins.war"]

        EXPOSE 8080/tcp
        EXPOSE 50000/tcp
        
        
        docker pull ottvladimir/ubuntu:ver2
##Здесь будут скриншоты
- Скриншоты логов запущенных вами контейнеров (из командной строки)
- Скриншоты веб-интерфейса Jenkins запущенных вами контейнеров (достаточно 1 скриншота на контейнер)

## Задача 3  Решение

Листинг докера

        FROM node
        RUN git clone https://github.com/simplicitesoftware/nodejs-demo.git && \
        cd /nodejs-demo && \
        sed -i "s/localhost/0.0.0.0/g" app.js && \
        npm audit fix && \
        npm install

        WORKDIR /nodejs-demo

        CMD ["npm", "start"]

        EXPOSE 3000

Запускаю
        
        docker build -t ottvladimir/node .
        docker run -d -p 3000:3000 ottvladimir/node

Собираю Ubuntu
        
        FROM ubuntu
        RUN apt-get update && apt-get install -y curl
        docker run -d -it --name=ubuntu ottvladimir/ubuntu_curl
Создаю сеть  

        docker network create node
        $ docker network ls
        NETWORK ID     NAME      DRIVER    SCOPE
        9e2613a466f0   bridge    bridge    local
        5c0d2137cc0d   host      host      local
        14841aa6dad4   node      bridge    local
        64a62d1df4c1   none      null      local

Проверяем сеть 

        $ docker network inspect node
        [
            {
                "Name": "node",
                "Id": "14841aa6dad41006656a1b9e293b0f87281a500a4deca82ce0a00dbd856c5112",
                "Created": "2021-05-16T23:12:49.287589787Z",
                "Scope": "local",
                "Driver": "bridge",
                "EnableIPv6": false,
                "IPAM": {
                    "Driver": "default",
                    "Options": {},
                    "Config": [
                        {
                            "Subnet": "172.19.0.0/16",
                            "Gateway": "172.19.0.1"
                        }
                    ]
                },
                "Internal": false,
                "Attachable": false,
                "Ingress": false,
                "ConfigFrom": {
                    "Network": ""
                },
                "ConfigOnly": false,
                "Containers": {
                    "0d7558b3ea76962ed76a617998a7857f586d88687d8c7367e3688ad666ec17ce": {
                        "Name": "competent_saha",
                        "EndpointID": "c3c4abc51d3deba755eeac34f761781ac8c34990249611601bb4bc6ef78aee7e",
                        "MacAddress": "02:42:ac:13:00:03",
                        "IPv4Address": "172.19.0.3/16",
                        "IPv6Address": ""
                    },
                    "5e6a656140f7444d2e7bd7cd27ef6440c9ce1714f6bface6a5a97e6e10662653": {
                        "Name": "demo_node",
                        "EndpointID": "cbb22fa4a7d25b11a0c82b2e1bd23b7eddeeda6a5e90098dc118ac57220821c5",
                        "MacAddress": "02:42:ac:13:00:02",
                        "IPv4Address": "172.19.0.2/16",
                        "IPv6Address": ""
                    }
                },
                "Options": {},
                "Labels": {}
            }
        ]
        
        
Результат curl

       $ docker exec -it ubuntu curl -I demo_node:3000
        HTTP/1.1 200 OK
        Cache-Control: private, no-cache, no-store, no-transform, must-revalidate
        Expires: -1
        Pragma: no-cache
        Content-Type: text/html; charset=utf-8
        Content-Length: 524946
        ETag: W/"80292-QyCAzxdazWNb94dg58BzePehos8"
        Date: Sun, 16 May 2021 23:40:31 GMT
        Connection: keep-alive
        Keep-Alive: timeout=5
