locals {
  mealio_hostname = "mealio"
}

module "ec2" {
  source = "./.terraform/modules/maximumpigs_fabric/ec2"

  name = local.mealio_hostname

  ami           = "ami-02e9625c5bc9a2d34"
  instance_type = "t4g.nano"

  tags = {
    Project   = "maximumpigs_aws_fabric"
    ManagedBy = "Terraform"
  }

  associate_public_ip_address = true

  key_name = "MaximumPigs_Key_Pair"

  subnet_id = module.maximumpigs_fabric.subnet_public_id

  dns_pub_zone_name = module.maximumpigs_fabric.route53_public_name
  dns_priv_zone_name = module.maximumpigs_fabric.route53_private_name

  user_data_base64 = base64encode(templatefile("cloudinit/userdata.tmpl", {
    hostname = "${local.mealio_hostname}",
    domain = "${module.maximumpigs_fabric.route53_private_name}" }))
}