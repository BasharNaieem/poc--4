provider "aws" {
  region = "ap-south-1"  # Specify your AWS region
}

# Security Group Module
module "web_sg" {
  source      = "./modules/security_group"
  name_prefix = "web-sg"

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Allow SonarQube access
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Allow Apache access
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Allow Jenkins access
    }
  ]
}

# EC2 Module for SonarQube Instance
module "sonarqube_instance" {
  source          = "./modules/ec2"
  ami             = "ami-0ce7284abdf86311f"
  instance_type   = "t2.medium"
  key_name        = "bashar-poc3"
  security_group  = module.web_sg.id
  instance_name   = "SonarQube-ser Instance"
  ansible_playbook  = "sonarqube.yml"
  private_key_path  = "/home/bashar/poc3/modules/ec2/bashar-poc3.pem"
}

# EC2 Module for Apache Instance
module "apache_instance" {
  source          = "./modules/ec2"
  ami             = "ami-0ce7284abdf86311f"
  instance_type   = "t2.micro"
  key_name        = "bashar-poc3"
  security_group  = module.web_sg.id
  instance_name   = "Apache-ser Instance"
  ansible_playbook  = "apache.yml"
  private_key_path  = "/home/bashar/poc3/modules/ec2/bashar-poc3.pem"
}

# EC2 Module for Jenkins Instance
module "jenkins_instance" {
  source          = "./modules/ec2"
  ami             = "ami-0ce7284abdf86311f"
  instance_type   = "t2.medium"
  key_name        = "bashar-poc3"
  security_group  = module.web_sg.id
  instance_name   = "Jenkins-ser Instance"
  ansible_playbook  = "jenkins.yml"
  private_key_path  = "/home/bashar/poc3/modules/ec2/bashar-poc3.pem"
}
