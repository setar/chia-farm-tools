# Общая информация
Процесс "выращивания" крипто монет CHIA состоит в подготовке "полей" ("плотов" / "plots")  и последующем контроле за готовыми плотами.

Следует разделить процессы:
  * создание плотов (**plotting**) - крайне  высокозатратный процесс требующий значительной процессорной мощности , и высокоскоростной дисковой подсистемы на базе NVMe
  * выращивание монет (**farming**) - очень простой и малозатратный процесс контроля за текущей крипто-цепочкой и поиска решения на готовых плотах.

В общем случае роли можно совместить в рамках одной системы.

На бытовом уровне процесс  получения выигрыша очень похож на классическое лото, в котором на руках игроков находятся карточки (плоты), а система де-централизованно 
(без единого центра управления) сообщает каждому пользователю текущую выигрышную комбинацию.
Первый заявивший о наличии у него выигрышной карты - получает текущий приз.
Чем больше у игрока карточек-полей, тем выше вероятность выигрыша.
Каждый раунд  обычно занимает от 1 до 10 минут (новая комбинация появляется вместе с заявкой на выигрыш в предыдущем раунде)

Более детально обработчик крипто-цепочки состоит их следующих служб:
  * **full-node** :  базовый  сервис осуществляющий коммуникацию между аналогичными узлами в интернете с целью создания децентрализованной сети. Его задачей является создание и поддержание актуальной базы данных крипто-цепочки а так же заявления своих прав оппонентам в случае нахождения выигрыша
  * **wallet** : кошелек , из общей базы данных крипто-цепочки извлекает информацию о транзакциях и балансе одной (или нескольких) пар крипто ключей (пара крипто ключей задается мнемонической фразой). Так же формирует информацию о исходящих транзакциях.
  * **farmer** : процесс на основании знаний о актуальной выигрышной комбинации в крипто-цепочке и с использованием пары крипто ключей формирует запрос к харвестеру для поиска решения, и осуществляет его проверку в случае нахождения
  * **harvester** : процесс осуществляющий поиск на дисках среди плотов согласно запросу от процесса farmer

В задаче оптимизации процесса выращивания, при использовании уже готовых плотов - возможно вынесение ролей full-node,wallet,farmer на централизованный сервер (в том числе виртуальный), 
и использованием лишь роли harvester  на каждом из контролирующих дисковую подсистему серверов.
Аппаратные требования к серверу с такой ролью резко понижаются вплоть до однопроцессорных систем с малым количеством RAM (лишь бы поддерживал доступ к дискам)

# Установка plotting/farming машины 
Используется базовый серверный дистрибутив ubuntu LTS 20.4
Устанавливается штатным образом на любой относительно небольшой носитель >=32GB

## дистрибутив
https://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso
Выбираем желаемый диск под систему, всё по умолчанию.
Из дополнительных опций выбираем лишь OpenSSH Server.
При установке задаем желаемое имя машины а так же рядового пользователя системы
например user / P@ssw0rd

логинимся в систему с консоли или по ssh и переключаемся на рута

### Типовой вход:
* посредством программы Putty стандартно подключаемся по ssh на адрес машины.
* на приглашение имени пользователя user: user, на password:  P@ssw0rd
* повышение привилегий $ sudo -i   # пароль P@ssw0rd

## Сеть:
по умолчанию DHCP, можно пропустить пункт
узнать адрес  

ip a

**если нужна статика:**

nano /etc/netplan/00-installer-config.yaml
крайне чувствителен к пробелам и табуляциям и переносам строки по unix style 
в случае ошибок убрать все промежутки и переносы и задать по новой
```
network: 
  version: 2 
  renderer: NetworkManager
  ethernets:
    ens33:
      dhcp4: no
      addresses: [192.168.148.14/24]
      gateway4: 192.168.148.1
      nameservers:
        addresses: [8.8.8.8]
```

netplan generate

netplan apply

## обновим систему
apt-get update

apt-get upgrade

## установим пакеты которые понадобятся в дальнейшем
sudo apt-get install python3.8-venv python3-distutils python3.8-dev git net-tools mc sysstat atop scsitools dos2unix zsh -y

## разрешим удаленный вход по ssh
cat /etc/ssh/sshd_config |grep PubkeyAuthentication

mcedit /etc/ssh/sshd_config
```
PubkeyAuthentication yes
PermitRootLogin prohibit-password
```

systemctl restart sshd

## создадим пользователя chia  и создадим инфраструктуру для него
adduser chia

