#!/bin/bash

# Generate self-signed certificate for opslab host
cat > san.cnf <<'EOF'
[req]
distinguished_name = dn
x509_extensions = v3_req
prompt = no

[dn]
CN = opslab

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = opslab
DNS.2 = localhost
IP.1 = 127.0.0.1
IP.2 = ::1
EOF

# Generate the certificate and private key
openssl req -x509 -newkey rsa:2048 -sha256 -days 999 -nodes \
  -keyout ./traefik/certs/opslab.key -out ./traefik/certs/opslab.crt -config san.cnf

# Clean up the config file
rm san.cnf

echo "Certificate files generated:"
echo "  Private key: opslab.key"
echo "  Certificate: opslab.crt"
echo ""
echo "To view certificate details:"
echo "  openssl x509 -in opslab.crt -text -noout"
