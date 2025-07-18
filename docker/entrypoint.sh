#!/usr/bin/env bash

set -eo pipefail

project="adrift"
entrypoint="app.py"

# Check if the required environment variables are set
: "${PORT:?PORT is not set}"
: "${HOST:?HOST is not set}"

python -m streamlit run "${project}/${entrypoint}"
