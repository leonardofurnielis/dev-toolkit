#!/bin/bash

echo "*******************************************************"
echo "Starting IBM Db2 installation"
echo "*******************************************************"

read -p "Enter Db2 binary location (e.g. /home/DB2S_11.5.4_MPML.tar.gz ): " DB2_DIR
read -p "Enter Db2 version (e.g. 11.5.4 ): " DB2_VERSION

echo "*******************************************************"
echo "Updating Linux packages"
echo "*******************************************************"

yum update -y

rm -rf rm -rf /home/db2install
mkdir -p /home/db2install

echo "*******************************************************"
echo "Checking Db2 binary"
echo "*******************************************************"

IFS='/'
read -a DB2_FILENAME <<< "$DB2_DIR"
DB2_FILENAME=${DB2_FILENAME[-1]}
unset IFS

if [ -f "$DB2_DIR" ]; then
  echo "*******************************************************"
  echo "Moving Db2 binary to installation directory (/home/db2install)."
  echo "*******************************************************"

  cp $DB2_DIR "/home/db2install/$DB2_FILENAME"
else
  echo "[ERROR] Db2 binary not found. Check the directory location and try again."
  exit 1
fi

echo "*******************************************************"
echo "Unpacking $DB2_FILENAME"
echo "*******************************************************"

tar -xvf /home/db2install/$DB2_FILENAME -C /home/db2install

echo "*******************************************************"
echo "Installing pre-requirements"
echo "*******************************************************"

yum install gcc cpp gcc-c++ libstdc++.so.6 pam.i686 kernel-devel chrony binutils m4 ksh make patch mksh psmisc -y

echo "*******************************************************"
echo "Installing IBM Db2"
echo "*******************************************************"

/home/db2install/server_dec/db2_install -y -b /opt/ibm/db2/V$DB2_VERSION/

echo "*******************************************************"
echo "Apply license to IBM Db2"
echo "*******************************************************"
/opt/ibm/db2/V$DB2_VERSION/adm/db2licm -l

read -p "Enter Db2 License location (e.g. /home/DB2_DAE_Activation_11.5.zip ): " DB2_LIC_DIR

echo "*******************************************************"
echo "Checking Db2 license"
echo "*******************************************************"
IFS='/'
read -a DB2_LIC_FILENAME <<< "$DB2_LIC_DIR"
DB2_LIC_FILENAME=${DB2_LIC_FILENAME[-1]}
unset IFS

if [ -f "$DB2_LIC_DIR" ]; then
  echo "*******************************************************"
  echo "Moving Db2 license to installation directory (/home/db2install)."
  echo "*******************************************************"
  cp $DB2_LIC_DIR "/home/db2install/$DB2_LIC_FILENAME"
else
  echo "[ERROR] Db2 license not found. Check the directory location and try again."
  exit 1
fi

/opt/ibm/db2/V$DB2_VERSION/adm/db2licm -a /home/db2install/adv_vpc/db2/license/db2adv_vpc.lic
/opt/ibm/db2/V$DB2_VERSION/adm/db2licm -r db2dec

echo "*******************************************************"
echo "Creating group and user for db2 instance (db2inst1)"
echo "*******************************************************"

groupadd -g 1001 db2iadm1
useradd -g db2iadm1 -u 1001 -d /home/db2inst1 -s /bin/bash db2inst1

groupadd -g 1002 db2fadm1
useradd -g db2fadm1 -u 1002 -d /home/db2fenc -s /bin/bash db2fenc

echo "*******************************************************"
echo "Creating db2 instance (db2inst1)"
echo "*******************************************************"

/opt/ibm/db2/$DB2_VERSION/instance/db2ilist
/opt/ibm/db2/$DB2_VERSION/instance/db2icrt -a server -s ese -u db2fenc -p 50000 db2inst1
/opt/ibm/db2/$DB2_VERSION/instance/db2ilist

echo "*******************************************************"
echo "Successfully installed Db2 and created instance (db2inst1)"
echo "*******************************************************"
