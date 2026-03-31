ProjectID="<YOUR PROJECT ID>"
Region="<YOUR GOOGLE REGION>"
# Network : VPC and Subnet settings
VPCName="<YOUR GOOGLE VPC NAME>"
ClusterManagementSubnetCidr="172.20.0.0/16"    #CHANGE WITH YOUR CIDR
NATSubnetCidr="172.21.0.0/16"                  #CHANGE WITH YOUR CIDR
NoNATSubnetCidr="172.22.0.0/16"                #CHANGE WITH YOUR CIDR
JumpboxSubnetCidr = "172.23.0.0/16"            #CHANGE WITH YOUR CIDR
### VPN Site-to-Site settings (here Cloud VPN Classic)
VpnGatewayName="<YOUR VPN GATEWAY NAME>"
VpnTunnelName="<YOUR VPN TUNNEL NAME>"
PeerIp="90.3.91.214"  # CHANGE WITH YOUR PUBLIC IP OF AN ON PREM VPN GATEWAY
SharedSecret="<YOUR SHARED SECRET>" # Shared secret for VPN tunnel
LocalTrafficSelector=["172.20.0.0/14"]    #CHANGE WITH YOUR CIDR  (GOOGLE VPCs CIDRs)
RemoteTrafficSelector=["10.0.0.0/8"]      #CHANGE WITH YOUR CIDR  (ON PREM CIDRs)
IkeVersion=2
IkeEncryptionAlgorithm="AES_256"
IkeIntegrityAlgorithm="SHA256"
IkeDhGroupNumber=14
IpsecEncryptionAlgorithm="AES_256"
IpsecIntegrityAlgorithm="SHA256"
IpsecPfsDhGroupNumber=14
#### Jumpbox VM settings
EnableJumbox=0  # Set to 1 to enable Jumbox VM instance, 0 to disable
VmZone = "<YOUR GOOGLE REGION>"  # Zone for the Jumbox VM instance