usermod -aG sudo chia

mkdir /home/chia/temp

chown chia:chia /home/chia/temp

mkdir /home/chia/farm

chown chia:chia /home/chia/farm

mkdir /home/chia/ram

chown chia:chia /home/chia/ram

mkdir /home/chia/logs

chown chia:chia /home/chia/logs

## создадим RAMDRIVE (для MadMax требуется по 110GB на каждое окно + 140GB на NVMe)
mount -o size=220G -t tmpfs none /home/chia/temp/ 

mcedit /etc/fstab
```
tmpfs		/home/chia/ram	tmpfs	rw,noatime,nosuid,size=220G	0 0
```

mount -a

# удалить снапы из системы
https://www.kevin-custer.com/blog/disabling-snaps-in-ubuntu-20-04/

snap list

snap remove lxd

snap remove core18

snap remove snapd

apt purge snapd

rm -rf ~/snap

rm -rf /home/chia/snap

rm -rf /var/snap

rm -rf /var/lib/snapd

# Удалить привязку к облаку 
sudo touch /etc/cloud/cloud-init.disabled

dpkg-reconfigure cloud-init  # Disable all services (uncheck everything except "None")

sudo apt-get purge cloud-init

sudo rm -rf /etc/cloud/ && sudo rm -rf /var/lib/cloud/

sudo reboot

# Статус строка в screen
```
echo "hardstatus alwayslastline
hardstatus string '%{gk}[ %{G}%H %{g}][%{= kw}%-w%{= BW}%n %t%{-}%+w][%= %{=b kR}(%{W} %h%?(%u)%?%{=b kR} )%{= kw}%=][%{Y}%l%{g}]%{=b C}[ %d.%m.%Y %c:%s ]%{W}'
defscrollback 10000 "  > ~/.screenrc
echo "hardstatus alwayslastline 
hardstatus string '%{gk}[ %{G}%H %{g}][%{= kw}%-w%{= BW}%n %t%{-}%+w][%= %{=b kR}(%{W} %h%?(%u)%?%{=b kR} )%{= kw}%=][%{Y}%l%{g}]%{=b C}[ %d.%m.%Y %c:%s ]%{W}'
defscrollback 10000 "  > /home/chia/.screenrc
chown chia:chia /home/chia/.screenrc
```

# время, автоматическая синхронизация
timedatectl set-timezone Europe/Moscow

apt-get install ntp

nano /etc/ntp.conf
```
#pool 0.ubuntu.pool.ntp.org iburst
#pool 1.ubuntu.pool.ntp.org iburst
#pool 2.ubuntu.pool.ntp.org iburst
#pool 3.ubuntu.pool.ntp.org iburst
server 0.ru.pool.ntp.org
server 1.ru.pool.ntp.org
server 2.ru.pool.ntp.org
server 3.ru.pool.ntp.org
```

service ntp restart

service ntp status

systemctl enable ntp

ntpq -p
```
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
 ntp.ubuntu.com  .POOL.          16 p    -   64    0    0.000    0.000   0.000
 128.0.142.251   195.210.189.106  2 u   65   64    7   29.154   -0.215   9.519
*ntp2.aas.ru     .MRS.            1 u    -   64   17   22.142   -0.198   8.245
 2a00:ab00:203:9 .INIT.          16 u    -   64    0    0.000    0.000   0.000
 ntp.truenetwork 89.109.251.21    2 u   62   64    7   63.657    0.211   7.158
 chilipepper.can 17.253.34.123    2 u   59   64    1   97.475  -23.010   0.000
 alphyn.canonica 132.163.96.1     2 u   59   64    1  103.638    5.805   0.000
 golem.canonical 17.253.34.123    2 u   55   64    1   37.851    6.071   0.000
 pugot.canonical 140.203.204.77   2 u   57   64    1   59.615   -1.399   0.000
```

# Установим тулзы фермера 
cd /root

git clone https://github.com/setar/chia-farm-tools.git

cd chia-farm-tools

touch chia-scripts/config.txt

mcedit chia-scripts/config.txt

