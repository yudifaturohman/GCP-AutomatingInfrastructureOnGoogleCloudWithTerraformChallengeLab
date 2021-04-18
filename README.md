# QWIKLABS - Google Cloud Platform - Automating Infrastructure on Google Cloud with Terraform: Challenge Lab
Automating Infrastructure on Google Cloud with Terraform: Challenge Lab - QWIKLABS
![1](https://user-images.githubusercontent.com/50742212/115152759-acd64d00-a09c-11eb-99c0-e3b85ff93bd0.JPG)

### Task 1 : Create the configuration files
- Membuat struktur file dan folder terraform menggunakan Cloud Shell dengan cara menjalankan
``` mkdir terraform
cd terraform
touch main.tf variables.tf
mkdir modules
cd modules
mkdir instances
cd instances
touch instances.tf outputs.tf variables.tf
cd ..
mkdir storage
cd storage
touch storage.tf outputs.tf variables.tf
cd ../../
```
- Tambahkan script berikut kedalam file __variables.tf__ dan ubah <PROJECT ID> dengan PROJECT ID anda
```yaml
variable "region" {
 default = "us-central1"
}

variable "zone" {
 default = "us-central1-a"
}

variable "project_id" {
 default = "<PROJECT ID>"
}
```
