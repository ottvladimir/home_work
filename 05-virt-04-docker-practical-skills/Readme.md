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
    
## Задача 2
Dockerfile Ponysay:

FROM archlinux:latest

RUN pacman -Sy --noconfirm ponysay

ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology"]
https://github.com/Owirtifo/homeworks/blob/main/05-virt-04-docker-practical-skills/README.md
https://github.com/loshkarevev/Homeworks
