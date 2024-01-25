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

cat > .bash_profile <<EOF 
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

. .bash_profile

cd /tmp
wget  ##Ссылка на архив исходника

mkdir /u01/app/oracle/product/12.2.0.1/dbhome_1
cd /u01/app/oracle/product/12.2.0.1/dbhome_1

unzip -qo /tmp/V839960-01.zip
cd $ORACLE_HOME/database

###

./runInstaller -ignoreSysPrereqs -showProgress -silent       \
oracle.install.option=INSTALL_DB_SWONLY                      \
ORACLE_HOSTNAME=${HOSTNAME}                                  \
UNIX_GROUP_NAME=oinstall                                     \
INVENTORY_LOCATION=/u01/app/oraInventory                     \
SELECTED_LANGUAGES=en,en_GB                                  \
ORACLE_HOME=${ORACLE_HOME}                                   \
ORACLE_BASE=${ORACLE_BASE}                                   \
oracle.install.db.InstallEdition=EE                          \
oracle.install.db.OSDBA_GROUP=dba                            \
oracle.install.db.OSOPER_GROUP=dba                           \
oracle.install.db.OSBACKUPDBA_GROUP=dba                      \
oracle.install.db.OSDGDBA_GROUP=dba                          \
oracle.install.db.OSKMDBA_GROUP=dba                          \
oracle.install.db.OSRACDBA_GROUP=dba                         \
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                   \
DECLINE_SECURITY_UPDATES=true                                \
oracle.installer.autoupdates.option=SKIP_UPDATES

###

su root 
pandora

sh /u01/app/oraInventory/orainstRoot.sh
/u01/app/oracle/product/12.2.0.1/dbhome_1/root.sh

su oracle 
oracle4u

cd /u01/app/oracle/product/12.2.0.1/dbhome_1/bin
./dbca -silent -createDatabase                   -templateName General_Purpose.dbc              -gdbName ${ORACLE_SID}                         -sid ${ORACLE_SID}                             -createAsContainerDatabase false               -emConfiguration NONE                          -datafileDestination /u01/db_files             -storageType FS                                -characterSet AL32UTF8                         -totalMemory 2048                              -recoveryAreaDestination /u01/FRA              -sampleSchema true


