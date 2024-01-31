#!/bin/bash

# Destroy the Terraform-managed infrastructure.

Terraform destroy -auto-approve

# creates a file called holiday.pem in the holiday directory

touch holiday.pem