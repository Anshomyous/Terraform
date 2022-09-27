resource "aws_subnet" "myapp_subnet-public" {
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avl_zone
        tags ={
            Name = "dev_subnet"
        }
    }

resource "aws_internet_gateway" "myapp_igw"{
  vpc_id = var.vpc_id

    tags = {
      Name = "dev-igw"
    }
}

/* resource "aws_route_table" "myapp_rtb"{
    vpc_id = aws_vpc.myapp_vpc.id

    route{
      cidr_block = "0.0.0.0/24"
      gateway_id = aws_internet_gateway.myapp_igw.id
          }
      tags = {
        Name = "dev-rtb"
      } */
    resource "aws_default_route_table" "main-rtb" {

      default_route_table_id = var.rt_id
      
      route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp_igw.id
      }
        tags = {
            Name = "dev-rtb"
    }
  }
