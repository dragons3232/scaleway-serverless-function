#!/bin/bash
set -e

#read nats url from terraform output
SCW_NATS_URL=$(terraform output nats_url)

#trim redundant quotes
SCW_NATS_URL=$(echo $SCW_NATS_URL | tr -d '"')
echo $SCW_NATS_URL

# Nats context creation and selection
nats context save hello --server=$SCW_NATS_URL --creds=./nats.creds
nats context select hello

# Send test data in NATS
nats pub hello-nats "{\"name\":\"Long\",\"message\":\"Hi!\"}"
nats req hello-nats "{\"name\":\"Long\",\"message\":\"Hi!\"}"