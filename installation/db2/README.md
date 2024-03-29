
# Db2 installation guide 

This guide contains a [shell script](https://github.com/leonardofurnielis/toolkit/blob/master/installation/db2/db2-installation.sh) automation to install Db2 (non pureScale) on Linux. You can run it manually following the steps:

1. [Update Linux and install pre-requirements](#update-linux-and-install-pre-requirements)
2. [Installing Db2](#installing-db2)
3. [Apply license to IBM Db2](#apply-license-to-ibm-db2)
4. [Creating group and user for db2 instance (db2inst1)](#creating-group-and-user-for-db2-instance-db2inst1)
5. [Creating db2 instance (db2inst1)](#creating-db2-instance-db2inst1)
6. [Additional resources](#additional-resources) \
    6.1 [Running Db2 instance](#running-db2-instance) \
    6.2 [Create database](#create-database) \
    6.3 [Connect to database and querying](#connect-to-database-and-querying) \
    6.4 [Deactivate database](#deactivate-database) \
    6.5 [Stop database instance](#stop-database-instance) \
7. [Containerized deployment](#containerized-deployment)

### The environment used in this guide.

- Db2: 11.5.4
- OS: CentOS 7.9

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/installation_guide/s2-diskpartrecommend-x86

| Filesystem | Size |
| ------ |------|
| swap | 4G |
| /boot| 1G |
| /tmp | 5G |
| /home | 15G |
| /var | 15G |
| /usr | 10G |
| / | 10G |

## Update Linux and install pre-requirements

**For Db2 installation guide, the user `root` will be used to perform the actions.**

```bash
yum update -y
```

```bash
yum install gcc cpp gcc-c++ libstdc++.so.6 pam.i686 kernel-devel chrony binutils m4 ksh make patch mksh psmisc -y

yum list installed —check installed libs
```

Check if Db2 pre-requirements are met.
https://www.ibm.com/docs/en/db2/11.5?topic=commands-db2prereqcheck-check-installation-prerequisites

<sub>** -l: Check prerequisite for latest DB2 version. \
** -i: Check prerequisite for non pureScale installation.</sub> 

```bash
./server_dec/db2prereqcheck -i -l
```

## Installing Db2

https://www.ibm.com/docs/en/db2/11.1?topic=commands-db2-install-install-db2-database-product
 
<sub>** -y: Specifies that you have read and agreed to the license agreement. \
** -b: Specifies the path where the Db2 database product is to be installed.</sub> 
```bash
./server_dec/db2_install -y -b /opt/ibm/db2/V11.5.4/

Specify One of the following keywords to install DB2 products.

SERVER
CONSV
CLIENT
RTCL
  
Enter "help" to redisplay product names.

Enter "quit" to exit.

*******************************************************
SERVER
*******************************************************


Do you want to install the DB2 pureScale feature? [yes/no]

no
```

## Apply license to IBM Db2

https://www.ibm.com/docs/en/db2/11.5?topic=licenses-db2licm-license-management-tool-command

Check actual license

<sub>**-l: Lists all the products with available license information.</sub>
```bash
/opt/ibm/db2/V11.5.4/adm/db2licm -l
```

<sub>**-a: Adds a license for a product.</sub>
```bash
/opt/ibm/db2/V11.5.4/adm/db2licm -a db2_license.lic
```

Removing community license

<sub>**-r: Removes the license for a product.</sub>
```bash
/opt/ibm/db2/V11.5.4/adm/db2licm -r db2dec
```

## Creating group and user for db2 instance (db2inst1)

```bash
groupadd -g 1001 db2iadm1
useradd -g db2iadm1 -u 1001 -d /home/db2inst1 -s /bin/bash db2inst1

groupadd -g 1002 db2fadm1
useradd -g db2fadm1 -u 1002 -d /home/db2fenc -s /bin/bash db2fenc
```

## Creating db2 instance (db2inst1)

List db2 instances.
https://www.ibm.com/docs/en/db2/11.5?topic=commands-db2ilist-list-instances
 
```bash
/opt/ibm/db2/V11.5.4.0/instance/db2ilist
```

Create database instance.
https://www.ibm.com/docs/en/db2/11.5?topic=commands-db2icrt-create-instance

<sub>**-a: Specifies the authentication type. \
**-s: Specifies the type of instance to create. \
**-u: Specifies the name of the user ID under which fenced user-defined. \
**-p: Specifies the TCP/IP port name or number that is used by the instance.</sub>
```bash
/opt/ibm/db2/V11.5.4.0/instance/db2icrt -a server -s ese -u db2fenc -p 50000 db2inst1
```

## Additional resources

**For additional resources, the user `db2inst1` will be used to perform the actions.**

### Running Db2 instance

```bash
db2set -all
db2 get dbm cfg
db2start
```

### Create database

```bash
db2sampl -sql
db2 list db directory

db2 activate db sample
db2 list active databases
```

### Connect to database and querying

```bash
db2 connect to sample
db2 list tables for schema db2inst1

db2 "select * from db2inst1.dept"
```

### Deactivate database

```bash
db2 deactivate db sample
```

### Stop database instance

```bash
db2stop
```

## Containerized deployment

https://www.ibm.com/docs/en/db2/11.5?topic=db2-containerized-deployments

```bash
podman pull ibmcom/db2
```

```bash
podman run -itd --name db2server --privileged=true -p 50000:50000 -e LICENSE=accept -e DB2INST1_PASSWORD=passwd@22 -e DBNAME=bludb -v /home/db2inst1:/database ibmcom/db2
```