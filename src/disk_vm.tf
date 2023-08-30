resource "yandex_compute_disk" "empty-disk" {
  count      = 3
  name       = "disk-${count.index}"
  type       = "network-hdd"
  zone       = "ru-central1-a"
  size       = 20
}
resource "yandex_compute_instance" "storageVM" {
  name        = "storage"
  platform_id = "standard-v1"
  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = "network-hdd"
      size = 5
    }   
  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.empty-disk
    content {
      disk_id = secondary_disk.value.id
    }
  }
  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }

  scheduling_policy { preemptible = true }

  network_interface { 
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id] #массив с одной группой безопасности
    nat       = true
  }
  allow_stopping_for_update = true
}