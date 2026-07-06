resource "aws_instance" "monitoring_server" {


    ami = "ami-01a00762f46d584a1"
    instance_type = "t2.medium"
    key_name = "ec2-access-key"
    subnet_id = aws_subnet.main-subnet.id
    vpc_security_group_ids = [aws_security_group.main-SG.id]



    tags ={

        Name = "monotoring-server"
    }


    root_block_device {

        volume_size = 20
    }
}