#!/bin/bash

# 스프링 애플리케이션 설정 스크립트
# Amazon Linux 2에서 java 및 스프링 부트 애플리케이션 실행 환경 설정

yum update -y

# Java 17 설치 (Amazon Corretto)
yum install -y java-17-amazon-corretto

# 애플리케이션 디렉토리 생성
mkdir -p /opt/app
cd /opt/app

# 스프링 부트 애플리케이션 JAR 파일 다운로드 (실제 JAR 파일로 교체 필요)
# wget -O app.jar https://example-repository/app.jar

# 애플리케이션 실행 스크립트 생성
cat > /opt/app/start.sh << 'EOF'
#!/bin/bash
cd /opt/app

# JVM 옵션 설정
JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC"

# 애플리케이션 실행
java $JAVA_OPTS -jar app.jar
EOF

# 실행 권한 부여
chmod +x /opt/app/start.sh

# systemd 서비스 파일 생성
cat > /etc/systemd/system/spring-app.service << 'EOF'
[Unit]
Description=Spring Boot Application
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/app
ExecStart=/opt/app/start.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 서비스 활성화 및 시작
systemctl daemon-reload
systemctl enable spring-app
systemctl start spring-app

echo "Spring Boot application setup completed!"
echo "To check application status: systemctl status spring-app"
