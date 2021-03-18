1. Есть скрипт:
   
        #!/usr/bin/env python3
        a = 1
        b = '2'
        c = a + b

    Какое значение будет присвоено переменной c?

Будет ошибка, т.к. складываются переменные разных типов.

    Как получить для переменной c значение 12?

c = str(a) + b

    Как получить для переменной c значение 3?

c = a + int(b)

2. Этим скриптом недовольно начальство, потому что в его выводе не хватает изменённых файлов и не понятно, в какой директории они находятся.

Если я правильно понял задание - я добавил туда вот что: os.getcwd() + '/' + Поправил - убрал break (а зачем он там был? ;))

    vagrant@vagrant:~/devops-netology$ cat changed.py
    #!/usr/bin/env python3
    import os
    bash_command = ["cd ~/devops-netology", "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = os.getcwd() + '/' + result.replace('\tmodified:   ', '')
            print(prepare_result)

3. Доработать скрипт выше так, чтобы он мог проверять локальный репозиторий в директории, которую мы передаём, как входной параметр.

Я немного поменял скрипт, убрал 2-й вызов subprocess, однако не очень понимаю, как я могу вывод git'а интерпретировать. В смысле в случае если он запущен не в директории репозитория, он пишет ошибку в stderr, а os.popen вроде как это не умеет - поэтому всё равно subprocess.run надо использовать... Как я понял ;) Про is_change = False - я обдумался, но не придумал куда и для чего его можно засунуть.. :( Есть ощущение, что я чего-то просто не знаю, поэтому не понимаю как это можно применить.. ;)

vagrant@vagrant:~/devops-netology$ cat changed2.py
#!/usr/bin/env python3
#just comment to change file

import subprocess
import sys
import os

if len(sys.argv) == 1:
    path = "~/devops-netology"
elif len(sys.argv) > 2:
    print("Ошибка. Слишком много параметров.")
    sys.exit(1)
else:
    path = sys.argv[1]
bash_command = ["cd " + path, "git status"]
result_os = subprocess.run(' && '.join(bash_command), shell=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
if result_os.returncode != 0:
    print("Этот каталог не является каталогом git")
    sys.exit(2)
is_change = False
for result in result_os.stdout.split('\n'):
    if result.find('modified') != -1:
        prepare_result = os.getcwd() + '/' + result.replace('\tmodified:   ', '')
        print(prepare_result)
        

Ещё сделал только используя модуль os, без subprocess, но мне так не нравится - если будет файл с названием fatal или что-то такое - будет косяк.. ;)

import sys
import os

if len(sys.argv) == 1:
    path = "~/devops-netology"
elif len(sys.argv) > 2:
    print("Ошибка. Слишком много параметров.")
    sys.exit(1)
else:
    path = sys.argv[1]
bash_command = ["cd " + path, "git status 2>&1"]
result_os = os.popen(' && '.join(bash_command)).read()
if result_os.find('fatal') != -1:
    print("Этот каталог не является каталогом git")
    sys.exit(2)
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = os.getcwd() + '/' + result.replace('\tmodified:   ', '')
        print(prepare_result)

4. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>.

Я сделал скрипт как сервис - мониторит постоянно и при изменении адреса пишет об этом. Если нужно чтобы запускалось единоразово - примерно понимаю как (хранить в файловой системе) - интересно будет сделать!

Это попробую сделать во время выполнения следующего задания - как раз там буду хранить текущее состояние в json'е :) Плюс по группам адресов - я думал выпендриться через socket.gethostbyname_ex знаю про set'ы и про их сравнение (немного пробовал играться), просто в примере было написано про то, что всего 1 IP-адрес у хоста - я и не стал об этом думать.. :) Попробую если время останется после более сложных историй (тут я хотя бы понимаю как делать - вопрос времени) Единственное только не понял, как сделать демонизацию, и/или что под этим подразумевается ;)

import socket
hosts_list = ('drive.google.com', 'mail.google.com', 'google.com')
ip_database = {}
ip_database_prev = {}
for host in hosts_list:
    ip_database_prev[host]=socket.gethostbyname(host)
    print(f'{host} - {ip_database_prev[host]}') # Выводим исходные данные с первого запроса
while True:
    for host in hosts_list:
        ip_database[host]=socket.gethostbyname(host)
        if ip_database[host] != ip_database_prev[host]:
            print(f'[ERROR] {host} IP mismatch: {ip_database_prev[host]} {ip_database[host]}')
            print(f'{host} - {ip_database[host]}') # Выводим изменившиеся данные
            ip_database_prev = ip_database

