#!/bin/bash
# Bastion Host 초기 설정 스크립트

sudo apt-get update -y
sudo apt-get upgrade -y

sudo systemctl disable --now ufw || true

# SSH Banner 설정
echo "Welcome to the Bastion Host!" | sudo tee /etc/motd

# 타임존 설정
sudo timedatectl set-timezone Asia/Seoul

echo "Bastion setup complete!" 
