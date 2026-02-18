    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -a -G docker ec2-user
    sudo docker pull rohinigajakosh/my-terraform-app:v2
    sudo docker run -d -p 80:80 rohinigajakosh/my-terraform-app:v2