resource "aws_ssm_document" "install_httpd" {
  name          = "InstallApache"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Install Apache on EC2 using SSM"
    mainSteps = [{
      action = "aws:runShellScript"
      name   = "installApache"
      inputs = {
        runCommand = [
          "sudo yum install httpd -y",
          "sudo systemctl start httpd"
        ]
      }
    }]
  })
}

resource "aws_ssm_association" "run_install" {
  name = aws_ssm_document.install_httpd.name

  targets {
    key    = "InstanceIds"
    values = [aws_instance.demo.id]
  }

  depends_on = [aws_instance.demo]
}

