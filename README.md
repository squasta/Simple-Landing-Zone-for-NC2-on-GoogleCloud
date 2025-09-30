# Simple-Landing-Zone-for-NC2-on-GoogleCloud
This is a simple landing zone for Nutanix Cloud Clusters on Google Cloud Platform

This repo contains terraform code to deploy a **simple network landing zone for Nutanix Cloud Cluster (NC2) on Google Cloud with a VPN site to site connection to On-premises Datacenter** (using a Google Cloud Classic VPN)

<img width='400' src='./images/PlaneLZGoogle.png'/> 


## Prerequisites

- Of course a VPN Gateway running on premises (or on a public cloud platform)
- All prerequisites for NC2 : URL-TBD
- More information about NC2 on GCP : URL-TBD

- An Google Project with enough privileges (create Role, ...)
- Google Cloud CLI x.x. or > : https://cloud.google.com/sdk/docs/install-sdk 
    - [how to configure Google Cloud CLI with your project](https://cloud.google.com/sdk/docs/install-sdk#initializing_the)
- Terraform CLI 1.13 or > : <https://www.terraform.io/downloads.html>
    - [Best practices for using the Terraform Google Cloud Provider](https://cloud.google.com/docs/terraform/best-practices/general-style-structure)

You can also clone this repo in your [Google Cloud Shell](https://cloud.google.com/shell/docs) and [use terraform in your cloud shell](https://cloud.google.com/docs/terraform/install-configure-terraform).

For additional information about creating manually your ressources on Google Cloud for Nutanix Cloud Cluster : URL-TBD



# Step 1 - Service accounts and custom roles


# Step 2 - Networking (will include CLoud VPN deployment)
