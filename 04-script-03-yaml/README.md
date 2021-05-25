# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

## Обязательные задания

1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:
	```json
 {
    	"info": {
    		"elements": [{
    				"name": "first",
    				"type": "server",
    				"ip": "71.75.22.44"
    			},
    			{
    				"name": "second",
    				"type": "proxy",
    				"ip": "71.78.22.43"
    			}
    		]
    	}
    }
	```

2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

```python
#!/usr/bin/env python3

import socket, time, json, yaml

URL1 = 'google.com'
URL2 = 'mail.google.com'
URL3 = 'drive.google.com'

def check_ip():
  return {URL1: socket.gethostbyname(URL1), URL2: socket.gethostbyname(URL2), URL3: socket.gethostbyname(URL3)}
def for_file():
  return [{URL1: socket.gethostbyname(URL1)}, {URL2: socket.gethostbyname(URL2)}, {URL3: socket.gethostbyname(URL3)}]

address = check_ip()

while True:
  for url in address:
    print(f'{url} - {address[url]}')
  new_address = check_ip()
  for new_url in address:
    if new_address[new_url] != address[new_url]:
      print(f'[ERROR] {new_url} IP mismatch: {address[new_url]} {new_address[new_url]}')
    file = for_file()
    with open("address.json", "w") as file_json:
      json.dump(file, file_json, indent=2)
    with open("address.yml", "w") as file_yaml:
      yaml.dump(file, file_yaml)
  time.sleep(3)
  ```
