# VPC and Networking moved from main.tf
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = merge({
    Name = "${local.name_prefix}-vpc"
  }, local.common_tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = merge({ Name = "${local.name_prefix}-igw" }, local.common_tags)
}

resource "aws_subnet" "public" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = merge({ Name = "${local.name_prefix}-public-${count.index}" }, local.common_tags)
}

resource "aws_eip" "nat" {
  vpc = true
  tags = merge({ Name = "${local.name_prefix}-nat-eip" }, local.common_tags)
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.igw]
  tags = merge({ Name = "${local.name_prefix}-nat" }, local.common_tags)
}

resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, length(var.azs) + count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags = merge({ Name = "${local.name_prefix}-private-${count.index}" }, local.common_tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge({ Name = "${local.name_prefix}-rt-public" }, local.common_tags)
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags = merge({ Name = "${local.name_prefix}-rt-private" }, local.common_tags)
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
