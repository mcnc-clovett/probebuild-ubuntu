#!/bin/bash

# Add Zscaler SSL certificate for those using SSL decryption
sudo cp ./ZscalerRootCertificate-2048-SHA256.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

# Set the Laptop Lid Switch handle to ignore so that the probe stays awake
sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf

# Install docker using official install script
curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker `whoami`

# Install other supporting applications
yum install -y tcpdump wireshark iperf iperf3 httpd docker-compose mosh
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always \
	-v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

# Allow access to probe tools through the local firewall
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 3000/tcp
sudo ufw allow 3001/tcp
sudo ufw allow 5001
sudo ufw allow 5201
sudo ufw allow enable

# Add iperf service files and enable/start all services
sudo useradd iperf -s /sbin/nologin
sudo cp ./systemd/* /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start iperf
sudo systemctl start iperf3
sudo systemctl enable iperf
sudo systemctl enable iperf3

# Create homepage for web-based tools
sudo cp ./index.html /var/www/html/

# Download and start docker containers
#docker-compose up -d
#docker cp createdevices.sh cacti:/
#docker exec cacti chmod +x /createdevices.sh
