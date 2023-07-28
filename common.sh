log=/tmp/roboshop.log

func_apppreq(){

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

}

func_systemd(){
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}

func_nodejs(){

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

func_apppreq

echo -e "\e[36m <<<<<<<<<< npms installing >>>>>>>>>>\e[0m" | tee -a ${log}
npm install &>>${log}
echo -e "\e[36m <<<<<<<<<< installing the mongodb org >>>>>>>>>>>\e[0m" | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}
mongo --host mongodb.kkakarla.online </app/schema/${component}.js &>>${log}

echo -e "\e[36m <<<<<<<<<< restarting the services >>>>>>>>>>\e[0m" | tee -a ${log}

func_systemd
}

func_java(){

  echo -e "\e[36m <<<<<<<<<< creating service file >>>>>>>>>>\e[0m" | tee -a ${log}
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[36m <<<<<<<<<< Installing Maven and creating user roboshop >>>>>>>>>>\e[0m" | tee -a ${log}
  yum install maven -y &>>${log}
  useradd roboshop &>>${log}

  func_apppreq

  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  echo -e "\e[36m <<<<<<<<<< Installing mysql >>>>>>>>>>\e[0m" | tee -a ${log}
  yum install mysql -y &>>${log}
  mysql -h mysql.kkakarla.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}

  echo -e "\e[36m <<<<<<<<<< restarting the services >>>>>>>>>>\e[0m" | tee -a ${log}

  func_systemd
}

func_python(){

  echo -e "\e[36m <<<<<<<<<< creating a paytm service file >>>>>>>>>>\e[0m" | tee -a ${log}
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[36m <<<<<<<<<< python installation >>>>>>>>>>\e[0m" | tee -a ${log}
  yum install python36 gcc python3-devel -y &>>${log}
  echo -e "\e[36m <<<<<<<<<< removing existing app >>>>>>>>>>\e[0m" | tee -a ${log}
  rm -rf cd /app &>>${log}
  echo -e "\e[36m <<<<<<<<<< adding user and creating app >>>>>>>>>>\e[0m" | tee -a ${log}
  useradd roboshop &>>${log}
  mkdir /app &>>${log}
  echo -e "\e[36m <<<<<<<<<< Installing app code >>>>>>>>>>\e[0m" | tee -a ${log}
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  cd /app &>>${log}
  unzip /tmp/${component}.zip &>>${log}
  cd /app &>>${log}
  pip3.6 install -r requirements.txt &>>${log}
  echo -e "\e[36m <<<<<<<<<< restarting the services >>>>>>>>>>\e[0m" | tee -a ${log}
  func_systemd
  
}