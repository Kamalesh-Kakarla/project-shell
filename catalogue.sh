log=/tmp/catalogue.log

echo -e "\e[36m <<<<<<<<<< creating a catalogue service file >>>>>>>>>>\e[0m" | tee -a ${log}
cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}
echo -e "\e[36m <<<<<<<<<< creating mongodb repo >>>>>>>>>>\e[0m" | tee -a ${log}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
echo -e "\e[36m <<<<<<<<<< Installing rpms from internet >>>>>>>>>>\e[0m" | tee -a ${log}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
echo -e "\e[36m <<<<<<<<<< installing nodejs >>>>>>>>>>\e[0m" | tee -a ${log}
yum install nodejs -y &>>${log}
echo -e "\e[36m <<<<<<<<<< adding robo shop user >>>>>>>>>>\e[0m" | tee -a ${log}
useradd roboshop &>>${log}
echo -e "\e[36m <<<<<<<<<< removing app directory >>>>>>>>>>\e[0m" | tee -a ${log}
rm -rf /app &>>${log}
echo -e "\e[36m <<<<<<<<<< creating app directory >>>>>>>>>>\e[0m" | tee -a ${log}
mkdir /app &>>${log}
echo -e "\e[36m <<<<<<<<<< creating a zip file >>>>>>>>>\e[0m" | tee -a ${log}
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
echo -e "\e[36m <<<<<<<<<< changing to app directory >>>>>>>>>>\e[0m" | tee -a ${log}
cd /app &>>${log}
echo -e "\e[36m <<<<<<<<<< unzip the catalogue file >>>>>>>>>>\e[0m" | tee -a ${log}
unzip /tmp/catalogue.zip &>>${log}
echo -e "\e[36m <<<<<<<<<< changing to app directory >>>>>>>>>>\e[0m" | tee -a ${log}
cd /app &>>${log}
echo -e "\e[36m <<<<<<<<<< npms installing >>>>>>>>>>\e[0m" | tee -a ${log}
npm install &>>${log}
echo -e "\e[36m <<<<<<<<<< installing the mongodb org >>>>>>>>>>>\e[0m" | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}
mongo --host mongodb.kkakarla.online </app/schema/catalogue.js &>>${log}

echo -e "\e[36m <<<<<<<<<< restarting the services >>>>>>>>>>\e[0m" | tee -a ${log}
systemctl daemon-reload
systemctl enable catalogue 
systemctl restart catalogue

