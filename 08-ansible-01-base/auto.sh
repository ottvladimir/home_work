# !/usr/bin/bash
wget https://raw.githubusercontent.com/ottvladimir/home_work/master/08-ansible-01-base/Dockerfile -O Dockerfile && \
docker build . -t svnrun && \
docker volume create myvol && \
ln -s /var/lib/docker/volumes/myvol/_data vol && \
docker run -rm -v=myvol:/data svnrun && \
cd vol/docker_compose && \
docker-compose up -d
