#yum update -y
#sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
#service iptables stop
yum install -y oracle-database-server-12cR2-preinstall
mkdir -p /u01/app/oracle/product/12.2.0.1
chown -R oracle:oinstall /u01
chmod -R 775 /u01
#cat /dev/null > /etc/hosts

#cat > /etc/hosts <<EOF
#127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 pandora.krenger.local
#::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
#EOF
echo $USER file1
cd /home/oracle
wget https://raw.githubusercontent.com/AgniaInBloom/Oracle_install/main/clean_install_2.sh
chmod 7777 clean_install_2.sh
runuser -l oracle -c 'sh /home/oracle/clean_install_2.sh'
