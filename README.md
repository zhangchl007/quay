# docker-compose for Red Hat Quay

It's a docker-compose for Quay community/enterprise POC quick solution

Add new environment varible "ENCRYPTED_ROBOT_TOKEN_MIGRATION_PHASE=new-installation"to support Quay community.

If you adopt the Quay HA, Please refer to the following link:
[Quay HA](https://github.com/zhangchl007/quay-ha)

Quay Dockerfile

[Quay Image Build](https://github.com/quay/quay/blob/master/docs/development-container.md)

For Clair Deployment, please revise clair-config/config.yaml based on your real environment.

## Deploy DNS for Quay and Clair, for example:

   Add two lines into dnsmasq.conf below:

   address=/quay01.test.com/192.168.0.17

   address=/clair.test.com/192.168.0.17

   Start and verity dnsmasq service
   ```
   docker-compose -f docker-compose.dnsmasq.yml up -d
   dig@{hostip} quay01.test.com
   dig@{hostip} clair.test.com
   ```
For the partner integretion, Please refer to the official doc below.

[Clair Scan Deployment](https://access.redhat.com/documentation/en-us/red_hat_quay/3/html-single/manage_red_hat_quay/index#quay-security-scanner)

[Clair Integrations](https://github.com/quay/clair/blob/master/Documentation/integrations.md)
# Quay Deployment
```
# Generate self certification
./self-cert-generate.sh test.com registry.test01.com test01.com test01

# Deploy Quay
# create Directory for Quay
sudo sh pre-quaydeploy.sh

# Create the quayconfig container
#for mysql
sudo docker-compose  -f docker-compose.config-mysql.yml up -d
#for pgsql
sudo docker-compose  -f docker-compose.config-pgsql.yml up -d
sudo docker-compose -f docker-compose.config-pgsql.yml exec pgsql /bin/bash /usr/local/bin/post-pgsql.sh
```
# Generate config file via web GUI
Please type the access web url of Quay config container, for example:

http://quay01.test.com/8443

username/password: quayconfig/redhat

Set pgsql db connection
![dbconn](https://github.com/zhangchl007/quay/blob/master/img/db-connection.png)

Set username/password
![username](https://github.com/zhangchl007/quay/blob/master/img/username.png)

## Notes: Enabling Clair on a Red Hat Quay Basic or HA deployment

Please create a Key ID and Private Key (PEM).
![ERVICE_KEY_ID](https://github.com/zhangchl007/quay/blob/master/img/key-id.png)

For single clair , don't forget to approve CLAIR_SERVICE_KEY_ID once Quay is ready
![AERVICE_KEY_ID](https://github.com/zhangchl007/quay/blob/master/img/single-quay.png)

Please refer to the config file below:

[config file](https://raw.githubusercontent.com/zhangchl007/quay/master/clair-config/config.yaml)

For clair HA, Please refer to config below::

[config file](https://raw.githubusercontent.com/zhangchl007/quay/master/clair-config/config.yaml-ha)

Please replace those two value as below:

key_id: { 4fb9063a7cac00b567ee921065ed16fed7227afd806b4d67cc82de67d8c781b1 }

private_key_path: /clair/config/security_scanner.pem

Download Quay config file

![quay config](https://github.com/zhangchl007/quay/blob/master/img/config.png)

```
# upload the Quay config file and uncompress it
sudo mv quay-config.tar.gz  /quay/config
cd /quay/config && tar -zxvf quay-config.tar.gz

# Delete the quayconfig and Stop redis and mysql/pgsqlcontainer
sudo sh ./pre-deleteconfig.sh

# Start mysql, redis and Quay
#for mysql
sudo docker-compose  -f docker-compose.quay-mysql.yml up -d
#for pgsql
sudo docker-compose  -f docker-compose.quay-pgsql.yml up -d

# Verify the Clair service
$  curl -X GET -I http://172.31.0.65:6061/health
HTTP/1.1 200 OK
Server: clair
Date: Sat, 11 Jan 2020 11:21:24 GMT
Content-Length: 0
```
Check the status of images Scan
![image status ](https://github.com/zhangchl007/quay/blob/master/img/clair.png)

# Clean up Quay
```
sh clear-quay.sh
```
