resource "aws_rds_cluster" "fnf-rds-cluster" {
  engine               = "aurora-mysql"
  engine_version       = "5.7.mysql_aurora.2.11.3"
  engine_mode          = "serverless"
  database_name        = "FAST_N_FOODIOUS"
  master_username      = "fnf_user"
  master_password      = random_password.fnf-random-passoword.result
  enable_http_endpoint = true
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.fnf-database-security-group.id, aws_security_group.fnf-cluster-security-group.id]
  db_subnet_group_name = aws_db_subnet_group.fnf-db-subnet-group.name

  scaling_configuration {
    min_capacity = 1
    max_capacity = 1
  }
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
    username = aws_rds_cluster.fnf-rds-cluster.master_username,
    password = aws_rds_cluster.fnf-rds-cluster.master_password,
    engine = "mysql",
    host = aws_rds_cluster.fnf-rds-cluster.endpoint
  })
}

resource "random_password" "fnf-random-passoword" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "null_resource" "rds-initialization" {
    triggers = {
      init = filesha1("${path.module}/../scripts/schema/1-init.sql")
      populate = filesha1("${path.module}/../scripts/schema/2-populate.sql")
    }

    provisioner "local-exec" {
      command = <<-EOF
            # iterate over all sql files
            for file in schema/*.sql; do
                sql_block=""
                # iterate over each line
                while IFS='' read -r line || [[ -n "$line" ]]; do
                    # Skip lines starting with -- (comments)
                    if [[ "$line" =~ ^\s*-- ]]; then
                        continue
                    fi

                    # Concatenate the line to the sql_block variable
                    sql_block="$sql_block $line"

                    # If the line ends with a semicolon, execute the SQL block and reset the sql_block variable
                    if [[ "$line" == *";" ]]; then
                        # Output the SQL block (optional, for debugging purposes)
                        echo "$sql_block"

                        # Execute the SQL block using aws rds-data
                        aws rds-data execute-statement --resource-arn "$DB_ARN" --database "$DB_NAME" --secret-arn "$SECRET_ARN" --sql "$sql_block"

                        # Reset the sql_block variable
                        sql_block=""
                    fi
                done < $file
            done
        EOF

        environment = {
            DB_ARN     = aws_rds_cluster.fnf-rds-cluster.arn
            DB_NAME    = aws_rds_cluster.fnf-rds-cluster.database_name
            SECRET_ARN = aws_secretsmanager_secret.fnf-secret.arn
        }
    
        working_dir = "${path.module}/../scripts"
  }
}