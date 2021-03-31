1 ipvs. 
Если при запросе на VIP сделать подряд несколько запросов (например, for i in {1..50}; do curl -I -s 172.28.128.200>/dev/null; done ), ответы будут получены почти мгновенно. Тем не менее, в выводе ipvsadm -Ln еще некоторое время будут висеть активные InActConn. Почему так происходит?
Tакие службы, как http или ftp-data , закрывают соединения, как только получено обращение / данные. Поэтому мы будим видеть запись в столбце InActConn до тех пор, пока не истечет время ожидания соединения 120 сек.

        vagrant@vagrant:~$ sudo ipvsadm -Ln --timeout
        Timeout (tcp tcpfin udp): 900 120 300

1. Адреса

master

    vagrant@netology1:~$ ip -4 addr show eth0 
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        inet 192.168.1.43/24 brd 192.168.1.255 scope global dynamic eth0
           valid_lft 77450sec preferred_lft 77450sec
    
    root@netology1:/home/vagrant# ipvsadm -Ln
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
      -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    TCP  192.168.1.200:80 rr
      -> 192.168.1.43:80              Route   1      0          0         
      -> 192.168.1.44:80              Route   1      0          0         

    root@netology1:/home/vagrant# ip -4 addr show eth0 | grep inet 
    inet 192.168.1.43/24 brd 192.168.1.255 scope global dynamic eth0
    inet 192.168.1.200/32 scope global eth0:200

slave

    vagrant@netology2:~$ ip -4 addr show eth0 
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        inet 192.168.1.44/24 brd 192.168.1.255 scope global dynamic eth0
           valid_lft 77068sec preferred_lft 77068sec

    sysctl -w net.ipv4.conf.lo.arp_ignore = 1
    sysctl -w net.ipv4.conf.lo.arp_announce = 2
client

    vagrant@netology3:~$ ip -4 addr show eth0 
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        inet 192.168.1.45/24 brd 192.168.1.255 scope global dynamic eth0
           valid_lft 76923sec preferred_lft 76923sec
    
    vagrant@netology3:~$ for i in {1..50} ; do curl -I -s 192.168.1.200>/dev/null; done

balancer 

    root@netology1:/home/vagrant# ipvsadm -Ln --stats
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port               Conns   InPkts  OutPkts  InBytes OutBytes
      -> RemoteAddress:Port
    TCP  192.168.1.200:80                   50      312        0    20224        0
      -> 192.168.1.43:80                    25      138        0     9026        0
      -> 192.168.1.44:80                    25      174        0    11198        0
    root@netology1:/home/vagrant# 

Доступы
    
    root@netology1:/home/vagrant# wc -l /var/log/nginx/access.log
    15 /var/log/nginx/access.log

    vagrant@netology2:~$ wc -l /var/log/nginx/access.log
    37 /var/log/nginx/access.log

kipalived

    vrrp_instance 192.168.1.200 {
    state MASTER
    interface eth1
    virtual_router_id 1
    priority 255
    advert_int 1
    virtual_ipaddress {
    192.168.1.200/32 dev eth1 label eth1:200
    }
    }
    virtual_server 192.168.1.200 80 {
        delay_loop 6
        lvs_sched rr
        lvs_method DR
        protocol TCP
    
        real_server 192.168.1.43 80 {
            weight 50
            TCP_CHECK {
                connect_timeout 3
            }
        }
    
        real_server 192.168.1.44 80 {
            weight 50
            TCP_CHECK {
                connect_timeout 3
            }
        }
    
    }

slave 
    

    vrrp_instance 192.168.1.200 {
    state MASTER
    interface eth1
    virtual_router_id 1
    priority 255
    advert_int 1
    virtual_ipaddress {
    192.168.1.200/32 dev eth1 label eth1:200
    }
    }
    virtual_server 192.168.1.200 80 {
        delay_loop 6
        lvs_sched rr
        lvs_method DR
        protocol TCP
    
        real_server 192.168.1.43 80 {
            weight 50
            TCP_CHECK {
                connect_timeout 3
            }
        }
    
        real_server 192.168.1.44 80 {
            weight 50
            TCP_CHECK {
                connect_timeout 3
            }
        }
    
    }

3. Eсли мы хотим без какой-либо деградации выдерживать потерю 1 из 3 хостов нам понадобится по 3 адреса на ноду.3 экземпляра VRRP, и в каждом по одному VIP адресу.


        vrrp_instance proxy_ip1 {
        state MASTER
        interface eth0
        virtual_router_id 1
        priority 255
        virtual_ipaddress {
        192.168.1.101/32 dev eth0 label eth0:101
            }
        }
        vrrp_instance proxy_ip2 {
        state BACKUP
        interface eth0
        virtual_router_id 2
        priority 200
        virtual_ipaddress {
        192.168.1.102/32 dev eth0 label eth0:102
            }
        }
        vrrp_instance proxy_ip2 {
        state BACKUP
        interface eth0
        virtual_router_id 3
        priority 100
        virtual_ipaddress {
        192.168.1.103/32 dev eth0 label eth0:103
            }
        }

