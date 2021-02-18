2. file
   

           vagrant@vagrant:~$ file /dev/tty
           /dev/tty: character special (5/0)
           vagrant@vagrant:~$ file /bin/ls 
           /bin/ls: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=2f15ad836be3339dec0e2e6a3c637e08e48aacbd, for GNU/Linux 3.2.0, stripped
           vagrant@vagrant:~$ file /proc/$$
           /proc/1613: directory
           vagrant@vagrant:~$ file /proc/$$/fd/2
           /proc/1613/fd/2: symbolic link to /dev/pts/1
strace file /bin/ls 2>&1 | grep open покажет какие фпайлы открываются, среди них/usr/share/misc/magic.mgc и /etc/magic

3. Обнулить файл можно записав в него /dev/null 
   

                cat /dev/null > some_file

4. Зомби-процесс освобождает все свои ресурсы (за исключением PID — идентификатора процесса).


5.


6. uname -a использует системный вызов uname описаный в man uname.2
   
        Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.

7. Последовательность команд через ; выполняется при любом исходе предыдущей команды, через && только если предыдущая команда вернула 0 (логическое И).

8