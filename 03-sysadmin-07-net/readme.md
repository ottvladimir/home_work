1. Окно TCP размером 35,76 МБайт нужно чтобы наполнить 1 Гбит/с канал при 300 мс RTT

2. Пропускная способность канала 1000 Мбит/с при 1% потерь пакетов упадет в ~1000 раз.

3. Максимальная реальная скорость передачи данных достижима при линке 100 Мбит/с - 94.9285 Мбит/с

4. При открытии сайта происходит следующее:  
   
Попытка разрезолвить имя сайта в ip-адрес через файл hosts, если в файле соответствия нет, то происходит обращение к локальному DNS. Если и там записи нет, то итеративный запрос отправляется на корневой DNS сервер.  
Root-сервер  выдаст адрес TLD-сервера для .ru. Этот адрес корневой сервер вернёт резолверу. После этого резолвер выполнит итеративный запрос к TLD-серверу. TLD-сервер если и не знает нужный IP-адрес, то он может дать адрес авторитативного DNS-сервера для netology.ru. Авторитативный сервер обращается к A Record и находит там запись IP-адреса для netology.ru,  отправляет ее локальному DNS-серверу который ее кэширует и отдает компьютеру.  
Далее компьютер устанавливает TCP-connection на 80 порт полученного адреса и начинается обмен попротоколу HTTP:  
GET / HTTP/1.1 вернет нам  HTTP/1.1 301 Moved Permanently и перенаправит на https://netology.ru/.

       
      curl -Iv http://netology.ru
      * Rebuilt URL to: http://netology.ru/
      *   Trying 104.22.48.171...
      * TCP_NODELAY set
      * Connected to netology.ru (104.22.48.171) port 80 (#0)
      > HEAD / HTTP/1.1
      > Host: netology.ru
      > User-Agent: curl/7.55.1
      > Accept: */*
      >
      < HTTP/1.1 301 Moved Permanently
      HTTP/1.1 301 Moved Permanently
      < Date: Tue, 06 Apr 2021 03:52:41 GMT
      Date: Tue, 06 Apr 2021 03:52:41 GMT
      < Connection: keep-alive
      Connection: keep-alive
      < Cache-Control: max-age=3600
      Cache-Control: max-age=3600
      < Expires: Tue, 06 Apr 2021 04:52:41 GMT
      Expires: Tue, 06 Apr 2021 04:52:41 GMT
      < Location: https://netology.ru/
      Location: https://netology.ru/
      < cf-request-id: 0946e8b6870000c3f242958000000001
      cf-request-id: 0946e8b6870000c3f242958000000001
      < Server: cloudflare
      Server: cloudflare
      < CF-RAY: 63b8109da880c3f2-LED
      CF-RAY: 63b8109da880c3f2-LED

      <
      * Connection #0 to host netology.ru left intact
    
5. Сколько и каких итеративных запросов будет сделано при резолве домена www.google.co.uk  
 Будет выполнено 13 запросов для определения dns серверов зоны uk, и 8 запросов в зоне uk. Итого 21 итеративный запрос.

   
6. Для назначения хостам адресов в подсети /25 доступно 2^7-2=126 адресов.
В подсети с маской 255.248.0.0 имеем 2^11-2=2046

   
7. В сети с маской /23 больше адресов (2^9-2=510) чем в сети с маской /24(2^8-2=254) 


8. Диапазон 10.0.0.0/8 разделить на 128 подсетей по 131070 адресов в каждой получится. У таких подсетей будет маска /15
