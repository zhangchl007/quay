#!/bin/bash
#CA
Sub_make_ca() {
openssl genrsa -out ca.key 4096
openssl req -newkey rsa:4096 -nodes -sha256 -keyout ca.key -x509 -days 365 -out ca.crt

# Domain crt
openssl genrsa -out $1.key 4096
openssl req -sha512 -new \
    -subj "/C=CN/ST=Shenzhen/L=Shenzhen/O=example/OU=Personal/CN=$1" \
    -key $1.key \
    -out $1.csr 
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth 
subjectAltName = @alt_names
[alt_names]
DNS.1=$1
DNS.2=$2
EOF

openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in $1.csr \
    -out $1.crt
}

if [ $# != 2 ];then
    echo "Please input the right domain name and  hostname!"
    exit 1
elif [ -z $1 ] || [ -z $2 ];then
        echo "Please input the right domain name and  hostname!"
        exit 1
else
   Sub_make_ca $1 $2
   exit 0
fi
