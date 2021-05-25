# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательные задания

1. Есть скрипт:
   
        #!/usr/bin/env python3
        a = 1
        b = '2'
        c = a + b
Какое значение будет присвоено переменной c?
Cancel changes
Будет ошибка, т.к. складываются переменные разных типов.
Как получить для переменной c значение 12?

	c = str(a) + b
Как получить для переменной c значение 3?

	c = a + int(b)

2. Из скрипта убрал break, в выводе подправил путь через os.getcwd()
	```python
   	#!/usr/bin/env python3

	import os

	bash_command = ["cd ~/sysadm-homeworks", "git status"]
	result_os = os.popen(' && '.join(bash_command)).read()
	is_change = False
	for result in result_os.split('\n'):
	    if result.find('modified') != -1:
		prepare_result = os.getcwd()+ '/' +result.replace('#\tmodified:   ', '')
		print(prepare_result)

	```

3. Доработка
	
	```python
	#!/usr/bin/env python3
	import os, sys
	
	#path = sys.argv[1]
	path = input("input git path:")
	bash_command = ["cd ", path, " && ", "git status"]
	path_check = path+".git"
	if os.path.exists(path_check) == 1:
	  result_os = os.popen(''.join(bash_command)).read()
	  for result in result_os.split('\n'):
	    if result.find('modified') != -1:
	      prepare_result = os.getcwd()+ '/' +result.replace('#\tmodified:   ', '')
	      print(path+prepare_result)
	else:
	  print(f"Path: {path} not git repo"
	```
4. Проверка сервисов

	```python
	#!/usr/bin/env python3

	import socket, time

	URL1 = 'google.com'
	URL2 = 'mail.google.com'
	URL3 = 'drive.google.com'

	def check_ip():
	  return {URL1: socket.gethostbyname(URL1), URL2: socket.gethostbyname(URL2), URL3: socket.gethostbyname(URL3)}

	address = check_ip()

	while True:
	  for url in address:
	    print(f'{url} - {address[url]}')
	  new_address = check_ip()
	  for new_url in address:
	    if new_address[new_url] != address[new_url]:
	      print(f'[ERROR] {new_url} IP mismatch: {address[new_url]} {new_address[new_url]}')
	  time.sleep(10)
	```

