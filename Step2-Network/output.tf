output "VpnGatewayPublicIps" {
    description = "The public IP addresses of the Google VPN gateway"
    value       = google_compute_vpn_gateway.main.self_link
}

output "VpnGatewayStaticIp" {
    description = "The static public IP address of the Google VPN gateway"
    value       = google_compute_address.VpnGatewayStaticIp.address
}