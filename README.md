# Terraform / Ansible IAC Reelfiyat.com

reelfiyat.com uygulamamın AWS üzerindeki tüm altyapısını (Network, Security, Compute, Registry) yönetmek için kullanılan Terraform ve Ansible kodlarını içerir. Terraform ile resourceları oluşturup, ansible ile sunucu yapılandırmalarını yaptım. Projenin amacı; bu yazılımın geliştirilme anından, internete çıkışına kadar olan tüm sürecin, yazılan kodun veya güncellenen bölümlerinin konteynır haline getirilmesi, ECR'a pushlanması, CI/CD akışı doğrultusunda deploylanması ile güvenli ve ölçeklenebilir bir otomasyona bağlamaktır.

## 🛠 Kullanılan Teknolojiler

- **Cloud Provider:** AWS 
- **IaC Tool:** Terraform
- **Config Management:** Ansible
- **Containerization:** Docker
- **State Management:** S3 (Backend) & DynamoDB 

### Proje Akış Diyagramı

graph TD
    subgraph "1. Altyapı Deposu (reelfiyat-iac)"
        A[Terraform Kodları .tf] --> B[Ansible Playbook .yml]
    end

    subgraph "GitHub Actions (IaC & Config)"
        B --> C{Terraform Apply}
        C -->|Provision| D[AWS Infrastructure]
    end

    subgraph "AWS Cloud (eu-central-1)"
        D --> D1[VPC & Networking]
        D --> D2[ECR Repository: reelfiyat-app]
        D --> D3[EC2 Instance]
        D --> D4[Elastic IP: 63.181.181.179]
        D --> D5[IAM Role: ECR-Read-Only]
        
        D3 -.->|Attached| D5
        D3 -.->|Static IP| D4
    end

    subgraph "2. Uygulama Deposu (reelfiyat-app)"
        E[Next.js App Code] --> F[Dockerfile]
    end

    subgraph "GitHub Actions (CI/CD Workflow)"
        F --> G[Build & Tag Image]
        G --> H[Login to ECR]
        H --> I[Push Image to ECR]
        I --> J[SSH to EC2]
    end

    J -->|Run Commands| K[EC2 Server Execution]
    
    subgraph "EC2 Server (Docker Runtime)"
        K --> K1[aws ecr login]
        K1 --> K2[docker pull new image]
        K2 --> K3[docker stop/rm old container]
        K3 --> K4[docker run -p 80:3000]
    end

    K4 --> L((LIVE WEBSITE))

    %% Stil Tanımlamaları
    style D fill:#f96,stroke:#333,stroke-width:2px
    style L fill:#00ff00,stroke:#333,stroke-width:4px
    style J fill:#3498db,stroke:#fff,stroke-width:2px



## 📂 Proje Yapısı

```text
reelfiyat-iac/
├── terraform/          # Altyapı kaynak tanımları
│   ├── main.tf         # VPC, EC2, ECR, IAM ve Security Groups
│   ├── variables.tf    # Değişkenler
│   ├── outputs.tf      # IP ve URL çıktıları
│   └── providers.tf    # AWS ve S3 Backend yapılandırması
└── ansible/            # Sunucu konfigürasyon dosyaları
    ├── inventory.ini   # Sunucu erişim bilgileri (IP ve SSH Key yolu)
    └── playbook.yml    # Sunucu içinde Docker kurulumu ve yetkilendirme adımları


