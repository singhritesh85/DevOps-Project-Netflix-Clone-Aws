#!/bin/bash
/usr/sbin/useradd -s /bin/bash -m ritesh;
mkdir /home/ritesh/.ssh;
chmod -R 700 /home/ritesh;
echo "ssh-rsa XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ritesh@DESKTOP-0XXXXXX" >> /home/ritesh/.ssh/authorized_keys;
chmod 600 /home/ritesh/.ssh/authorized_keys;
chown ritesh:ritesh /home/ritesh/.ssh -R;
echo "ritesh  ALL=(ALL)  NOPASSWD:ALL" > /etc/sudoers.d/ritesh;
chmod 440 /etc/sudoers.d/ritesh;

#################################### Installing Promtail #####################################

#useradd --system promtail
cd /opt && wget https://github.com/grafana/loki/releases/download/v3.2.1/promtail-linux-amd64.zip
unzip promtail-linux-amd64.zip
rm -f promtail-linux-amd64.zip
cd /opt && wget https://raw.githubusercontent.com/grafana/loki/main/clients/cmd/promtail/promtail-local-config.yaml

cat > /etc/systemd/system/promtail.service <<EOT
[Unit]
Description=Promtail service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/opt/promtail-linux-amd64 -config.file=/opt/promtail-local-config.yaml

[Install]
WantedBy=multi-user.target
EOT

systemctl enable promtail
systemctl start promtail

#################################### Install Postgresql14 ##########################################

amazon-linux-extras install -y postgresql14

cat > /opt/sonarqube.sql <<EODF
create database sonarqubedb;
create user sonarqube with encrypted password 'Cloud#436';
grant all privileges on database sonarqubedb to sonarqube;
EODF


#################################### Installation of SonarQube Server ##############################################

useradd -s /bin/bash -m sonar;
echo "Password@#795" | passwd sonar --stdin;
echo "sonar  ALL=(ALL)  NOPASSWD:ALL" >> /etc/sudoers

cat >> /etc/sysctl.conf <<EOT
vm.max_map_count = 262144
fs.file-max = 65536
EOT

cat >> /etc/security/limits.conf <<EOF
sonar   -   nofile   65536

#Nofile is the maximum number of open files
EOF

sysctl -p
yum install -y java-17* git
cd /opt/ && wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.5.90363.zip
unzip sonarqube-9.9.5.90363.zip
mv /opt/sonarqube-9.9.5.90363 /opt/sonarqube
chown -R sonar:sonar /opt/sonarqube

cat > /etc/systemd/system/sonarqube.service <<END_OF_SCRIPT
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
User=sonar
Group=sonar
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
Restart=always

[Install]
WantedBy=multi-user.target
END_OF_SCRIPT

systemctl enable sonarqube
systemctl start sonarqube
systemctl status sonarqube

#################################### Installing Node Exporter #####################################

useradd --system --no-create-home --shell /bin/false node_exporter
cd /opt/ && wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz
sudo mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter*

cat > /etc/systemd/system/node_exporter.service <<END_FOR_SCRIPT
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter --collector.logind

[Install]
WantedBy=multi-user.target
END_FOR_SCRIPT

systemctl enable node_exporter
systemctl start node_exporter

##################################### Installation of Plugin to Monitor SonarQube using Prometheus ####################################################

cd /opt/sonarqube/extensions/plugins && wget https://github.com/dmeiners88/sonarqube-prometheus-exporter/releases/download/v1.0.0-SNAPSHOT-2018-07-04/sonar-prometheus-exporter-1.0.0-SNAPSHOT.jar

systemctl restart sonarqube
systemctl status sonarqube
