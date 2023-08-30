resource "local_file" "hosts_cfg" {
  content = templatefile("./ansible.tftpl",
     { 
      webservers = yandex_compute_instance.example 
      databases  = yandex_compute_instance.foreach
      storage    = yandex_compute_instance.storageVM
     }
      )

  filename = "./ansible.tftpl"
}


resource "null_resource" "web_hosts_provision" {
#Ждем создания инстанса
depends_on = [yandex_compute_instance.example,yandex_compute_instance.foreach,yandex_compute_instance.storageVM]

#!!!РУЧНОЙ ЗАПУСК АГЕНТА SSH и Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command = "eval `ssh-agent -s`&&cat ~/.ssh/id_rsa | ssh-add -"
  }

#Костыль!!! Даем ВМ 60 сек на первый запуск. Лучше выполнить это через wait_for port 22 на стороне ansible
# В случае использования cloud-init может потребоваться еще больше времени
 provisioner "local-exec" {
    command = "sleep 60"
  }

#Запуск ansible-playbook
  provisioner "local-exec" {                  
    command  = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/hosts.cfg ${abspath(path.module)}/test.yml"
    on_failure = continue #Продолжить выполнение terraform pipeline в случае ошибок
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    #срабатывание триггера при изменении переменных
  }
    triggers = {  
      always_run         = "${timestamp()}" #всегда т.к. дата и время постоянно изменяются
      playbook_src_hash  = file("${abspath(path.module)}/test.yml") # при изменении содержимого playbook файла
      ssh_public_key     = var.public_key # при изменении переменной
    }

}