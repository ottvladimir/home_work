# Домашнее задание к занятию "7.1. Инфраструктура как код"

## Задача 1. Выбор инструментов. 
 
### Легенда
 
Через час совещание на котором менеджер расскажет о новом проекте. Начать работу над которым надо 
будет уже сегодня. 
На данный момент известно, что это будет сервис, который ваша компания будет предоставлять внешним заказчикам.
Первое время, скорее всего, будет один внешних клиент, со временем внешних клиентов станет больше.

Так же по разговорам в компании есть вероятность, что техническое задание еще не четкое, что приведет к большому
количеству небольших релизов, тестирований интеграций, откатов, доработок, то есть скучно не будет.  
   
Вам, как девопс инженеру, будет необходимо принять решение об инструментах для организации инфраструктуры.
На данный момент в вашей компании уже используются следующие инструменты: 
- остатки Сloud Formation, 
- некоторые образы сделаны при помощи Packer,
- год назад начали активно использовать Terraform, 
- разработчики привыкли использовать Docker, 
- уже есть большая база Kubernetes конфигураций, 
- для автоматизации процессов используется Teamcity, 
- также есть совсем немного Ansible скриптов, 
- и ряд bash скриптов для упрощения рутинных задач.  

Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:

1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
2. Будет ли центральный сервер для управления инфраструктурой?
3. Будут ли агенты на серверах?
4. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов? 
 
В связи с тем, что проект стартует уже сегодня, в рамках совещания надо будет определиться со всеми этими вопросами.

### В результате получуаем
1. Можно ипользовать гибридную инфраструктуру. Для больших и неповоротливых ВМ, например БД или Файловые Хранилища лучше использовать ВМ или железо, на них придется устанавливать патчи безопасности(как минимум) поэтому их сильно не зашаблонить. Для теста и деплоя - контейнеры.   
Центральный сервер управления сокорее нужен, но, так как управление не сильно ресурсоемкий процесс, то его можно развернуть в контейнере, что придаст ему мобильности.  
Если наша инфраструктура не предполагает Windows серверов, то и в агентах необходимости нет. Многие вопросы решатся Terraform + Ansible. Если же Windows в проекте необходим можно добавить в инструментарий puppet или что-то подобное, тогда понадобится .  
В любом случае средства для управления конфигурацией и инициализации ресурсов необходимы, иначе на любой , даже самый крохотный проект будет затрачено неоправданно много человек/часов. И, наверное, для тестирования и деплоя отребуется что-то вроде jenkins.

Если для ответа на эти вопросы недостаточно информации, то напишите какие моменты уточните на совещании.
 На совещании я бы уточнил какие ОС и БД будут использоваться.

## Задача 2. Установка терраформ. 

Устанавливаю на fedora32

    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
        
    [root@MyFedora /]# terraform --version
    Terraform v0.15.4
    on linux_amd64
    
## Задача 3. Поддержка легаси кода. 
    [root@MyFedora /]# terraform --version
    Terraform v0.15.4
    on linux_amd64
    [root@MyFedora /]# /terraform14/terraform14 -version
    Terraform v0.14.11

    Your version of Terraform is out of date! The latest version
    is 0.15.4. You can update by downloading from https://www.terraform.io/downloads.html
