## Welcome

This project packages [mysql](https://www.mysql.com/) server and [phpmyadmin](https://www.phpmyadmin.net/), a popular administration interface for mysql, inside a docker image.

It is built directly from Ubuntu and runs phpmyadmin on nginx.

## Usage

Build the image, run the container and visit http://localhost:8000/ to open the administration interface.

```
docker build -t phpmyadmin .
docker run -d -p 8000:80 -p 3306:3306 --name=mycontainer phpmyadmin
```

You can use network configuration to securely expose mysql or phpmyadmin on internet.

## Notes

### Backup to OVH object storage with crontab

Below is an example of a backup procedure to export a database into a S3-like object in the cloud.

Install swift, the object/blob management component from the [OpenStack](https://www.openstack.org/) standard cloud computing platform

```
apt-get install -y python3-openstackclient python3-novaclient swift
pip3 install python-swiftclient
```

Configure a user from your cloud operator and download the corresponding openrc.sh file ([more info here](https://docs.openstack.org/liberty/install-guide-rdo/keystone-openrc.html))

Create the following script into /root/backup.sh *(vi /root/backup.sh)*

```
#!/usr/bin/bash
cd /root
NAME=mysql_$(date +%Y-%m-%d).dump.gz  # generate a filename for the archive
mysqldump -u myDatabaseUser -pmyDatabasePwd myDatabaseName | gzip 1>$NAME  # export and compress
source openrc.sh
/usr/local/bin/swift upload mantis-backup $NAME 
rm $NAME
```

Add an entry in crontab *(crontab -e)*

```
# m h dom mon dow user  command
* 3 * * * /usr/bin/bash /root/backup.sh
```
