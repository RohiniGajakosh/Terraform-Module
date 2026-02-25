#!/bin/bash
yum update -y
yum install docker -y
systemctl start docker 
systemctl enable docker
yum install git -y
#install dcoker compose
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) \
-o /usr/local/bin/mongo-compose

chmod +x /usr/local/bin/mongo-compose

#add ec2-user to docker group
usermod -aG docker ec2-user

cd /home/ec2-user

#clone git repo
git clone https://github.com/rohinigajakosh/profile-app.git

cd profile-app

#start docker containers
docker compose up -d  --build 