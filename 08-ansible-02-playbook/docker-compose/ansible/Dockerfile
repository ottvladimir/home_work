FROM centos:latest

RUN yum install -y python38 openssh-clients svn git https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/s/sshpass-1.06-9.el8.x86_64.rpm
RUN python3 -m pip install ansible
RUN wget -x https://packages.baidu.com/app/jdk-8/jdk-8u271-linux-x64.tar.gz -O /playbook/jdk-8u271-linux-x64.tar.gz
RUN /usr/bin/svn checkout https://github.com/ottvladimir/home_work/trunk/08-ansible-02-playbook/playbook
WORKDIR /playbook
