#!/bin/bash -e
 
PROJECT="$(basename `pwd`)"
BUCKET="jdavis-sandbox-terraform-state"

REPO_ROOT_DIR="$(dirname $(readlink -f $0))"
 
init() {
  if [ -d .terraform ]; then
    if [ -e .terraform/terraform.tfstate ]; then
      echo "Remote state already exist!"
      if [ -z $IGNORE_INIT ]; then
        exit 1
      fi
    fi
  fi
 
 
  terraform remote config \
    -backend=s3 \
    -backend-config="bucket=${BUCKET}" \
    -backend-config="key=${PROJECT}/terraform.tfstate" \
    -backend-config="region=us-east-1"
}
 
while getopts "i" opt; do
  case "$opt" in
    i)
      IGNORE_INIT="true"
      ;;
  esac
done
 
shift $((OPTIND-1))

# TODO: replace with IAM/Vault/etc.
source "${REPO_ROOT_DIR}/creds/${PROJECT}-aws-creds.sh"

init
