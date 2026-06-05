# "Campina Grande": Give me my cert, Vault

## Description

A web application running at <i>https://nginx.example.com</i> has an expired certificate. Issue a new certificate using the Hashicorp Vault running on the server.<br> The Vault instance is already unsealed and initialized, and you have full admin access with the <i>admin</i> user.

## Test

Running <kbd>curl https://nginx.example.com</kbd> returns <i>Hello!</i>.
<br><br>
The certificate presented by Nginx is issued by the Vault PKI (check using <kbd>openssl verify -CAfile /usr/local/share/ca-certificates/vault-pki-ca.crt /etc/nginx/ssl/cert.pem</kbd>).
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

CERT="/etc/nginx/ssl/cert.pem"
VAULT_CA="/usr/local/share/ca-certificates/vault-pki-ca.crt"
NGINX_URL="https://nginx.example.com"

SOLVED=0

if [ -f "$CERT" ] && [ -f "$VAULT_CA" ]; then
    if openssl x509 -checkend 0 -noout -in "$CERT" >/dev/null 2>&1; then
        if openssl verify -CAfile "$VAULT_CA" "$CERT" 2>/dev/null | grep -q ": OK"; then
            RESPONSE=$(curl -s -k "$NGINX_URL")
            if [ "$RESPONSE" = "Hello!" ]; then
                SOLVED=1
            fi
        fi
    fi
fi

if [[ $SOLVED -eq 1 ]]; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
