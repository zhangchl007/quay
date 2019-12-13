# docker-compose for redhat quay 
```
1. sh pre-quaydeploy.sh
2. docker-compose  -f docker-compose.config.yml  up -d
username/password: quayconfig/redhat
sudo mv quay-config.tar.gz  /quay/config
tar -zxvf quay-config.tar.gz
3. sh ./pre-deleteconfig.sh
4. docker-compose  -f docker-compose.config.yml stop
5. docker-compose  -f docker-compose.quay.yml up -d

```
