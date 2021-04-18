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
- Tambahkan script berikut ke dalam file __main.tf__
``` yaml 
 terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.55.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

module "instances" {
  source     = "./modules/instances"
}
```
Jalankan <code>terraform init</code> di Cloud Shell dalam folder root terraform yang tadi sudah kita buat

### Task 2 : Import infrastructure
Silahkan buka file __modules/instances/instances.tf__ lalu tambahkan script di bawah ini
``` yaml
resource "google_compute_instance" "tf-instance-1" {
  name         = "tf-instance-1"
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
 network = "default"
  }
}

resource "google_compute_instance" "tf-instance-2" {
  name         = "tf-instance-2"
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
 network = "default"
  }
}
```
Untuk __Instance ke-1__
Selanjutnya buka navigasi menu ke __Compute Engine > VM Instances__ klik __tf-instance-1__ copy Instance ID yang berada di bawah scroll sedikit. Lalu jalankan perintah berikut ini dengan Cloud Shell untuk melakukan import, ganti __<INSTANCE-ID>__ dengan Instance ID tadi
 ``` yaml
 terraform import module.instances.google_compute_instance.tf-instance-1 <INSTANCE-ID>
 ```
Untuk __Instance ke-2__
Selanjutnya buka navigasi menu ke __Compute Engine > VM Instances__ klik __tf-instance-2__ copy Instance ID yang berada di bawah scroll sedikit. Lalu jalankan perintah berikut ini dengan Cloud Shell untuk melakukan import, ganti __<INSTANCE-ID>__ dengan Instance ID tadi
 ``` yaml
 terraform import module.instances.google_compute_instance.tf-instance-2 <INSTANCE-ID>
 ```
Kedua contoh tersebut sekarang telah diimpor ke konfigurasi terraform Anda. Anda sekarang dapat secara opsional menjalankan perintah untuk memperbarui status Terraform. Ketik <code>yes</code> pada dialog setelah Anda menjalankan perintah agar perubahan status dapat diterima.
 ``` yaml
 terraform plan
 terraform apply
 ```
