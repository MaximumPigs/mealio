output "private_fqdn" {
  value = module.ec2.dns_priv_fqdn
}

output "public_fqdn" {
  value = module.ec2.public_dns
}