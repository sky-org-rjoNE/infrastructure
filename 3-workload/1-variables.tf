variable "backstage_ec2" {
  default = {
    name              = "backstage"
    ami               = "ami-03caf91bb3d81b843"
    instance_type     = "t2.medium"
    availability_zone = "ap-southeast-1a"
    subnet_id         = ""
    security_group = {
      name                = "backstage-sg"
      description         = "This is backstage sg"
      ingress_cidr_blocks = ["0.0.0.0/0"]
      ingress_rules       = ["http-80-tcp", "all-icmp"]
      egress_rules        = ["all-all"]
      tags = {
        name = "backstage"
      }
    }
    root_block_device = [
      {
        encrypted   = true
        volume_type = "gp3"
        throughput  = 200
        volume_size = 50
        tags = {
          Name = "root-block"
        }
      }
    ]
    network = {
      bucket = "backstage-archive"
      key    = "states/2-network/terraform.tfstate"
      region = "ap-southeast-1"
    }
    user_data = <<EOF
      #!/bin/bash
      curl -fsSL https://get.docker.com |VERSION=19.03.6 sh
      chmod 777 /var/run/docker.sock
      curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
      echo "export PATH=\$PATH:/snap/google-cloud-sdk/current/bin" >> /etc/profile
      echo "export LD_LIBRARY_PATH=/usr/bin/openssl" >> /etc/profi
EOF
  }
}
