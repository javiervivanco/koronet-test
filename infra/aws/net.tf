

data "aws_availability_zones" "available" {}


resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "main-vpc"
    }
}


resource "aws_subnet" "public" {
    count             = 2
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.${count.index}.0/24"
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "public-subnet-${count.index + 1}"
    }
}


resource "aws_security_group" "eks_cluster" {
    name        = "eks-cluster-sg"
    description = "Security group for EKS cluster"
    vpc_id      = aws_vpc.main.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "eks-cluster-sg"
    }
}



resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
    Name = "main-igw"
    }
}


resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
    }

    tags = {
    Name = "public-rt"
    }
}


resource "aws_route_table_association" "public" {
    count          = 2
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}
