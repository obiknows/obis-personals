#!/bin/bash
set -e

# build the docker file to obiknows/personal-site
docker build --rm -f Dockerfile -t obiknows/personal-site:latest .