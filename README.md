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

NC2 on Google Cloud requires 2 Services Accounts with specifics permissions :
- one to be used by NC2 Portal (aka MCM)
    - More informations about permissions : UBD-URL
- one to used by GCE Metal instances of the cluster
    - More informations about permissions : UBD-URL



# Step 2 - Networking (will include Cloud VPN deployment)

## Landing Zone architecture(s)

This landing zone is designed for an NC2 on Google Cloud with **Nutanix Flow Networking** and a VPN Site to Site connexion with on premises (or other cloud) network.

<img width='800' src='./images/NC2-AWS-S2S-TGW.png'/>  

IP ranges and **all variables** can be defined/customized by editing [example-configuration.tfvars](example-configuration.tfvars). Then rename example-configuration.tfvars to configuration.tfvars

This landing zone also include the option to have a dedicated private subnet and a virtual machine to use as a jumbox. All Google Cloud resources related to Jumbox are in [jumbox.tf](jumbox.tf) file.
