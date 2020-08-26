# -- Creating EC2 instance

resource "aws_instance" "web_server" {
    ami                       = "ami-02354e95b39ca8dec"
    instance_type             = "t3.micro"
    root_block_device {
        volume_type           = "gp2"
        delete_on_termination = true
    }
    key_name                  = "tf-testing"
    security_groups           = [ "${aws_security_group.sg.name}" ]

    connection {
        type                  = "ssh"
        user                  = "ec2-user"
        private_key           = file("~/.ssh/tf-testing.pem")
        host                  = aws_instance.web_server.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum install httpd git -y",
            "sudo systemctl restart httpd",
            "sudo systemctl enable httpd",
        ]
    }

    tags = {
        Name = "task2_os"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo su <<END",
            "echo \"<img src='http://aws_cloudfront_distribution.s3_distribution.domain_name/${aws_s3_bucket_object.file_upload.key}' height='1000' width='250'>\" >> /var/www/html/index.html",
            "END",
        ]
    }
}

# -- Starting chrome for output
#resource "null_resource" "nulllocal1"  {
# depends_on = [
#      null_resource.nullremote3,
#   ]
#provisioner "local-exec" {
#     command = "start chrome ${aws_instance.web_server.public_ip}/index.html"
#   }
#}