Получилось у меня нечто монстроподобное (основные трудозатраты были на работу с файлами - в случае, если они отсутствуют

import socket
import json
import yaml

hosts_list = ('drive.google.com', 'mail.google.com', 'google.com')
ip_database = {}
ip_database_set = {}
ip_database_prev_j = {}
ip_database_set_prev_j = {}
ip_database_prev_y = {}
ip_database_set_prev_y = {}
is_changed = False

try:
    with open("jsonfile") as file_j: # пробуем прочитать файл
        ip_database_prev_j = json.load(file_j)
        for host in hosts_list: # и преобразовываем значения словаря в set
            ip_database_set_prev_j[host] = set(ip_database_prev_j[host])
# если файл не найден или он не читается как JSON - создаём его и заполняем текущими данными
except (FileNotFoundError, json.decoder.JSONDecodeError):
    for host in hosts_list:
        ip_database_prev_j[host] = socket.gethostbyname_ex(host)[2]
        ip_database_set_prev_j[host] = set(ip_database_prev_j[host])
    with open("jsonfile", "w") as file_j:
        json.dump(ip_database_prev_j, file_j)
    print("Файл с данными JSON пустой или отсутствует - создаём")
    # is_changed = True

try:
    with open("yamlfile") as file_y: # пробуем прочитать файл
        ip_database_prev_y = yaml.safe_load(file_y)
        if ip_database_prev_y:
            for host in hosts_list: # и преобразовываем данные в set
                ip_database_set_prev_y[host] = set(ip_database_prev_y[host])
        else:
            ip_database_prev_y = {}
            for host in hosts_list:
                ip_database_prev_y[host] = socket.gethostbyname_ex(host)[2]
                ip_database_set_prev_y[host] = set(ip_database_prev_y[host])
            with open("yamlfile", "w") as file_y:
                yaml.dump(ip_database_prev_y, file_y)
                print("Файл с данными YAML пустой - наполняем")

# если файл не найден или он не читается как YAML - создаём его и заполняем переменные текущими данными
except (FileNotFoundError):
    for host in hosts_list:
        ip_database_prev_y[host] = socket.gethostbyname_ex(host)[2]
        ip_database_set_prev_y[host] = set(ip_database_prev_y[host])
    with open("yamlfile", "w") as file_y:
        yaml.dump(ip_database_prev_y, file_y)
    # is_changed = True
    print("Файл с данными YAML отсутствует - создаём")

for host in hosts_list:
    ip_database[host] = socket.gethostbyname_ex(host)[2]
    ip_database_set[host] = set(ip_database[host])
    if (ip_database_set[host] == ip_database_set_prev_j[host]) and (ip_database_set[host] == ip_database_set_prev_y[host]):
        pass
    elif ip_database_set[host] == ip_database_set_prev_y[host]:
        print(f'[ERROR] [JSON] {host} IP mismatch: {ip_database_set_prev_j[host]} {ip_database_set[host]}')
        is_changed = True
    elif ip_database_set[host] == ip_database_set_prev_j[host]:
        print(f'[ERROR] [YAML] {host} IP mismatch: {ip_database_set_prev_y[host]} {ip_database_set[host]}')
        is_changed = True
    else:
        print(f'[ERROR] [JSON] {host} IP mismatch: {ip_database_set_prev_j[host]} {ip_database_set[host]}')
        print(f'[ERROR] [YAML] {host} IP mismatch: {ip_database_set_prev_y[host]} {ip_database_set[host]}')
        is_changed = True

if is_changed:
    with open("jsonfile", "w") as file_j:
        json.dump(ip_database, file_j)
    with open("yamlfile", "w") as file_y:
        yaml.dump(ip_database, file_y)

Задача со звёздочкой

Вот что у меня получилось..

#!/usr/bin/env python3

import subprocess
import sys
import requests
import getpass

username = 'Vahhhh'
password = getpass.getpass()

if len(sys.argv) == 2:
    comment = sys.argv[1]
else:
    print("Ошибка. Единственным аргументом при запуске скрипта должен быть комментарий.")
    sys.exit()
    # comment = 'test'  # Это на случай тестирования с PyCharm'а, не из командной строки
bash_command = "git status && git remote -v"
result_os = subprocess.run(bash_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
if result_os.returncode != 0:
    print("Этот каталог не является каталогом git")
    sys.exit()
for result in result_os.stdout.split('\n'):
    if result.find('On branch master') != -1:
        print("Этот скрипт нельзя запускать в master. Его нужно запускать в ветке, которую хотите смёрджить в master")
        sys.exit()
# Узнаём название удалённой ветки
    elif result.find('Your branch is up to date with ') != -1:
        # repository_remote = result[32:-2].split('/')[0]
        branch_remote = result[32:-2].split('/')[1]
# Из настроек remote git'а берём информацию о названии репозитория и имени владельца в строчке, имеющей отношение
# к push github'a. С ssh работать тоже будет - надо только подтюнить - как текст будет написан.
    elif result.find('https://github.com/') != -1 and result.find(' (push)') != -1:
        owner = result.split()[1].split('/')[3]
        repo = result.split()[1].split('/')[4][:-4]
# Создаём url, который будем дёргать
url = 'https://api.github.com/repos/'+ owner + '/' + repo + '/pulls'
payload = {"title": comment, "head": branch_remote, "base": "master"}
r = requests.post(url, json=payload, auth=(username, password))
if r.status_code == 201:
    print(f"Please, visit {r.json()['html_url']} to confirm the pull request")
elif r.status_code == 401:
    print("Ошибка авторизации")
else:
    for i in r.json()['errors']:
        print(f"Произошла ошибка - {i['message']} - исправьте, или перезвоните позже!")

