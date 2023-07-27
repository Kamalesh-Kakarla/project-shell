log=/tmp/${component}.log
d='date'
echo "The script starts at -" ; $d #| tee -a ${log}
echo -e "\e[36m <<<<<<<<<< creating a ${component} service file >>>>>>>>>>\e[0m" | tee -a ${log}
cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
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
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
echo -e "\e[36m <<<<<<<<<< changing to app directory >>>>>>>>>>\e[0m" | tee -a ${log}
cd /app &>>${log}
echo -e "\e[36m <<<<<<<<<< unzip the ${component} file >>>>>>>>>>\e[0m" | tee -a ${log}
unzip /tmp/${component}.zip &>>${log}
echo -e "\e[36m <<<<<<<<<< changing to app directory >>>>>>>>>>\e[0m" | tee -a ${log}
cd /app &>>${log}
echo -e "\e[36m <<<<<<<<<< npms installing >>>>>>>>>>\e[0m" | tee -a ${log}
npm install &>>${log}
echo -e "\e[36m <<<<<<<<<< installing the mongodb org >>>>>>>>>>>\e[0m" | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}
mongo --host mongodb.kkakarla.online </app/schema/${component}.js &>>${log}

echo -e "\e[36m <<<<<<<<<< restarting the services >>>>>>>>>>\e[0m" | tee -a ${log}
systemctl daemon-reload
systemctl enable ${component} 
systemctl restart ${component}

