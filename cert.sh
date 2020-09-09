#! /bin/bash

openssl genrsa -aes256 -passout pass:$1 -out $1.key 2048

openssl req -new -key $1.key -passin pass:$1 -out $1.req -config <(
cat <<-EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_extensions
distinguished_name = dn

[ dn ]
DC=test
DC=local
CN=$1

[ req_extensions ]
subjectAltName = @alter_name

[ alter_name ]
DNS.1 = $1.test.local
EOF
)

ansible-playbook Certificate.yml --ask-pass -e "cert=$1"

cat $1.key $1.cer > $1.pem

