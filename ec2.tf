# 🔹 STEP 2: Dynamic AMI (CRITICAL)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# 🔹 EC2 Instance
resource "aws_instance" "demo" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  key_name = aws_key_pair.mykp.key_name

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  user_data = <<-EOF
#!/bin/bash
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
EOF

  tags = {
    Name = "terra-server"
  }
}
