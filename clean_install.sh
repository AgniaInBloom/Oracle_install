yum update -y
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
service iptables stop
service iptables disable
mkdir -p /u01/app/oracle/product/12.2.0.1
chown -R oracle:oinstall /u01
chmod -R 775 /u01
su oracle
oracle4u

cd /home/oracle

cat /dev/null > vi .bash_profile

cat > /etc/yum.repos.d/docker.repo <<EOF 
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/12.2.0.1/dbhome_1; export ORACLE_HOME
ORACLE_SID=invoice; export ORACLE_SID
ORACLE_TERM=xterm; export ORACLE_TERM
EDITOR=vim; export EDITOR
SQLPATH=$ORACLE_HOME/sqlplus/admin; export SQLPATH
PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH; export PATH
TNS_ADMIN=/u01/app/oracle/product/12.2.0.1/dbhome_1/network/admin/; export TNS_ADMIN
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib:$LD_LIBRARY_PATH; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib:$CLASSPATH; export CLASSPATH

if [ $USER = "oracle" ]; then
        if [ $SHELL = "/bin/ksh" ]; then
                ulimit -p 16384
                ulimit -n 65536
        else
                ulimit -u 16384 -n 65536
        fi
fi 
EOF

