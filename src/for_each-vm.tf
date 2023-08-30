resource "yandex_compute_instance" "foreach" {
    depends_on = [resource.yandex_compute_instance.example]
    for_each = {
    for index, vm in var.spec_vms :
    vm.name => vm
}

  platform_id = "standard-v1"
  name        = each.value.name

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.size
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true

  }
  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }
}