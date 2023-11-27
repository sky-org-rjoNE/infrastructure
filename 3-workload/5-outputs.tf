output "backstage_ec2" {
  value = {
    public_ip = module.ec2_backstage.public_ip
    private_ip = module.ec2_backstage.private_ip
  }
}