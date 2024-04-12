#!/bin/sh

terraform init \
  -backend-config="resource_group_name=$TF_RESOURCE_GROUP_NAME" \
  -backend-config="storage_account_name=$TF_STORAGE_ACCOUNT_NAME" \
  -backend-config="container_name=$TF_CONTAINER_NAME" \
  -backend-config="key=$TF_BLOB_KEY_NAME"
