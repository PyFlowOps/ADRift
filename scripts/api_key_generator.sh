#!/usr/bin/env bash

# Generate a random API key
api_keygen="us.adrift-$(LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 32)"
redis_pass="$(LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 32)"


if [ -f ../sre_portal/.redis ]; then
  rm ../adrift/.redis
fi

echo "ADRIFT_API_KEY=${api_keygen}" > ../adrift/.api_key
