# "Depok": Nginx with Brotli

## Description

As a devops engineer, you're tasked to add compression to the company website, actually a gaming shop. The website is running on an Nginx server, and you decide to add Brotli compression to it.

Brotli has became very popular these days because of its high compression ratio. It's a generic-purpose lossless compression algorithm that compresses data using a combination of a modern variant of the LZ77 algorithm, Huffman coding, and 2nd order context modeling.

For this purpose, you decided to compile the brotli modules yourself and add them to the Nginx server.

The location of the Brotli source code is at `/home/admin/ngx_brotli`, and nginx source code, which is needed to compile the modules, is located at `/home/admin/nginx-1.18.0`. You've seen from the official ngx_brotli repository that first you need to compile the brotli dependencies and then configure and make modules for Nginx, once you've done that, you need to add the modules to the Nginx configuration.

After installing the modules, you need to make sure the responses from the server are being served with compression.

Create a port-forward to port 80 from the server and check the header `Content-Encoding`, responses must return `br` for Brotli compression.

You could also use `curl -H "Accept-Encoding: br, gzip" -I http://localhost` to check the header.

PD: something nice about Brotli is that it fails over to gzip if the client doesn't support Brotli, so `curl -H "Accept-Encoding: gzip" -I http://localhost` should return gzip instead.

## Test

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

http_res_enc=$(curl -H "Accept-Encoding: br" -sI http://localhost | grep "Content-Encoding" | awk '{print $2}' | tr -d '\r\n')

# Compare the computed hashes with the expected values
if [ "$http_res_enc" == "br" ];
then
    echo -n "OK"
else
    echo -n "NO"
fi
```

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.
