## Welcome

This project packages [mysql](https://www.mysql.com/) server and [phpmyadmin](https://www.phpmyadmin.net/), a popular administration interface for mysql, inside a docker image.

It is built directly from Ubuntu and runs phpmyadmin on nginx.

## Usage

Build the image, run the container and visit http://localhost:8000/ to open the administration interface.

```sh
docker build --rm -t phpmyadmin .
docker run -d -p 8000:80 -p 3306:3306 --name=myContainer phpmyadmin
```

Please check the [docker run command documentation](https://docs.docker.com/engine/reference/commandline/run/) for more details about restart policy, volume mounting, etc.  
You can also use network configuration to securely expose mysql or phpmyadmin on internet.

## Todo

* TimeZone as environment variable (currently in Dockerfile)
* MySQL root password as environment variable (currently in configure.sh)
* FPM version as environment variable (currently in Dockerfile, configure.sh and start.sh)

## Notes

### Backup to OVH object storage with crontab

Below is an example of a backup procedure to export a database into a S3-like object in the cloud.

Create an interactive shell on the container

```sh
docker exec -it myContainer /bin/bash
```

Install swift, the object/blob management component from the [OpenStack](https://www.openstack.org/) standard cloud computing platform

```sh
apt-get install -y python3-openstackclient python3-novaclient python3-pip swift
pip3 install python-swiftclient
```

Configure a user from your cloud operator and download the corresponding openrc.sh file ([more info here](https://docs.openstack.org/liberty/install-guide-rdo/keystone-openrc.html))

Create the following script into /root/backup.sh *(vi /root/backup.sh)*

```sh
#!/usr/bin/bash
cd /root
NAME=mysql_$(date +%Y-%m-%d).dump.gz  # generate a filename for the archive
mysqldump -u myDatabaseUser -pmyDatabasePwd myDatabaseName | gzip 1>$NAME  # export and compress
source openrc.sh  # load environment variables with access credentials to your cloud operator
/usr/local/bin/swift upload myObjectContainer $NAME
rm $NAME
```

Add an entry in crontab *(crontab -e)*

```sh
# m h dom mon dow user  command
* 3 * * * /usr/bin/bash /root/backup.sh
```
