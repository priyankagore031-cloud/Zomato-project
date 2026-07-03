resource "aws_instance" "main-ec2"{

    ami = "ami-006f82a1d5a27da54"
    instance_type = "t3.large"
    key_name =  "ec2-access-key"
    subnet_id = aws_subnet.main-subnet.id
    vpc_security_group_ids = [aws_security_group.main-SG.id]
    associate_public_ip_address = true
    user_data = templatefile ("./resource.sh", {})


    tags = {

        Name = "Jenkins-server"
    }

     root_block_device {
    volume_size = 29
  }
}

