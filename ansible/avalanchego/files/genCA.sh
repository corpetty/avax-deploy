#!/bin/sh
set -ex

openssl genrsa -out `dirname "$0"`/../../../assets/cert_keys/rootCA.key 4096
openssl req -x509 -new -nodes -key `dirname "$0"`/../../../assets/cert_keys/rootCA.key -sha256 -days 365250 -out `dirname "$0"`/../../../assets/cert_keys/rootCA.crt
