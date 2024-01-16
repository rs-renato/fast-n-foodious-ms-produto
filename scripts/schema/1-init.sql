-- Criação de banco de dados
CREATE DATABASE IF NOT EXISTS FAST_N_FOODIOUS;

-- Configuração de permissão para usuário da aplicação
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, DROP, INDEX, REFERENCES ON FAST_N_FOODIOUS.* TO 'fnf_user'@'%';
FLUSH PRIVILEGES;

USE FAST_N_FOODIOUS;

--
-- CRIAÇÃO DE TABELAS
--

-- Tabela CATEGORIA_PRODUTO
CREATE TABLE IF NOT EXISTS CATEGORIA_PRODUTO (
                                                 ID INT PRIMARY KEY, -- sem auto_increment porque o conteúdo da tabela é fixa
                                                 NOME VARCHAR(255) NOT NULL
);

-- indexes para tabela CATEGORIA_PRODUTO
CREATE UNIQUE INDEX categoria_produto_nome_idx ON CATEGORIA_PRODUTO(NOME);

-- Tabela PRODUTO
CREATE TABLE IF NOT EXISTS PRODUTO (
                                       ID INT AUTO_INCREMENT PRIMARY KEY,
                                       PRODUTO_CATEGORIA_ID INT NOT NULL, CONSTRAINT FK_PRODUTO_CATEGORIA FOREIGN KEY (PRODUTO_CATEGORIA_ID) REFERENCES CATEGORIA_PRODUTO(ID),
                                       NOME VARCHAR(255) NOT NULL,
                                       DESCRICAO VARCHAR(255) NOT NULL,
                                       PRECO DECIMAL(5,2) NOT NULL,
                                       IMAGEM TEXT, -- base64
                                       ATIVO BOOLEAN NOT NULL DEFAULT TRUE
);

-- indexes para tabela PRODUTO
CREATE UNIQUE INDEX produto_nome_idx ON PRODUTO(NOME);
