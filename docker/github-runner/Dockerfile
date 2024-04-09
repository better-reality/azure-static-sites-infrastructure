# Use an official Debian runtime as a parent image
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update -y && apt-get install -y curl unzip

# Set work directory
WORKDIR /app

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Terraform
RUN curl https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip --output terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin \
    && rm terraform.zip

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*