# AWS Infrastructure with Terraform

AWS 인프라를 Terraform으로 관리하는 프로젝트입니다.

## 🏗️ 아키텍처

image.png

## 📁 프로젝트 구조

```
terraform-aws/
├── modules/
│   ├── vpc/                 # VPC 및 서브넷
│   ├── security-groups/     # 보안 그룹
│   ├── alb/                 # Application Load Balancer
│   ├── compute/             # EC2 Auto Scaling Group
│   ├── rds/                 # RDS 데이터베이스
│   ├── bastion/             # Bastion Host
│   ├── s3/                  # S3 버킷 (정적 웹사이트)
│   └── cloudfront/          # CloudFront
├── envs/
│   └── dev/
│       ├── main.tf          # 메인 설정
│       ├── variable.tf      # 변수 정의
│       ├── outputs.tf       # 출력값
│       ├── provider.tf      # 프로바이더 설정
│       ├── terraform.tfvars # 변수 값 파일
│       ├── .terraform.lock.hcl
│       ├── terraform.tfstate
│       ├── terraform.tfstate.backup
│       ├── static/          # 정적 웹사이트 파일
│       │   ├── index.html
│       │   ├── script.js
│       │   └── style.css
│       └── scripts/         # 배포/설정 스크립트
│           ├── bastion_setup.sh
│           └── web_server_setup.sh
└── README.md
```

## 🚀 사용법

### 1. 사전 준비

```bash
# AWS CLI 설정
aws configure

# Terraform 설치 확인
terraform version
```

### 2. 환경 변수 설정

```bash
cd envs/dev

# 데이터베이스 인증 정보 설정
export TF_VAR_db_username="your_db_username"
export TF_VAR_db_password="your_db_password"
```

### 3. 인프라 배포

```bash
# Terraform 초기화
terraform init

# 배포 계획 확인
terraform plan

# 인프라 배포
terraform apply
```

### 4. 정적 웹사이트 배포

정적 웹사이트 파일은 `static/` 폴더에 위치합니다.  

### 5. 접속 정보 확인

```bash
# CloudFront 도메인 확인
terraform output cloudfront_distribution_domain_name

# Bastion 호스트 접속 정보
terraform output bastion_ssh_command
```

## 🧹 정리

```bash
# 인프라 삭제
terraform destroy
```

## 🔗 링크

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) 
