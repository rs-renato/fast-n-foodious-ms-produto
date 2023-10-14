# Criação de usuário 'tf-user' Terraform manualmente
- IAM > User > Create User
- Marcar a opção Provide user access to the AWS Management Console  e desmarcar Users must create a new password at next sign-in - Recommended
- Selecionar Attach policies directly e adicionar a role AdministratorAccess
- Criar access key para o usuário
- regitrar o accesskey do usuário tf-user no ~/.aws/credentials

# Criar S3 Bucket para salvar o Terraform state
Amazon S3 > Buckets > Create bucket
- fnf-terraform (nome único por region, então vai ter que mudar porque eu já usei este nome)

# Modificar a AWS Account no arquivo fnf-ecs.tf

Substituir o placeholder `<<account_id>>` pelo valor da sua conta AWS nas linhas:
execution_role_arn = "arn:aws:iam::`<<account_id>>`:role/ecsTaskExecutionRole"
image = "`<<account_id>>`.dkr.ecr.us-east-1.amazonaws.com/fast-n-foodious:latest",


# Instalar Terraform e inicializar terraform
- https://developer.hashicorp.com/terraform/downloads?product_intent=terraform
- $ terraform init
- $ terraform plan
- $ terraform apply