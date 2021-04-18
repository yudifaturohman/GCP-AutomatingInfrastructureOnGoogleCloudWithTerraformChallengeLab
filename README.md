# QWIKLABS - Google Cloud Platform - Automating Infrastructure on Google Cloud with Terraform: Challenge Lab
Automating Infrastructure on Google Cloud with Terraform: Challenge Lab - QWIKLABS
![1](https://user-images.githubusercontent.com/50742212/115152759-acd64d00-a09c-11eb-99c0-e3b85ff93bd0.JPG)

### Task 1 : Create the configuration files
- Membuat struktur file dan folder terraform menggunakan Cloud Shell dengan cara menjalankan perintah berikut 
``` shell 
mkdir terraform
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
- Tambahkan script berikut kedalam file __variables.tf__ dan ubah <PROJECT ID> dengan PROJECT ID GCP anda
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
  zone         = "us-central1-a"

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
  zone         = "us-central1-a"

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
 ``` shell
 terraform import module.instances.google_compute_instance.tf-instance-1 <INSTANCE-ID>
 ```
Untuk __Instance ke-2__
Selanjutnya buka navigasi menu ke __Compute Engine > VM Instances__ klik __tf-instance-2__ copy Instance ID yang berada di bawah scroll sedikit. Lalu jalankan perintah berikut ini dengan Cloud Shell untuk melakukan import, ganti __<INSTANCE-ID>__ dengan Instance ID tadi
 ``` shell
 terraform import module.instances.google_compute_instance.tf-instance-2 <INSTANCE-ID>
 ```
Kedua contoh tersebut sekarang telah diimpor ke konfigurasi terraform Anda. Anda sekarang dapat secara opsional menjalankan perintah untuk memperbarui status Terraform. Ketik <code>yes</code> pada dialog setelah Anda menjalankan perintah agar perubahan status dapat diterima.
 ``` shell
 terraform plan
 terraform apply
 ```
### Task 3 : Configure a remote backend
Tambahkan script berikut ke dalam file __modules/storage/storage.tf__ 
 ``` yaml
 resource "google_storage_bucket" "storage-bucket" {
  name          = "<PROJECT ID>"
  location      = "US"
  force_destroy = true
  uniform_bucket_level_access = true
}
 ```
Selanjutnya silahkan tambahkan script berikut ke dalam file __main.tf__ paste di paling bawah 
 ``` yaml
 module "storage" {
  source     = "./modules/storage"
}
 ```
Selanjutnya jalankan perintah berikut untuk menginisialisasi modul dan membuat resource bucket penyimpanan. Ketik <code>yes</code> pada dialog setelah Anda menjalankan perintah terapkan untuk menerima perubahan status.
 ``` shell
 terraform init
 terraform apply
 ```
Selanjutnya silahkan lakukan replace kode dengan blok script sebagai berikut lalu ubah <PROJECT ID> dengn PROJECT ID GCP anda untuk mendefinisikan bucket
 ``` yaml
 terraform { 
  backend "gcs" { 
    bucket = "<FILL IN PROJECT ID>" 
 prefix = "terraform / state" 
  } 
  required_providers { 
    google = { 
      source = "hashicorp / google" 
      version = "3.55.0" 
    } 
  } 
}
 ```
Jalankan script berikut untuk inisialisasi remote backend. Ketik <yes> jika di minta
 ``` shell
 terraform init
 ```
### Task 4 : Modify and update infrastructure
Silahkan buka file yang berada pada __modules/instances/instance.tf__ lalu lakukan replace semua script dengan script berikut untuk modifikasi instance dan menambahkan instance baru
 ``` yaml
 resource "google_compute_instance" "tf-instance-1" {
  name         = "tf-instance-1"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  allow_stopping_for_update = true

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
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
 network = "default"
  }
}

resource "google_compute_instance" "tf-instance-3" {
  name         = "tf-instance-3"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  allow_stopping_for_update = true

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
Jalankan perintah berikut untuk inisialisasi dan update module di dalam instance. Ketik <code>yes</code> jika di minta
``` shell
terraform init
terraform apply
```
### Task 5 : Taint and destroy resources
Melakukan taint untuk __tf-instance-3__ dengan menjalankan perintah 
``` shell
terraform taint module.instances.google_compute_instance.tf-instance-3
```
Jalankan perintah berikut untuk melakukan perubahan status
``` shell
terraform init
terraform apply
```
Selanjutnya hapus resource untuk __tf-instance-3__. Dengan blok kode sebagai berikut di berada dalam file __modules/instances/instance.tf__
``` yaml
resource "google_compute_instance" "tf-instance-3" {
  name         = "tf-instance-3"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  allow_stopping_for_update = true

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
Jalankan perintah berikut untuk melakukan perubahan status
``` shell
terraform apply
``` 
### Task 6 : Use a module from the Registry
Silahkan tambahkan potongan script berikut ke dalam file __main.tf__ untuk membuat modul VPC. Paste di paling bawah
``` yaml
module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 2.5.0"

    project_id   = var.project_id
    network_name = "terraform-vpc"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-central1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-central1"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "This subnet has a description"
        }
    ]
}
``` 
Jalan perintah berikut untuk melakukan inisialisasi dan membuat modul VPC. Ketika <code>yes</code> jika di minta
``` shell
terraform init
terraform apply
```
Selanjutnya buka file __modules/instances/instances.tf__ lalu ubah semua script dengan script di bawah ini
``` yaml
resource "google_compute_instance" "tf-instance-1" {
  name         = "tf-instance-1"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
 network = "terraform-vpc"
    subnetwork = "subnet-01"
  }
}

resource "google_compute_instance" "tf-instance-2" {
  name         = "tf-instance-2"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
 network = "terraform-vpc"
    subnetwork = "subnet-02"
  }
}
``` 
Jalankan perintah berikut untuk inisialisasi update modul dan instance di dalam VPC. Ketik <code>yes</code> jika di minta
``` shell
terraform init
terraform apply
```
### Task 7 : Configure a firewall
Silahkan tambahkan potongan script berikut ke dalam file __main.tf.__ untuk menambahkan firewall lalu ganti <PROJECT_ID> dengan PROJECT ID GCP anda. Paste di paling bawah 
``` yaml
resource "google_compute_firewall" "tf-firewall" {
  name    = "tf-firewall"
 network = "projects/<PROJECT_ID>/global/networks/terraform-vpc"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]
}
``` 
Jalankan perintah berikut untuk inisialisasi modul. Ketik <code>yes</code> jika di minta
``` shell
terraform init
terraform apply
```

### Selesai
