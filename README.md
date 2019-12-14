# docker-compose for redhat quay 
```
Add new environment varible "ENCRYPTED_ROBOT_TOKEN_MIGRATION_PHASE=new-installation" to support quay develement 

If it's quay enterprise, you can remove the environment varible from docker-compose yaml file

# generate self certification 
self-cert-generate.sh test.com quay01.test.com

# Deploy Quay
#create Directory for Quay
1. sh pre-quaydeploy.sh

# generate the config file

2. docker-compose  -f docker-compose.config.yml  up -d
username/password: quayconfig/redhat
sudo mv quay-config.tar.gz  /quay/config
cd /quay/config && tar -zxvf quay-config.tar.gz

#delete quayconfig container
3. sh ./pre-deleteconfig.sh

#stop redis and mysql and start quay

4. docker-compose  -f docker-compose.config.yml stop
5. docker-compose  -f docker-compose.quay.yml up -d

#clear Quay
sh clear-quay.sh

```
