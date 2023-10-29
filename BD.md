# Banco de Dados

## Banco de Dados escolhido

Inicialmente, o time havia escolhido o MySQL como banco de dados para o projeto pelos motivos abaixo detalhados. 

Quando houve a migração para a nuvem suportada pela AWS Services, o MySQL foi substituído pelo Amazon Aurora MySQL para desfrutar das vantagens de ter um banco de dados mais amigável ao ambiente de nuvem ao mesmo tempo em que não seria necessária refatoração do código da aplicação.  

### SGDB Relacional

O MySQL é um banco de dados relacional, cuja estrutura naturalmente obriga que os dados inseridos sejam consistentes.

Para uma aplicação que realiza cadastro de produtos, controle de pedidos e pagamentos, é vital que os dados estejam sempre consistentes e que a integridade de dados seja sempre mantida. 

Sendo um banco relacional, também reduz a possibilidade de bugs que causem a inserção parcial de dados. Por exemplo, o banco relacional com os devidos relacionamentos entre as entidades não permitirá o cadastrar um produto sem categoria ou com uma categoria inexistente.

Outra vantagem é a possibilidade de realizar consultas complexas envolvendo várias tabelas com relativa facilidade e desempenho. Apesar de muitos bancos NoSQL também permitirem esse tipo de consulta, ela tende a ser mais complexa para codificar e ter um custo de processamento relativamente maior a medida que a massa de dados aumenta. 

### Familiariadade do time com o MySQL

### Ampla documentação e suporte  