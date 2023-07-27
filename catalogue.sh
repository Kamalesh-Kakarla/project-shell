echo -e "\e[36m <<<<<<<<<< creating a catalogue service file >>>>>>>>>>\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service
echo -e "\e[36m <<<<<<<<<< creating mongodb repo >>>>>>>>>>\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m <<<<<<<<<< Installing rpms from internet >>>>>>>>>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[36m <<<<<<<<<< installing nodejs >>>>>>>>>>\e[0m"
yum install nodejs -yecho -e "\e[36m <<<<<<<<<< >>>>>>>>>>\e[0m"
echo -e "\e[36m <<<<<<<<<< adding robo shop user >>>>>>>>>>\e[0m"
useradd roboshop
echo -e "\e[36m <<<<<<<<<< creating app directory >>>>>>>>>>\e[0m"
mkdir /app
echo -e "\e[36m <<<<<<<<<< creating a zip file >>>>>>>>>\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo -e "\e[36m <<<<<<<<<< changing to app directory >>>>>>>>>>\e[0m"
cd /app
echo -e "\e[36m <<<<<<<<<< unzip the catalogue file >>>>>>>>>>\e[0m"
unzip /tmp/catalogue.zip
echo -e "\e[36m <<<<<<<<<< changing to app directory >>>>>>>>>>\e[0m"
cd /app
echo -e "\e[36m <<<<<<<<<< npms installing >>>>>>>>>>\e[0m"
npm install 
echo -e "\e[36m <<<<<<<<<< installing the mongodb org >>>>>>>>>>>\e[0m"
yum install mongodb-org-shell -y
mongo --host mongodb.kkakarla.online </app/schema/catalogue.js

echo -e "\e[36m <<<<<<<<<< restarting the services >>>>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable catalogue 
systemctl restart catalogue

