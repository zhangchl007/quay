# docker-compose for Red Hat Quay

It's a docker-compose for Quay community/enterprise POC quick solution

Add new environment varible "ENCRYPTED_ROBOT_TOKEN_MIGRATION_PHASE=new-installation"to support Quay community.

If you adopt the Quay HA, Please refer to the following link:
[Quay HA](https://github.com/zhangchl007/quay-ha)

[Quay Dockerfile](https://github.com/quay/quay/blob/master/Dockerfile.rhel8)

[Quay Image Build](https://github.com/quay/quay/blob/master/docs/development-container.md)

For the Partner integretion, Please refer to the official doc below.

[Clair Scan Deployment](https://access.redhat.com/documentation/en-us/red_hat_quay/3/html-single/manage_red_hat_quay/index#quay-security-scanner)

[Clair Integrations](https://github.com/quay/clair/blob/master/Documentation/integrations.md)

# For MySQL, deploy Red Hat Quay 
```
# Generate self certification
./self-cert-generate.sh test.com registry.test01.com test01.com test01

# Create Directory for Quay
sudo sh pre-quaydeploy.sh

# Create the quayconfig container
sudo docker-compose  -f docker-compose.config-mysql.yml up -d

# Generate config file via web GUI
Please refer to the steps for pgsql

# upload the Quay config file and uncompress it
sudo mv quay-config.tar.gz  /quay/config
cd /quay/config && tar -zxvf quay-config.tar.gz

# Delete the quayconfig and Stop redis and mysql container
sudo sh ./pre-deleteconfig.sh

# Start Quay, MySQL and Redis
sudo docker-compose  -f docker-compose.quay-mysql.yml up -d
```
# For PostgreSQL, deploy Red Hat Quay with Clair

# Deploy DNS for Quay
   ```
   For example, add two lines into dnsmasq.conf as below:

   address=/quay01.test.com/192.168.0.17

   address=/clair.test.com/192.168.0.17

   Start and verity dnsmasq service

   docker-compose -f docker-compose.dnsmasq.yml up -d

   dig@{hostip} quay01.test.com

   dig@{hostip} clair.test.com
   ```
# Deploy quayconfig container
   ```
   # Generate self certification

   ./self-cert-generate.sh test.com quay01.test.com test.com test

   # Create Directory for Quay

   sudo sh pre-quaydeploy.sh

   # Create the quayconfig container

   sudo docker-compose  -f docker-compose.config-pgsql.yml up -d

   sudo docker-compose -f docker-compose.config-pgsql.yml exec pgsql /bin/bash /usr/local/bin/post-pgsql.sh
   ```
# Generate config file via web GUI
Please type the access web url of Quay config container 

for example: http://quay01.test.com/8443

username/password: quayconfig/redhat

Set pgsql db connection

![dbconn](https://github.com/zhangchl007/quay/blob/master/img/db-connection.png)

Set username/password

![username](https://github.com/zhangchl007/quay/blob/master/img/username.png)

Set registry with  tls  

![username](https://github.com/zhangchl007/quay/blob/master/img/ssl.png)

## Enabling Clair on a Quay Basic or HA deployment

Please create a Key ID and Private Key (PEM).
![ERVICE_KEY_ID](https://github.com/zhangchl007/quay/blob/master/img/key-id.png)

For single clair , don't forget to approve CLAIR_SERVICE_KEY_ID once Quay is ready
![AERVICE_KEY_ID](https://github.com/zhangchl007/quay/blob/master/img/single-quay.png)

Please refer to the config file below:

[config file](https://raw.githubusercontent.com/zhangchl007/quay/master/clair-config/config.yaml)

For Quay HA, Please refer to the config file(also works  for single Quay) below:

[config file](https://raw.githubusercontent.com/zhangchl007/quay/master/clair-config/config.yaml-ha)

Please replace those two value as below:

key_id: { 4fb9063a7cac00b567ee921065ed16fed7227afd806b4d67cc82de67d8c781b1 }

private_key_path: /clair/config/security_scanner.pem

## Add repository mirroring

Enable repository mirroring:

![mirroring](https://github.com/zhangchl007/quay/blob/master/img/mirror.png)


# Download Quay config file

![quay config](https://github.com/zhangchl007/quay/blob/master/img/config.png)

```
# upload the Quay config file and uncompress it
sudo mv quay-config.tar.gz  /quay/config
cd /quay/config && tar -zxvf quay-config.tar.gz

# Delete the quayconfig and Stop redis and mysql/pgsqlcontainer
sudo sh ./pre-deleteconfig.sh

# Start pgsql, redis and Quay
for clair
sudo docker-compose  -f docker-compose.quay-pgsql.yml up -d
for mirror
docker-compose  -f docker-compose.quay-pgsql-mirror.yml up -d

# Verify the Clair service
$  curl -X GET -I http://172.31.0.65:6061/health
HTTP/1.1 200 OK
Server: clair
Date: Sat, 11 Jan 2020 11:21:24 GMT
Content-Length: 0
```
## Check the status of images Scan

![image status ](https://github.com/zhangchl007/quay/blob/master/img/clair.png)

## Check the status of mirrored repository

![image status ](https://github.com/zhangchl007/quay/blob/master/img/mirror02.png)

# Clean up Quay
```
sh clear-quay.sh
```
# Troubleshooting 
```
1. Issue1
time="2020-02-16T02:45:39Z" level=info msg="Starting reverse proxy (Listening on 'unix:/tmp/jwtproxy_secscan.sock')"
time="2020-02-16T02:45:39Z" level=error msg="Failed to start reverse proxy: listen unix /tmp/jwtproxy_secscan.sock: bind: address already in use"
time="2020-02-16T02:45:39Z" level=info msg="Starting forward proxy (Listening on ':8081')"
jwtproxy stderr | time="2020-02-16T02:45:39Z" level=info msg="Starting forward proxy (Listening on ':8081')"
2020-02-16 02:45:39,930 INFO exited: jwtproxy (exit status 0; not expected)

# solution
option1
docker-compose  -f docker-compose.quay-pgsql.yml stop
docker-compose  -f docker-compose.quay-pgsql.yml rm -f
docker-compose  -f docker-compose.quay-pgsql.yml up -d

option2
docker exec -it quay sh -c "ss -ntpul |grep proxy"
docker exec -it quay sh -c "rm /tmp/jwtproxy_secscan.sock"
docker restart quay

2. Issue2
2020-02-16 02:33:42,355 INFO spawned: 'jwtproxy' with pid 126
time="2020-02-16T02:33:42Z" level=info msg="No claims verifiers specified, upstream should be configured to verify authorization"
time="2020-02-16T02:33:42Z" level=info msg="Starting reverse proxy (Listening on ':6060')"
time="2020-02-16T02:33:42Z" level=fatal msg="Got unexpected response from key server: 502: <html>

# solution
docker restart clair

3. Issue3
time="2020-02-16T09:45:59Z" level=fatal msg="pinging docker registry returned: Get https://quay02.test.com/v2/: x509: certificate signed by unknown authority"

# solution
cp mirror Quay's ca.crt  /quay/config/extra_ca_certs/
docker restart worker
```
