# Terraform / Ansible IAC Reelfiyat.com

reelfiyat.com uygulamamın AWS üzerindeki tüm altyapısını (Network, Security, Compute, Registry) yönetmek için kullanılan Terraform ve Ansible kodlarını içerir. Terraform ile resourceları oluşturup, ansible ile sunucu yapılandırmalarını yaptım. Projenin amacı; bu yazılımın geliştirilme anından, internete çıkışına kadar olan tüm sürecin, yazılan kodun veya güncellenen bölümlerinin konteynır haline getirilmesi, ECR'a pushlanması, CI/CD akışı doğrultusunda deploylanması ile güvenli ve ölçeklenebilir bir otomasyona bağlamaktır.

## 🛠 Kullanılan Teknolojiler

- **Cloud Provider:** AWS 
- **IaC Tool:** Terraform
- **Config Management:** Ansible
- **Containerization:** Docker
- **State Management:** S3 (Backend) & DynamoDB 

### Proje Akış Diyagramı

```mermaid
graph TD
graph TD
    %% 1. ALTYAPI SÜRECİ
    subgraph Altyapi_Süreci [1. Altyapı - reelfiyat-iac]
        A[Terraform .tf] --> B[Ansible .yml]
        B --> C{Terraform Apply}
    end

    %% 2. AWS KAYNAKLARI
    subgraph AWS_Cloud [2. AWS Cloud - eu-central-1]
        C --> D1[VPC & Network]
        C --> D2[ECR Repo]
        C --> D3[EC2 Instance]
        D3 --- D4[Elastic IP: 63.181.181.179]
        D3 --- D5[IAM Role: ECR-Read-Only]
    end

    %% 3. UYGULAMA SÜRECİ
    subgraph Uygulama_Süreci [3. Uygulama - reelfiyat-app]
        E[Next.js Code] --> F[Dockerfile]
        F --> G[GitHub Actions]
        G --> H[Build & Push to ECR]
    end

    %% 4. DEPLOYMENT
    subgraph Deploy_Asamasi [4. Deployment]
        H --> I[SSH to EC2]
        I --> J[Docker Pull & Run]
        J --> K((LIVE WEBSITE))
    end

    %% RENKLENDİRME
    style C fill:#f39c12,color:#fff
    style G fill:#3498db,color:#fff
    style D3 fill:#e67e22,color:#fff
    style K fill:#27ae60,color:#fff


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


