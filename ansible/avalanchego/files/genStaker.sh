#!/bin/sh
set -ex

openssl genrsa -out `dirname "$0"`/../../../assets/cert_keys/staker.key 4096
openssl req -new -sha256 -key `dirname "$0"`/../../../assets/cert_keys/staker.key -subj "/C=US/ST=MD/O=Petty Services, LLC" -out `dirname "$0"`/../../../assets/cert_keys/staker.csr
openssl x509 -req -in `dirname "$0"`/../../../assets/cert_keys/staker.csr -CA `dirname "$0"`/../../../assets/cert_keys/rootCA.crt -CAkey `dirname "$0"`/../../../assets/cert_keys/rootCA.key -CAcreateserial -out `dirname "$0"`/../../../assets/cert_keys/staker.crt -days 365250 -sha256
