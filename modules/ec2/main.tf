
resource "aws_instance" "ec2_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = var.instance_name
  }
  provisioner "remote-exec" {
    inline = [
      "echo Waiting for instance to be accessible...",
      "sleep 60",  # Increase the wait time for instance readiness
      "echo Instance should now be accessible via SSH."
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/home/bashar/poc3/modules/ec2/bashar-poc3.pem")  # Ensure this path is correct in WSL
      host        = self.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' /home/bashar/poc3/ansible-playbooks/${var.ansible_playbook} --private-key /home/bashar/poc3/modules/ec2/bashar-poc3.pem -u ubuntu --ssh-extra-args='-o StrictHostKeyChecking=no'"
  }
}
output "instance_id" {
  value = aws_instance.ec2_instance.id
}

output "public_ip" {
  value = aws_instance.ec2_instance.public_ip  # Output the public IP
}
