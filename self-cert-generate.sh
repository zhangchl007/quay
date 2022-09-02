#!/bin/bash
cert_c="CN"                 # Country Name (C, 2 letter code)
cert_s="Guang Dong"         # Certificate State (S)
cert_l="Shen Zhen"          # Certificate Locality (L)
cert_o="E-LEAD"                # Certificate Organization (O)
cert_ou="Cloud BU"          # Certificate Organizational Unit (OU)
certca_cn="cloudinfraz"   # Certificate Common Name (CN)

Sub_make_ca() {
openssl genrsa -out ca.key 4096
openssl req -newkey rsa:4096 -nodes -sha256 -keyout ca.key -x509 -days 7300 -out ca.crt \
-subj "/C=${cert_c}/ST=${cert_s}/L=${cert_l}/O=${cert_o}/OU=${cert_ou}/CN=${certca_cn}"
}

Sub_make_cert() {

# Domain crt
openssl genrsa -out $1.key 4096
openssl req -sha512 -new \
    -subj "/C=${cert_c}/ST=${cert_s}/L=${cert_l}/O=${cert_o}/OU=${cert_ou}/CN=$1" \
    -key $1.key \
    -out $1.csr
cat > v3_$1.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1=$1
DNS.2=$2
EOF

openssl x509 -req -sha512 -days 7300 \
    -extfile v3_$1.ext \
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
elif [ -f "ca.crt" ]; then
   Sub_make_cert $1 $2
else
   Sub_make_ca
   Sub_make_cert $1 $2
   exit 0
fi
