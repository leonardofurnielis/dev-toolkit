# MongoDb installation guide 

1. [Update Linux](#update-linux)
2. [Installing MongoDb](#installing-mongodb)
3. [Running MongoDb instance](#running-mongodb-instance)
4. [Additional resources](#additional-resources)

### The environment used in this guide.

- MongoDb: 6.0
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

## Update Linux

**For MongoDb installation guide, the user `root` will be used to perform the actions.**

```bash
yum update -y
```

## Installing Mongodb

Create a `/etc/yum.repos.d/mongodb-org-6.0.repo` with the following instructions:

```
[mongodb-org-6.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/6.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
```

```bash
yum install -y mongodb-org
```

#### Prevent unintended version upgrades

Yum upgrades the packages when a newer version becomes available. Follow this step to prevent unintended upgrades.

Add the following instructions to your `/etc/yum.conf` file:

```
exclude=mongodb-org,mongodb-org-database,mongodb-org-server,mongodb-mongosh,mongodb-org-mongos,mongodb-org-tools
```

## Running MongoDb instance

```
systemctl start mongod

systemctl status mongod
```

## Additional resources
