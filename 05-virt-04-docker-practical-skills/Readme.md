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


## Задача 3 

В данном задании вы научитесь:
- объединять контейнеры в единую сеть
- исполнять команды "изнутри" контейнера

Для выполнения задания вам нужно:

- Запустить второй контейнер из образа ubuntu:latest 
- Создайть `docker network` и добавьте в нее оба запущенных контейнера
- Используя `docker exec` запустить командную строку контейнера `ubuntu` в интерактивном режиме
- Используя утилиту `curl` вызвать путь `/` контейнера с npm приложением  

Для получения зачета, вам необходимо предоставить:
- Наполнение Dockerfile с npm приложением
- Скриншот вывода вызова команды списка docker сетей (docker network cli)
- Скриншот вызова утилиты curl с успешным ответом
https://github.com/Owirtifo/homeworks/blob/main/05-virt-04-docker-practical-skills/README.md
https://github.com/loshkarevev/Homeworks
