#!/bin/bash

sudo yum install curl -y

wget https://download/oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz

mkdir -p /home/ec2-use/minecraft
cd /home/ec2-user/minecraft

wget -O server.jar $(wget -qO- https://www.minecraft.net/en-us/download/server | grep -o 'https://launcher.mojang.com/v1/objects/[^\"]*/server.jar' | head -n 1)

echo "eula=true" > eula.txt

sudo tee /etc/systemd/system/minecraft.service > /dev/null <<EOF
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user
ExecStart=/usr/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui
Restart=always
ExecStop=/bin/kill -SIGTERM \$MAINPID

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable minecraft
sudo systemctl start minecraft

echo "Minecraft server done!!!" 
