
######################### VPC Creation #########################################


resource "aws_vpc" "Project-main-vpc" {

     cidr_block = "10.0.0.0/16"
     enable_dns_support = true
     enable_dns_hostnames = true

     tags = {

        Name = "Project-vpc"
     }

}

############################ Subnet Creation #################################


resource "aws_subnet" "main-subnet" {
       
       vpc_id = aws_vpc.Project-main-vpc.id
       cidr_block = "10.0.1.0/24"
       availability_zone = "ap-south-1a"
       map_public_ip_on_launch = true

       tags = {
    Name = "Project-main-subnet"
  }
   
}

########################### IG Creation ######################################

resource "aws_internet_gateway" "main-igw" {

        vpc_id = aws_vpc.Project-main-vpc.id

        tags = {

            Name = "Project-IG"
        }
}

############################ Route Table + Association ####################################

resource "aws_route_table" "main-rt" {

     vpc_id = aws_vpc.Project-main-vpc.id

     route {

           cidr_block = "0.0.0.0/0"
           gateway_id = aws_internet_gateway.main-igw.id
     }

     tags = {

        Name = "Project-RT"
     }
} 

resource "aws_route_table_association" "main-rta" {

    subnet_id = aws_subnet.main-subnet.id
    route_table_id = aws_route_table.main-rt.id
}


###################### Security Group #############################

resource "aws_security_group" "main-SG" {

    description = "SG for main VPC"
    vpc_id = aws_vpc.Project-main-vpc.id


    ingress {
        
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        
        from_port = 9000
        to_port = 9000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {

        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
}