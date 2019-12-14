# docker-compose for redhat quay 
```
Add new environment varible "ENCRYPTED_ROBOT_TOKEN_MIGRATION_PHASE=new-installation"
to support quay development. If it's quay enterprise, you can remove the 
environment varible from docker-compose yaml file, Please refer to the doc below
https://github.com/quay/quay/blob/master/docs/development-container.md

# generate self certification 
self-cert-generate.sh test.com quay01.test.com

# Deploy Quay
# create Directory for Quay
sudo sh pre-quaydeploy.sh

# create the quayconfig container
sudo docker-compose  -f docker-compose.config.yml  up -d

# generate config file via web GUI
username/password: quayconfig/redhat
sudo mv quay-config.tar.gz  /quay/config
cd /quay/config && tar -zxvf quay-config.tar.gz

# delete the quayconfig container
sudo sh ./pre-deleteconfig.sh

# stop redis and mysql
sudo docker-compose  -f docker-compose.config.yml stop

# start mysql, redis and quay
sudo docker-compose  -f docker-compose.quay.yml up -d

# clean up Quay
sh clear-quay.sh

```
