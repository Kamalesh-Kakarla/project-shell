echo -e "\e[36m <<<<<<<<<< creating a catalogue service file >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< creating mongodb repo >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< Installing rpms from internet >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< installing nodejs >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
yum install nodejs -y &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< adding robo shop user >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
useradd roboshop &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< removing app directory >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
rm -rf /app &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< creating app directory >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
mkdir /app &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< creating a zip file >>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< changing to app directory >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
cd /app &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< unzip the catalogue file >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
unzip /tmp/catalogue.zip &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< changing to app directory >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
cd /app &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< npms installing >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
npm install &>>/tmp/catalogue.log
echo -e "\e[36m <<<<<<<<<< installing the mongodb org >>>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
yum install mongodb-org-shell -y &>>/tmp/catalogue.log
mongo --host mongodb.kkakarla.online </app/schema/catalogue.js &>>/tmp/catalogue.log

echo -e "\e[36m <<<<<<<<<< restarting the services >>>>>>>>>>\e[0m" | tee -a /tmp/catalogue.log
systemctl daemon-reload
systemctl enable catalogue 
systemctl restart catalogue

