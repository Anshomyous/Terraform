  // Creating security groups
    resource "aws_security_group" "dev-vpc-sg" {
      name = "dev-vpc-sg"
      vpc_id = var.vpc_id 

      ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.ip_adress]
      }
      ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.ip_adress]
      }
       ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.ip_adress]
      }
      egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.ip_adress]
        prefix_list_ids = []
      }
      tags = {
        Name = "dev-vpc-sg"
      }
}

data "aws_ami" "dev-latest-ami"{
  most_recent = true 
  owners = ["amazon"]
  filter{
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220912"]
  }
}
resource "aws_key_pair" "devKey"{
  key_name = "devKey"
  public_key = file(var.pub_key_location)
}

/* output "aws_ami_id" {
  value = data.aws_ami.dev-latest-ami.id
} */

 resource "aws_instance" "dev-instance"{
  ami = data.aws_ami.dev-latest-ami.id
  instance_type = var.instance_type


  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.dev-vpc-sg.id]
  availability_zone = var.avl_zone


  associate_public_ip_address = true
  key_name = "devKey"

  user_data = <<EOF
            apt-get -y update && apt-get -y upgrade 
            sudo apt install -y docker 
            sudo systemctl start docker
            sudo usermod -aG docker ubuntu
            docker run -p 8080:80 nginx
            EOF
    tags = {
      Name = "dev-instance"
    }
} 