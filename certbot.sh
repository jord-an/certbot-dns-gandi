#!/usr/bin/env sh
set -e
echo Setting GANDI_API_TOKEN environment variable to /app/gandi.ini
echo dns_gandi_token=$GANDI_API_TOKEN > /app/gandi.ini
chmod 600 /app/gandi.ini
echo Running Certbot with params "$@"
certbot "$@"