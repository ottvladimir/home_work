# Домашнее задание к занятию "5.4. Практические навыки работы с Docker"
## Задача 2
Dockerfile Ponysay:

FROM archlinux:latest

RUN pacman -Sy --noconfirm ponysay

ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology"]
https://github.com/Owirtifo/homeworks/blob/main/05-virt-04-docker-practical-skills/README.md
https://github.com/loshkarevev/Homeworks
