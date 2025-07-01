# resource "google_compute_vpn_gateway" "main" {
#     name    = "s2s-vpn-gateway"
#     network = var.network
#     region  = var.region
# }



# resource "google_compute_vpn_tunnel" "main" {
#     name                    = "s2s-vpn-tunnel"
#     region                  = var.region
#     target_vpn_gateway      = google_compute_vpn_gateway.main.id
#     peer_ip                 = var.peer_ip
#     shared_secret           = var.shared_secret
#     ike_version             = 2
#     local_traffic_selector  = var.local_traffic_selector
#     remote_traffic_selector = var.remote_traffic_selector
    
#     ike_config {
#         encryption_algorithm = "AES_256"   # Options: "AES_128", "AES_192", "AES_256"
#         integrity_algorithm  = "SHA256"    # Options: "SHA1", "SHA256", "SHA384", "SHA512"
#         dh_group_number      = 14          # Options: 2, 5, 14, 15, 16, 19, 20, 21, 24
#     }

#     # Optional: Add multiple ike_config blocks for proposals (if supported by provider)
#     # ike_config {
#     #   encryption_algorithm = "AES_128"
#     #   integrity_algorithm  = "SHA1"
#     #   dh_group_number      = 2
#     # }

#     # Optional: Specify detailed IPsec config (if supported)
#     ipsec_config {
#         encryption_algorithm = "AES_256"   # Options: "AES_128", "AES_192", "AES_256"
#         integrity_algorithm  = "SHA256"    # Options: "SHA1", "SHA256", "SHA384", "SHA512"
#         pfs_dh_group_number  = 14          # Options: 2, 5, 14, 15, 16, 19, 20, 21, 24
#     }
# }