# Проверяем конфигурацию
Если криптоцепочка не запущена и не синхронизированна, то ключи фермера и контракта можно поменять позже, главное не забыть
например:
```
# farmer/plotter имя пользователя
user = chia

# папка для монтирования дисков
farm = /home/chia/farm

# еуьз папка где смонтирован NVMe
temp = /home/chia/temp 

# temp2 папка где смонтирован NVMe или RAM
ram = /home/chia/ram

# farmer public key, from 'chia keys show'
fpk = 88cbed9eb6b92d75f4073c65ca231e81f4a95057f4b9c5461997170e71adcbebe2a0eacbba2a0153ec936cfbe2f32e8f

# pool contract address, from 'chia plotnft show'
nft = xch18kspvxwzth2ssyup97qc642unxe0k2fljkrkslzmvxu3zqfja88sqwzghg

# количество ядер для одного процесса плоттинга
threads = 4

# режим расширенного логирования
debug = false

# максимальное число процессов одновременного копирования в системе
max_count = 4

# максимальное число потоков копирования на один диск
dst_count = 1

# роль этого узла : farmer / harvester
role = farmer

# диски являются сетевыми (SAN) например nfs (перед проверкой свободного места зайдем в каждую папку) : false / true
nfs = false

# максимальное время копирования одного готового плота в секундах, которое мы ждем не считая процесс умершим
time = 1800
```
sh install.sh

## Криптоцепочка
chia_cli

cd ~

git clone https://github.com/Chia-Network/chia-blockchain.git -b main --recurse-submodules

cd chia-blockchain

chmod +x ./install.sh

sh install.sh

. ./activate

chia init

chia init --fix-ssl-permissions

chia keys add
```
chia keys show --show-mnemonic-seed
```

chia keys show

chia start farmer

chia show -a introducer-eu.chia.net:8444

chia configure -upnp false

chia configure --log-level INFO

chia start farmer -r

