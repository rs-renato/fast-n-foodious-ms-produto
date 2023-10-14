# Criação de usuário 'tf-user' Terraform manualmente
- IAM > User > Create User
- Marcar a opção Provide user access to the AWS Management Console  e desmarcar Users must create a new password at next sign-in - Recommended
- Selecionar Attach policies directly e adionar a role AdministratorAccess
- Criar access key para o usuário
- regitrar o accesskey do usuário tf-user no ~/.aws/credentials

# Criar S3 Bucket para salvar o Terraform state
Amazon S3 > Buckets > Create bucket
- fnf-terraform (nome unico por region, então vai ter que mudar porque eu já usei este nome)

# Instalar Terraform e inicalizar terraform
- https://developer.hashicorp.com/terraform/downloads?product_intent=terraform
- $ terraform init
- $ terraform plan
- $ terraform apply