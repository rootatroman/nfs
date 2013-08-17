#! /bin/bash

 # Скрипт встановлення і налаштування протоколу мережного доступу до ФС.
 # Дозволяє підключати (монтувати) віддалені файлові системи через мережу.

# 
if [ "$(id -u)" != "0" ]; then
   echo -e "\x1b[1;31m[!]\x1b[0m This script must be run as root. Type \x1b[1;32msudo su\x1b[0m" 1>&2
   exit 1
fi

# Скрипт в безкінечному циклі; вихід [Q] (exit) чи [Ctrl]+[C]
while :
do

echo -e ""
echo -e "\x1b[1;32m   <S|A|M|B|A> ""opening windows to a wider world"""
echo -e "  -------------------------------------------------"
echo -e "             SMB/CIFS networking protocol"
echo ""
     read -p "Press [Enter] key to continue..."
sudo apt-get install samba

echo -e "\x1b[1;34ms\x1b[0m - server & client install  \x1b[1;34mf\x1b[0m - configure access to nfs-folders"
echo -e "\x1b[1;34mc\x1b[0m - only client install      \x1b[1;34md\x1b[0m - configure NFS-volume on the client PC"
echo -e "\x1b[1;34mq\x1b[0m or \x1b[1;34m[Ctrl]+[C]\x1b[0m - exit"

  printf "%s\x1b[1;33mNFS:\x1b[0m "
  read menu
  case $menu in
   "s")apt-get install nfs-kernel-server nfs-common portmap
	read -p "Press [Enter] key to continue..."
	;;
   "c") apt-get install portmap nfs-common
	read -p "Press [Enter] key to continue..."
	;;
   "f") echo -e "Enter directory to share: \x1b[1;34m(example /home/roman)\x1b[0m"
	read sfolder
	echo -e "Enter permisions(in parentheses), separated by commas: "
	echo -e " \x1b[1;34mro\x1b[0m - read only"
	echo -e " \x1b[1;34mrw\x1b[0m - read/write"
	echo -e " \x1b[1;34msync\x1b[0m - confirms requests to the shared directory only once the changes have"
	echo -e "        been committed"
	echo -e " \x1b[1;34masync\x1b[0m - reversed to sync"
	echo -e " \x1b[1;34mno_root_squash\x1b[0m - this phrase allows root to connect to the designated directory"
	read perm
	echo -e "Enter allow IP-address(with or without \x1b[1;34m/\x1b[0m mask) or \x1b[1;34m*\x1b[0m to any address: "
	 read sip
	 echo $sfolder $sip$perm >> /etc/exports
echo -e " ----------------------  /etc/exports   -------------------------------"
cat /etc/exports
echo -e " ----------------------------------------------------------------------"
 /etc/init.d/nfs-kernel-server restart
	read -p "Press [Enter] key to continue..."
	;;
   "d") mnt="/media/nfs"
	echo -e "Enter NFS-server ip address:"
        read cip
	echo -e "Enter directory on the server: \x1b[1;34m(example /home/roman)\x1b[0m"
	read cfolder
	echo -e "Enter mounted directory: \x1b[1;34m(default /media/nfs)\x1b[0m"
	read mnt
	mkdir $mnt
	echo $cip":"$cfolder $mnt" nfs defaults 0 0" >> /etc/fstab
	read -p "Press [Enter] key to continue..."
;;
   "q") exit;;
   *) read -p "Sorry, retupe";;
  esac
clear
done
