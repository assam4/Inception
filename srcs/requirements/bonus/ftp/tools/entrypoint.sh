#!/bin/bash

FTP_USER="wordpress"
FTP_PASS=$(cat /run/secrets/wordpress_simplepass 2>/dev/null || echo "password")

mkdir -p /var/run/vsftpd/empty
chmod 555 /var/run/vsftpd/empty

adduser $FTP_USER --disabled-password --gecos "" 2>/dev/null || true
echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd

echo "$FTP_USER" >> /etc/vsftpd.userlist

mkdir -p /home/$FTP_USER/ftp

chown nobody:nogroup /home/$FTP_USER/ftp
chmod a-w /home/$FTP_USER/ftp
chown -R $FTP_USER:$FTP_USER /var/www

sed -i -r "s/#write_enable=YES/write_enable=YES/1" /etc/vsftpd.conf
sed -i -r "s/#chroot_local_user=YES/chroot_local_user=YES/1" /etc/vsftpd.conf

echo "
local_enable=YES
allow_writeable_chroot=YES
pasv_enable=YES
pasv_min_port=6000
pasv_max_port=6100
local_root=/var/www
userlist_file=/etc/vsftpd.userlist
userlist_enable=YES
userlist_deny=NO
secure_chroot_dir=/var/run/vsftpd/empty" >> /etc/vsftpd.conf

/usr/sbin/vsftpd /etc/vsftpd.conf