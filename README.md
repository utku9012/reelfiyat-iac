# Terraform / Ansible IAC Reelfiyat.com

reelfiyat.com uygulamamın AWS üzerindeki tüm altyapısını (Network, Security, Compute, Registry) yönetmek için kullanılan Terraform ve Ansible kodlarını içerir. Terraform ile resourceları oluşturup, ansible ile sunucu yapılandırmalarını yaptım. Projenin amacı; bu yazılımın geliştirilme anından, internete çıkışına kadar olan tüm sürecin, yazılan kodun veya güncellenen bölümlerinin konteynır haline getirilmesi, ECR'a pushlanması, CI/CD akışı doğrultusunda deploylanması ile güvenli ve ölçeklenebilir bir otomasyona bağlamaktır.

## 🛠 Kullanılan Teknolojiler

- **Cloud Provider:** AWS 
- **IaC Tool:** Terraform
- **Config Management:** Ansible
- **Containerization:** Docker
- **State Management:** S3 (Backend) & DynamoDB 

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
