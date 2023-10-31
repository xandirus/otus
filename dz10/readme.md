# ДЗ №10 "Развертывание виртуальных машин на proxmox с помощью terraform"

---

## VirtualBox

для ДЗ использовался proxmox, запущенный в VirtualBox. VirtualBox для нормальной работы с proxmox нуждается в настройке.

1. В настройках процессора необходимо включить функции вложенной виртуализации (Nested virtualization). 

+ Enable Nested VT-x/AMD-V

2. Что бы виртуалки из proxmox могли получить доступ к логальной сети и интернет, нужно выставить настройки сети в **Network**

+ Bridget adapter
+ Advanced -> Promiscuous mode: Allow All

## Настройка proxmox

1. Создаем роль и юзера, назначаем юзеру роль.

из под рута выполняем в консоли:


``` bash
# Создаем роль
pveum role add terraform_role -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit SDN.Use Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"

# Создаем пользователя
pveum user add terraform_user@pve --password secure1234

# Назначаем роль пользователю
pveum aclmod / -user terraform_user@pve -role terraform_role
```

2. Cкачивание и создание образа cloud-init ubuntu 20.04

Обновляем систему и устанавливаем libguestfs-tools

```bash
ssh root@proxmox-server
sudo apt update -y && sudo apt install libguestfs-tools -y
```

Скачиваем образ

```bash
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
```

Интегрируем qemu guest agent в образ

```bash
virt-customize -a focal-server-cloudimg-amd64.img --install qemu-guest-agent
```



Создаем шаблон cloud-init (template)

```bash
qm create 9005 --name "focal-server-cloudimg-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 9005 focal-server-cloudimg-amd64.img local-lvm
qm set 9005 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9005-disk-0
qm set 9005 --boot c --bootdisk scsi0
qm set 9005 --ide2 local-lvm:cloudinit
qm set 9005 --serial0 socket --vga serial0
qm set 9005 --agent enabled=1
qm template 9005
```

## Настройка terraform

1. Правим файлы манифестов 

**terraform.tfvars**

pm_api_url - адрес api proxmox  
cloudinit_template_name - название образа cloud-init, который развернут на proxmox  
proxmox_node - название ноды proxmox  
ssh_key - вставляем свой публичный ключ

**main.tf**

ipconfig0 = "ip=10.10.10.236/24,gw=10.10.10.1" - меняем на свои  
nameserver = "10.10.10.210" - меняем на свои

disk {
storage = "название хранилища, где лежит образ cloud-init"
}

2. Экспорт переменных окружения для подключения к proxmox

```bash 
export PM_USER="terraform_user@pve"
export PM_PASS="secure1234"
```


3. запуск деплоя

Проверяем

`terraform validate`

`terraform plan`

Если нет ошибок, запукскаем деплой

`terraform init`

4. после создания виртуальной машины, можно подключится к ней по ssh:  
`ssh -i ~/.ssh/id_rsa root@10.10.10.236`