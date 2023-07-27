echo -e "\e[36m <<<<<<<<<< creating a catalogue service file >>>>>>>>>>\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< creating mongodb repo >>>>>>>>>>\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< Installing rpms from internet >>>>>>>>>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< installing nodejs >>>>>>>>>>\e[0m"
yum install nodejs -y &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< adding robo shop user >>>>>>>>>>\e[0m"
useradd roboshop &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< removing app directory >>>>>>>>>>\e[0m"
rm -rf /app &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< creating app directory >>>>>>>>>>\e[0m"
mkdir /app &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< creating a zip file >>>>>>>>>\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< changing to app directory >>>>>>>>>>\e[0m"
cd /app &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< unzip the catalogue file >>>>>>>>>>\e[0m"
unzip /tmp/catalogue.zip &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< changing to app directory >>>>>>>>>>\e[0m"
cd /app &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< npms installing >>>>>>>>>>\e[0m"
npm install &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< installing the mongodb org >>>>>>>>>>>\e[0m"
yum install mongodb-org-shell -y &>>/tmp/catalogue.log
mongo --host mongodb.kkakarla.online </app/schema/catalogue.js &>>/tmp/catalogue.log

echo -e "\e[36m <<<<<<<<<< restarting the services >>>>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable catalogue 
systemctl restart catalogue

