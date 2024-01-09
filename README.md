# certbot-dns-gandi
A dockerized plugin for Certbot which allows for the generation of Let's Encrypt certificates using a DNS Challenge with GANDI DNS.


## How to use

1. Using this git repo:
````
git clone https://
docker build . -t certbot-dns-gandi:latest
docker run --rm -v "/etc/letsencrypt:/etc/letsencrypt" -e GANDI_API_TOKEN=123456abcd certbot-dns-gandi:latest certonly -a certbot-plugin-gandi:dns --agree-tos -m email@example.com --non-interactive --authenticator dns-gandi --dns-gandi-credentials /app/gandi.ini -d example.com -d *.example.com
````

2. Using the docker image on Docker Hub:
```
docker run --rm -v "/etc/letsencrypt:/etc/letsencrypt" -e GANDI_API_TOKEN=123456abcd emerstream/certbot-dns-gandi:latest certonly -a certbot-plugin-gandi:dns --agree-tos -m email@example.com --non-interactive --authenticator dns-gandi --dns-gandi-credentials /app/gandi.ini -d example.com -d *.example.com
```

## Docker Run Explained

- `docker run --rm`

	Run docker and remove it when the container has finished.


- `-v "/etc/letsencrypt:/etc/letsencrypt"`

	Mount the local volume `/etc/letsencypt` to the same inside the docker container

- `-e GANDI_API_TOKEN=123456abcd `

	Add the `GANDI_API_TOKEN` environment variable to the container. This is used by the entrypoint and passed into Certbot to access your Gandi account.

	NOTE: Replace "123456abcd" with your TOKEN generated below. 


- `emerstream/certbot-dns-gandi:latest` or `certbot-dns-gandi:latest`

	The first option uses our hosted version on Docker Hub, the latter uses a locally build version of this repo. This tells the docker daemon which image to run.


- The following are Certbot flags:

	`certonly -a certbot-plugin-gandi:dns --agree-tos -m email@example.com --non-interactive --authenticator dns-gandi --dns-gandi-credentials /app/gandi.ini`



- `-d example.com -d *.example.com`

	Specify which domains to generate certificates for. Each domain should begin `-d`


Certificates and Let's Encrypt account data will be stored in `/etc/letsencrypt`. This is the default location for certificates


## Installation of Certificates

This will need to be done manually due to different variations of set up. Certbot will create the following files:

`/etc/letsencrypt/live/example.com/cert.pem`
`/etc/letsencrypt/live/example.com/chain.pem`
`/etc/letsencrypt/live/example.com/fullchain.pem`
`/etc/letsencrypt/live/example.com/privkey.pem`

Create a vhost within your server configuration. Example for Apache:

```
## Create a non-ssl (port 80) vhost to redirect to SSL
<VirtualHost *:80>
   ServerName example.com
   RewriteEngine On
   RewriteCond %{HTTPS} off
   RewriteRule ^ https://%{HTTP:Host}%{REQUEST_URI} [L,R=permanent]
</VirtualHost>

<VirtualHost *:443>
    ServerName example.com
    ServerAlias *.example.com
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/example.com/cert.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/example.com/privkey.pem
    SSLCertificateChainFile /etc/letsencrypt/live/example.com/fullchain.pem
</VirtualHost>
```


## Related projects

- https://github.com/obynio/certbot-plugin-gandi
- https://hub.docker.com/r/certbot/certbot/dockerfile
- https://github.com/certbot/certbot
- https://letsencrypt.org/
- https://community.letsencrypt.org/t/acme-v2-production-environment-wildcards/55578