### быстрое обновление баз с рабочего узла 
* на обоих узлах остановить клиентзы чиа
'chia stop all -d'
* скопировать основную базу  
/home/chia/.chia/mainnet/db/*.sqlite
* в случае совпадения ключей можно скопировать бд кошелька
/home/chia/.chia/mainnet/wallet/db/*.sqlite
* запустить фермер на обоих узлах
'chia start farmer -r'

## размечаем NVMe
lsblk |grep nvme  # тут запоминаем букву диска например nvme0n1 (или несколько)

cd root-scripts

mcedit admin_mktemp.sh

для одного диска изменить так (ремарка на создании массива):
```
#!/bin/bash
# тут менять дискки NVMe (!все данные с них будут уничтожены) и их кол-во
#mdadm --create /dev/md0 --level=stripe --raid-devices=3 --chunk=512 /dev/sdb /dev/sdc /dev/sdd
# дальше менять ничего не нужно
...
```
проверить что на месте диск temp и если используется ram:

df -h
```
Filesystem      Size  Used Avail Use% Mounted on
...
tmpfs           220G     0  220G   0% /home/chia/ram
/dev/nvme0n1    3.5T   89M  3.3T   1% /home/chia/temp
```

## Размечаем новые диски хранения (из под рута)
**ВНИМАНИЕ! все диски кроме NVMe и системы будут отфарматированы и поставлены в ферму**

screen -S root

cd /root/chia-farm-tools/root-scripts

./admin_newmount.sh

## теперь добавим каталоги фермеру для поиска плотов
chia_cli

~/chia-scripts/chia_newmount.sh

## Установка MadMax plotter
chia_cli

cd

git clone https://github.com/madMAx43v3r/chia-plotter.git

sudo apt install -y libsodium-dev cmake g++ git build-essential

cd chia-plotter

git submodule update --init

./make_devel.sh

## автозапуск кошелька и фермера (без  процессов плоттера)
chia_cli

crontab -e
```
@reboot sh /home/chia/chia-scripts/chia_startup.sh
* * * * * /home/chia/chia-scripts/chia_plots_mover.sh >>/home/chia/logs/plots_mover.log
```

# Эксплуатация комплекса 

## запуск MadMax plotter
### окно #1

screen -S mm

su - chia

. ~/chia-blockchain/activate

~/chia-scripts/mm_create_nft.sh

### окно #2
screen -S mm2

su - chia

. ~/chia-blockchain/activate

~/chia-scripts/mm_create_nft.sh

## автоматическое перемещение готовых плотов:
В планировщике пользователя chia  запущен ежеминутный процесс контроля за новыми файлами типа *.plot в каталоге /home/chia/temp
при появлении таковых скрипт резервирует место на первом свободном диске и запускает процесс перемещения готового плота.
Сам скрипт находится /home/chia/chia-scripts/chia_plots_mover.sh
Лог работы расположен /home/chia/logs/plots_mover.log

## быстрые скрипты из комплекта chia-farm-tools для автоматизации контроля и обслуживания
```
скрин (screen) - автономно запущенная консоль, от которой можно отцепиться и прицепиться заново с того же места даже после обрыва связи
признаком нахождения в скрине является нижний статус бар с средней загрузкой системы, датой и временем:
[ chia ][0 bash][                                                  (  )                                                  ][2.43 2.04 2.09][ 26.06.2021  9:14:27 ]

выход из скрина (отцепиться ) :  Ctrl+a , d (две клавиши, затем их отпустить и сразу одну клавишу)
закрыть скрин (удалить/убить): несколько раз последовательно Ctrl+d   до пропадания статус бара (обычно там 3 вложенные консоли)
```
запуск быстрых скринов (из под консоли root):
chia_cli - выдаст текущую статистику и запустит консоль chia для выполнения команд
chia_log - полный детальный лог (прервать Ctrl+c но можно просто отцепиться)
chia_log2 - лог с фильтром по текущим проверкам плотов (включая скорость этого процесса, норма до 2 сек, до 5 можно но плохо)
chia_summary - общая информация по ферме
chia_mm , chia_mm2 - мониторинг плоттинг подсистемы (MadMax)
chia_mover - лог скрипта перемещения готовых плотов (прервать Ctrl+c но можно просто отцепиться)


## полезные команды для консоли chia_cli
```
текущее состояние 
chia show -s

сколько коннектов с миром 
chia show -c

информация о плотах
chia plots show

проверка плотов n=кол-во тестов по умолчатию 30, выше будет более долгая и точная проверка.
chia plots check -n 1

результат последних тестов на "вырастание выигрыша"
chia farm challenges

разные фильтры по логам
tail -f /home/chia/.chia/mainnet/log/debug.log |grep full_node 
tail -f /home/chia/.chia/mainnet/log/debug.log |grep chia.harvester.harvester

показать кошелек (с сектерной фразой)
chia keys show --show-mnemonic-seed

проверка качества плотов (без удаления), рационально вывод перенаправлять в файл  
~/chia-scripts/chia_plots_QC.sh  > QC.txt

проверка и чистка дисков от повторяющихся плотов а так же не завершенных процедур перемещания
~/chia-scripts/chia_plots_validator.sh 

чистка из системы и процесса фермера каталогов от удаленных фисков
~/chia-scripts/chia_del_unused_dirs.sh 

```

---

## вспомогательные админские скрипты: Используем крайне вдумчиво!
доступны только для рута
- создание темп диска 
		1. рескан дисков (актуально если новые вставлены)
			- rescan-scsi-bus
		2. идентифицируем NVMe например по размеру
			- lsblk
			- 
			- тут sdb , sdc, sdd
			- или 
			- lsblk |grep nvme  # тут запоминаем букву диска например nvme0n1 (или несколько)
		3. правим скрипт создания указывая темп диски и их кол-во
			- mcedit /root/scripts/admin_mktemp.sh
			- 
		4. запускаем скрипт
			- /root/scripts/admin_mktemp.sh
		5. проверяем что темп подцепился :
			- df -h /home/chia/temp
			- 

- подключение новых дисков для плотов
	1. физически вставить диски
	2. запустить скрипт  /root/chia-farm-tools/root-scripts/admin_newmount.sh
		- будет произведен рескан шины, и попытка подключить все диски исключая системный и темп
		- диски которые уже подключены - будут игнорированы
		- новые будут подключены и поставлены в автостарт
		- "грязные диски" (с имеющейся файловой системой) - будут почищены, поэтому запуск ручной

---
Перевод машин в режим harvester-only

Поднимается виртуалка main, настройка аналогично обычным машинам (без насройки nvme и дисков)
c машины main на харвестеры копируется каталог  /home/chia/.chia/mainnet/config/ssl/ca/*

на харвест машинах
chia_cli
ssh 192.168.2.230 "(cd /home/chia/.chia/mainnet/config/ssl/ca ; tar cjf - ./*)" | (mkdir -p /home/chia/ca.ssl; cd /home/chia/ca.ssl; cat | tar xj )
chia stop all -d
chia init -c /home/chia/ca.ssl
mcedit /home/chia/.chia/mainnet/config/config.yaml
```
harvester:
  chia_ssl_ca:
    crt: config/ssl/ca/chia_ca.crt
    key: config/ssl/ca/chia_ca.key
  farmer_peer:
    host: 192.168.2.230
    port: 8447
```
chia start harvester
