# -- Creating EFS volume

resource "aws_efs_file_system" "efs" {
    creation_token   = "efs"
    performance_mode = "generalPurpose"
    throughput_mode  = "bursting"
    encrypted        = "true"
    tags = {
        Name = "Efs"
    }
}

# -- Mounting the EFS volume

resource "aws_efs_mount_target" "efs-mount" {
    depends_on = [
        aws_instance.web_server,
        aws_security_group.sg,
        aws_efs_file_system.efs,
    ]

    file_system_id   = aws_efs_file_system.efs.id
    subnet_id        = aws_instance.web_server.subnet_id
    security_groups  = ["${aws_security_group.sg.id}"]

    connection {
        type         = "ssh"
        user         = "ec2-user"
        private_key  = file("~/.ssh/tf-testing.pem")
        host         = aws_instance.web_server.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "sudo mount ${aws_efs_file_system.efs.id}:/ /var/www/html",
            "sudo echo '${aws_efs_file_system.efs.id}:/ /var/www/html efs defaults,_netdev 0 0' >> /etc/fstab",
            "sudo rm -rf /var/www/html/*",
            "sudo git clone https://github.com/satvikakolisetty/cloudtask2.git /var/www/html"
        ]
    }
}