#!/bin/bash

set -e

domains=(canary-v2.aqaryint.net)
rsa_key_size=4096
data_path="./certbot"
email="saif@aqaryint.com"
staging=0 # I will Set this to 1 in testing to avoid hitting request limits

echo "### Preparing directories..."
mkdir -p "$data_path/conf/live/$domains"
mkdir -p "$data_path/www"

echo "### Creating dummy certificate..."
openssl req -x509 -nodes -newkey rsa:$rsa_key_size -days 1\
  -keyout "$data_path/conf/live/$domains/privkey.pem" \
  -out "$data_path/conf/live/$domains/fullchain.pem" \
  -subj '/CN=localhost'

echo "### Starting nginx..."
docker-compose -f docker-compose-staging.yaml up --force-recreate -d nginx

echo "### Requesting Let's Encrypt certificate..."
#Join $domains to -d args
domain_args=""
for domain in "${domains[@]}"; do
  domain_args="$domain_args -d $domain"
done

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then staging_arg="--staging"; fi

docker-compose -f docker-compose-staging.yaml run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal \
    --verbose" certbot

echo "### Reloading nginx..."
docker-compose -f docker-compose-staging.yaml exec nginx nginx -s reload

echo "### Displaying certificate info..."
docker-compose -f docker-compose-staging.yaml run --rm --entrypoint "\
  certbot certificates" certbot