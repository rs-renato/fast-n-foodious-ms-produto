resource "aws_db_instance" "fnf-mysql-instance" {
  allocated_storage    = 5
  db_name              = "FAST_N_FOODIOUS"
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t2.micro"
  username             = jsondecode(aws_secretsmanager_secret_version.fnf-secret-version.secret_string)["username"]
  password             = jsondecode(aws_secretsmanager_secret_version.fnf-secret-version.secret_string)["password"]
  skip_final_snapshot  = true
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.fnf-db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.fnf-database-security-group.id, aws_security_group.fnf-cluster-security-group.id]
}

resource "aws_db_subnet_group" "fnf-db-subnet-group" {
  name       = "fnf-db-subnet-group"
  subnet_ids = [aws_subnet.fnf-subnet-private1-us-east-1a.id, aws_subnet.fnf-subnet-private2-us-east-1b.id]
  tags = {
    Name = "RDS subnet group"
  }
}

resource "aws_secretsmanager_secret" "fnf-secret" {
  name = "fnf-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "fnf-secret-version" {
  secret_id     = aws_secretsmanager_secret.fnf-secret.id
  secret_string = jsonencode({
    username = "fnf_user",
    password = "fnf_pass"
  })
}


# resource "null_resource" "rds-initialization" {
#     triggers = {
#         schemas = "${path.module}/../scripts/schema"
#     }

#     provisioner "local-exec" {
#         command = <<-EOF
#             for file in schema/*.sql; do
#                 echo "Executin RDS initialization file: $file"            
#                 aws rds-data execute-statement --resource-arn "$DB_ARN" --secret-arn "$SECRET_ARN" --database "$DB_NAME" --sql "$(cat $file)"
#             done
#         EOF

#         environment = {
#             DB_ARN     = aws_db_instance.fnf-mysql-instance.arn
#             DB_NAME    = aws_db_instance.fnf-mysql-instance.db_name
#             SECRET_ARN = aws_secretsmanager_secret.fnf-secret.arn
#         }
    
#         working_dir = "${path.module}/../scripts"
#   }
# }