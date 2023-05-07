provider "aws" {
  //variables a cambiar en vars.tf
  //son las credenciales de acceso a nuestro AWS
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}
resource "aws_vpc" "VPC_IRAC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC_EC2_IRAC"
  }
}

resource "aws_subnet" "subnet_IRAC" {
  cidr_block = "10.0.1.0/24"
  vpc_id = "${aws_vpc.VPC_IRAC.id}"
  tags = {
    Name = "Subnet_EC2_IRAC"
  }
}

resource "aws_internet_gateway" "IG_IRAC" {
  vpc_id = "${aws_vpc.VPC_IRAC.id}"
  tags = {
    Name = "GW_EC2_IRAC"
  }
}

resource "aws_route_table" "RT_IRAC" {
  vpc_id = "${aws_vpc.VPC_IRAC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IG_IRAC.id}"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = "${aws_subnet.subnet_IRAC.id}"
  route_table_id = "${aws_route_table.RT_IRAC.id}"
}

resource "aws_security_group" "SG_IRAC" {
  vpc_id = "${aws_vpc.VPC_IRAC.id}"
  name = "SecurityGroup_EC2_IRAC"

//puertos a abrir en la EC2
//SSH
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    to_port     = "22"
  }
//Apache
    ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    to_port     = "80"
  }
//RDP
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "3389"
    to_port     = "3389"
  }
//Trafico saliente
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    to_port     = "0"
  }

}

resource "aws_network_interface" "NI_IRAC" {
   subnet_id       = aws_subnet.subnet_IRAC.id
   private_ips     = ["10.0.1.60"]
   security_groups = [aws_security_group.SG_IRAC.id]

 }

 resource "aws_eip" "EIP_IRAC" {
   vpc                       = true
   network_interface         = aws_network_interface.NI_IRAC.id
   associate_with_private_ip = "10.0.1.60"
   depends_on                = [aws_internet_gateway.IG_IRAC]
 }


resource "aws_instance" "IRAC" {
    
    instance_type = "t2.medium"
    ami = "${var.ami}"
    key_name = "${var.key_pair}"
    network_interface {
     device_index         = 0
     network_interface_id = aws_network_interface.NI_IRAC.id
   }
   //codigo que se ejecutara nada mas crear la instancia
   //para descargarnos las dependencias necesarias
        user_data = <<-EOF
        sudo apt update
        sudo apt install mysql-server wget git apache2 php php-mysqli -y
        sudo mv 20-mysqli.ini /etc/php/8.1/apache2/conf.d/
        sudo service mysql start
        sudo rm -r /var/www/html/*
        wget https://www.bok.net/Bento4/binaries/Bento4-SDK-1-6-0-639.x86_64-unknown-linux.zip
        unzip Bento4-SDK-1-6-0-639.x86_64-unknown-linux.zip
        git clone https://github.com/Jaime-am/IRAC_3
        chmod +x IRAC_3/setup.sh && bash IRAC_3/setup.sh
        EOF

    tags = {
        name = "EC2_IRAC"
    }
}