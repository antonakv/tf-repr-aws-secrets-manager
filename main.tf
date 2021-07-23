provider "aws" {
  region = "eu-central-1"
}

# Secret values map
variable "dms_secret" {
  default = {
    host = "value1"
    username = "value2"
    password = "value3"
  }

  type = map(string)
}

# Create secret
resource "aws_secretsmanager_secret" "dms_secret" {
  name                = "dms_secret"
}

# Populate secret with values
resource "aws_secretsmanager_secret_version" "dms_secret" {
    secret_id     = aws_secretsmanager_secret.dms_secret.id
    secret_string = jsonencode(var.dms_secret)
}

# Get secrets
data "aws_secretsmanager_secret_version" "dms_secret" {
  secret_id = aws_secretsmanager_secret.dms_secret.id
}

# Display values
output "secret_host" {
    value = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.dms_secret.secret_string)["host"])
}

output "secret_username" {
    value = jsondecode(data.aws_secretsmanager_secret_version.dms_secret.secret_string)["username"]
    sensitive = true
}

output "secret_password" {
    value = jsondecode(data.aws_secretsmanager_secret_version.dms_secret.secret_string)["password"]
    sensitive = true
}


