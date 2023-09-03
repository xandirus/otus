# ДЗ №1 "первый терраформ скрипт"

---

### Цель:
реализовать первый терраформ скрипт.  

Описание/Пошаговая инструкция выполнения домашнего задания:

### Необходимо:

реализовать терраформ для разворачивания одной виртуалки в yandex-cloud  
запровиженить nginx с помощью ansible  

---

Выполняю на ubuntu/debian в среде WSL под Windows  
все комманды вводятся из под root пользователя

---

## Установка yandex-cloud CLI, инициализация

1. Устанавливаю yandex-cloud CLI по инструкции https://cloud.yandex.ru/docs/cli/quickstart#install  

1.1 Настройка аутентификации в консоли

```bash

yc init
export YC_TOKEN=$(yc iam create-token)
export TF_VAR_yc_token=$YC_TOKEN

```

2. Устанавливаю Terraform, использую личный vpn по инструкции https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

3. Устанавливаю Ansible, создаю ключ ssh


```bash

apt install ansible
ssh-keygen

```

4. Клонирую файлы из репозитория https://github.com/xandirus/otus/tree/master/dz1

Вношу свои данные в файл variables.tf  

```bash

variable "zone" {
  type = string
  default = "ru-central1-a" # зона доступности

}

variable "cloud_id" {
  type = string
  default = "b1gmrlsb9f70ac226au7" # нужно внести свой id
}

variable "folder_id" {
  type = string
  default = "b1gbso9k07p4sob6ogrd" # нужно внести свой id 
}

variable "image_id" {
  type = string
  default = "fd879gb88170to70d38a" # можно не менять
}

```

5. Инициализирую terraform

```bash

terraform init

```

6. проверяю манифесты на ошибки

```bash

terraform validate

```

7. Просмотр конфигурации 

```bash
terraform plan

```

8. Запускаю деплой

```bash

terraform apply

```

В результате terraform выдаст external_ip, пройдя в браузере по которому увижу работающий nginx "it works!"