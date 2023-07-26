cp shipping.service /etc/systemd/system/shipping.service

yum install maven -y
useradd roboshop
mkdir /app 
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip 
cd /app 
unzip /tmp/shipping.zip

yum install mysql -y 
mysql -h mysql.kkakarla.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

systemctl daemon-reload
systemctl enable shipping 
systemctl restart shipping
