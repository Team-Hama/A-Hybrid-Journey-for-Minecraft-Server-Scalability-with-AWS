resource "aws_ec2_transit_gateway" "example" {
  amazon_side_asn = 64512
  description      = "${var.project_name} - Transit Gateway for VPN connection to On-premise"
  tags = {
    Name = "${var.project_name}-tgw"
  }
}


resource "aws_ec2_transit_gateway_route_table" "example_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "example_attachment" {
  subnet_ids         = module.vpc.public_subnets # 퍼블릭 서브넷 연결
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = module.vpc.vpc_id

  tags = {
    Name = "${var.project_name}-tgw-attachment"
  }

  depends_on = [aws_ec2_transit_gateway_route_table.example_route_table]
}

resource "aws_customer_gateway" "on_premise_cgw" {
  bgp_asn    = 65000
  ip_address =  var.on-premise_ip  # VyOS의 공인 IP
  type       = "ipsec.1"
  tags = {
    Name = "${var.project_name}-cgw"
  }
}

resource "aws_vpn_connection" "on_premise_vpn" {
  customer_gateway_id = aws_customer_gateway.on_premise_cgw.id
  transit_gateway_id  = aws_ec2_transit_gateway.example.id
  type                = "ipsec.1"

  static_routes_only = false  # BGP를 통한 동적 라우팅 활성화

  tags = {
    Name = "${var.project_name}-vpn"
  }
}

resource "aws_ec2_transit_gateway_route" "on_prem_route" {
  destination_cidr_block         = "10.100.0.0/24"  # 온프레미스 네트워크 대역
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.example_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example_route_table.id
}

resource "aws_route" "to_on_prem" {
  route_table_id         = module.vpc.private_route_table_ids[0]
  destination_cidr_block = "10.100.0.0/24"  # 온프레미스 네트워크 대역
  transit_gateway_id     = aws_ec2_transit_gateway.example.id
}
