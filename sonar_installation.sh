#!/bin/bash







##STEP 1: Install dependencies: JAVA

sudo apt update -y
sudo apt install openjdk-17-jdk -y


##  STEP 2: Install database dependencies: PostgreSQL

sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update -y
sudo apt-get -y install postgresql

sudo systemctl start postgresql
sudo systemctl enable postgresql


#  — CONFIGURE
 
 '''
sudo passwd postgres

   # switch to postgres user from your cli

su - postgres

   # this will enable your create a sonar user for the database

createuser sonar

   # login to the postgresql database dashboard

psql 

    # copy this lines of codes one after the other

ALTER USER sonar WITH ENCRYPTED password 'set_your_password';
#set password for sonar user

CREATE DATABASE sonarqube OWNER sonar;
#create db

GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;
#grant privleges

  #  once we are done we will quit the postgresql dashboard

\q

'''

# STEP 3: Install and Configure SonarQube

sudo apt update -y
sudo apt install wget unzip -y

sudo cd /opt/
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.5.1.90531.zip
sudo unzip sonarqube-10.5.1.90531.zip
sudo mv sonarqube-10.5.1.90531 sonarqube
sudo mv sonarqube /opt/




#— USERS & GROUP

sudo useradd sonar
#creates sonar user

sudo usermod -g sonar -d /opt/sonarqube sonar
#assign sonar user to sonar group and the dir

sudo chown sonar:sonar -R /opt/sonarqube
#give recursive ownership of the dir above to sonar user & sonar group


'''
— CONFIGURE

#Haven done that conguration above we can modify and make changes to sonarqube config files

   # navigate to the directory

sudo vim /opt/sonarqube/conf/sonar.properties

   # search for the lines below and uncomment the lines
   # fill in desired value respectively

sonar.jdbc.username=sonar

sonar.jdbc.password=set_your_password
sonar.jdbc.url=jdbc:postgresql://localhost/sonar


   # locate the sonar script file

sudo vim /opt/sonarqube/bin/linux-x86-64/sonar.sh

   # find and uncomment #RUN_AS_USER= and replace as below

RUN_AS_USER=sonar
'''

'''

STEP 4: Setup Systemd Service

   # This configuration allows us to use systemctl with sonarqube, for starting and enabling the service at startup.

sudo vim /etc/systemd/system/sonar.service

   # add the code below to the service file

[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target


'''

sudo systemctl daemon-reload

sudo systemctl start sonar
sudo systemctl enable sonar

'''

STEP 5: Modify Kernel System Limits

   # SonarQube uses Elasticsearch to store its indices in an MMap FS directory. It requires some changes to the system defaults.
   # Edit the sysctl configuration file.

sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
sudo nano /etc/security/limits.conf    --appends
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096

##  Apply the changes:

sudo sysctl -p

STEP 6: Access SonarQube

    #this will be done through the browser, using your server’s public ip idress on port 9000

https://localhost:9000

'''


=====================================================

########### DOCKER ##############

sudo docker run -d --name sonar -p 9003:9000 sonarqube:lts-community   
