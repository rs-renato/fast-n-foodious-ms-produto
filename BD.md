# Banco de Dados

## Banco de Dados escolhido

Inicialmente, o time havia escolhido o MySQL como banco de dados para o projeto, mas quando houve a migração para a nuvem suportada pela AWS Services, o MySQL foi substituído pelo Amazon Aurora MySQL para desfrutar das vantagens de se ter um banco de dados mais amigável ao ambiente de nuvem, ao mesmo tempo em que não seria necessária refatoração do código da aplicação.  

Os motivos da escolha pelo MySQL / Aurora estão detalhados abaixo, ressaltando que o termo MySQL será utilizado para se referir a ambos, exceto na subseção que descreve a substituição do MySQL pelo Amazon Aurora MySQL. 

### SGDB Relacional

O MySQL é um banco de dados relacional, cuja estrutura naturalmente obriga que os dados inseridos sejam consistentes.

Para uma aplicação que realiza cadastro de produtos, controle de pedidos e pagamentos, é vital que os dados estejam sempre consistentes e que a integridade de dados seja sempre mantida. 

Sendo um banco relacional, também reduz a possibilidade de bugs que causem a inserção parcial de dados. Por exemplo, o banco relacional com os devidos relacionamentos entre as entidades não permitirá o cadastrar um produto sem categoria ou com uma categoria inexistente.

Outra vantagem é a possibilidade de realizar consultas complexas envolvendo várias tabelas com relativa facilidade e desempenho. Apesar de muitos bancos NoSQL também permitirem esse tipo de consulta, ela tende a ser mais complexa para codificar e ter um custo de processamento relativamente maior a medida que a massa de dados aumenta. 

### Custo

O MySQL é um banco de dados que possui uma versão gratuita, o que condiz com o propósito educacional do projeto. 

### Familiariadade do time com o MySQL

Por sua popularidade e tempo de existência, todos no time tinham bastante experiência com ele.

### Substituição do MySQL pelo Amazon Aurora MySQL

Durante a criação dos scripts de Terraform para a criação da infraestrutura na AWS, foram constatadas limitações para criar o banco de dados, suas tabelas, e a carga inicial de dados durante a configuração de uma instância MySQL no RDS.

Ao substituirmos o MySQL por um cluster Aurora MySQL, foi possível a utilização de um task ECS para a criação do banco de dados dentro da instância RDS, bem como a criação das tabelas necessárias e efetuar a carga inicial de dados.  

Adotando-se o Aurora MySQL, foi possível manter a compatibilidade com o MySQL sem a necessidade de refatoração do código da aplicação, e ainda obter as vantagens de se utilizar um banco de dados desenvolvido especificamente para a nuvem:

- Escalabilidade automática
- Alta disponibilidade (6 cópias de dados em 3 zonas de disponibilidade)
- Backup automático
- Aumento de desempenho em até 5x em relação ao MySQL

A desvantagem é que o cluster Aurora MySQL não possui uma versão gratuita, e seu uso em produção seria ligeiramente mais caro do que o RDS MySQL, mas as vantagens superam esse ônus.

## Modelo de dados

### Diagrama

TBD

### Código DBML

TBD

### Código SQL

TBD

