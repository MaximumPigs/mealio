locals {
  mealio_hostname = "mealio"
}

resource "aws_instance" "ssh_proxy" {
  ami           = "ami-02e9625c5bc9a2d34"
  instance_type = "t4g.nano"

  tags = {
    Project   = "maximumpigs_aws_fabric"
    ManagedBy = "Terraform"
    Name      = local.mealio_hostname
  }

  associate_public_ip_address = true

  key_name = "MaximumPigs_Key_Pair"

  subnet_id = module.maximumpigs_fabric.subnet_public_id

  user_data_base64 = base64encode(templatefile("cloudinit/userdata.tmpl", {
    hostname = "${local.mealio_hostname}",
    domain = "${module.maximumpigs_fabric.route53_private_name}" }))
}

resource "aws_route53_record" "priv_sshproxy" {
  zone_id = module.maximumpigs_fabric.route53_private_id
  name    = "${local.mealio_hostname}.aws.maximumpigs.com"
  type    = "A"
  ttl     = 300
  records = [aws_instance.ssh_proxy.private_ip]
}

resource "aws_route53_record" "pub_sshproxy" {
  zone_id = module.maximumpigs_fabric.route53_public_id
  name    = "${local.mealio_hostname}.aws.maximumpigs.com"
  type    = "A"
  ttl     = 300
  records = [aws_instance.ssh_proxy.public_ip]
}