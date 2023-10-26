-- Criação de banco de dados
-- CREATE DATABASE IF NOT EXISTS FAST_N_FOODIOUS;

-- Configuração de permissão para usuário da aplicação
-- GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, DROP, INDEX, REFERENCES ON FAST_N_FOODIOUS.* TO 'fnf_user'@'%';
-- FLUSH PRIVILEGES;

-- USE FAST_N_FOODIOUS;

--
-- CRIAÇÃO DE TABELAS
--

-- Tabela cliente
CREATE TABLE IF NOT EXISTS CLIENTE (
                                       ID INT PRIMARY KEY AUTO_INCREMENT,
                                       NOME VARCHAR(255) NOT NULL,
                                       EMAIL VARCHAR(255) NOT NULL UNIQUE,
                                       CPF VARCHAR(11) NOT NULL UNIQUE
);

-- indexes para tabela CLIENTE
-- CREATE UNIQUE INDEX cliente_email_idx ON CLIENTE(EMAIL);
-- CREATE UNIQUE INDEX cliente_cpf_idx ON CLIENTE(CPF);

-- Tabela CATEGORIA_PRODUTO -- sem auto_increment porque o conteúdo da tabela é fixa
CREATE TABLE IF NOT EXISTS CATEGORIA_PRODUTO (
                                                 ID INT PRIMARY KEY, 
                                                 NOME VARCHAR(255) NOT NULL UNIQUE
);

-- indexes para tabela CATEGORIA_PRODUTO
-- CREATE UNIQUE INDEX categoria_produto_nome_idx ON CATEGORIA_PRODUTO(NOME);

-- Tabela PRODUTO
CREATE TABLE IF NOT EXISTS PRODUTO (
                                       ID INT PRIMARY KEY AUTO_INCREMENT,
                                       PRODUTO_CATEGORIA_ID INT NOT NULL,
                                       NOME VARCHAR(255) NOT NULL UNIQUE,
                                       DESCRICAO VARCHAR(255) NOT NULL,
                                       PRECO DECIMAL(5,2) NOT NULL,
                                       IMAGEM TEXT,
                                       ATIVO BOOLEAN NOT NULL DEFAULT TRUE,
                                       FOREIGN KEY (PRODUTO_CATEGORIA_ID) REFERENCES CATEGORIA_PRODUTO(ID)
);

-- indexes para tabela PRODUTO
-- CREATE UNIQUE produto_nome_idx ON PRODUTO(NOME);

-- Tabela PEDIDO
CREATE TABLE IF NOT EXISTS PEDIDO (
                                       ID INT PRIMARY KEY AUTO_INCREMENT,
                                       PEDIDO_CLIENTE_ID INT NOT NULL,
                                       DATA_INICIO VARCHAR(255) NOT NULL,
                                       ESTADO_PEDIDO INT NOT NULL,
                                       ATIVO BOOLEAN NOT NULL DEFAULT TRUE,
                                       TOTAL DECIMAL(8,2) NULL,
                                       FOREIGN KEY (PEDIDO_CLIENTE_ID) REFERENCES CLIENTE(ID)
);

-- Tabela ITEMS DE PEDIDO
CREATE TABLE IF NOT EXISTS ITEM_PEDIDO (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    PEDIDO_ID INT NOT NULL,
    PRODUTO_ID INT NOT NULL,
    QUANTIDADE INT NOT NULL,
    FOREIGN KEY (PEDIDO_ID) REFERENCES PEDIDO(ID),
    FOREIGN KEY (PRODUTO_ID) REFERENCES PRODUTO(ID)
);

-- Tabela PAGAMENTO
CREATE TABLE IF NOT EXISTS PAGAMENTO (
                                       ID INT PRIMARY KEY AUTO_INCREMENT,
                                       PEDIDO_ID INT NOT NULL, 
                                       TRANSACAO_ID VARCHAR(255) NOT NULL,
                                       ESTADO_PAGAMENTO INT NOT NULL,
                                       TOTAL DECIMAL(8,2) NOT NULL,
                                       DATA_HORA_PAGAMENTO DATETIME NULL,
                                       FOREIGN KEY (PEDIDO_ID) REFERENCES PEDIDO(ID)
);