Feature: Produto
  Teste de integracao com endpoint /v1/produto

  Scenario: Cadastrar um novo produto
    When Nos solicitamos a adicao de um novo produto com os dados:
      |     nome     | idCategoriaProduto |   descricao   |  preco  |  imagemBase64  |
      | Hamburguer 1 |         1          |  Hamburger 1  |    10   |                |
    Then Deve ser adicionado com sucesso
     
  Scenario: Editar um produto cadastrado
    When Nos solicitamos a edicao do produto com os dados:
      | id |     nome     | idCategoriaProduto |   descricao   |  preco  |  imagemBase64  |
      |  1 | Hamburguer 2 |         1          |  Hamburger 2  |    10   |                |
    Then Deve ser editado com sucesso

  Scenario: Consultar um produto cadastrado
    When Nos solicitamos a consulta do produto com id '1'
    Then Deve ser retornado com sucesso
    And O produto deve conter os dados:
      | id |     nome     | idCategoriaProduto |   descricao   |  preco  |  imagemBase64  | ativo |
      |  1 | Hamburguer 2 |         1          |  Hamburger 2  |    10   |                |  true |

  Scenario: Deletar um produto cadastrado
    When Nos solicitamos a delecao do produto com id '1'
    Then Deve ser removido com sucesso

  Scenario: Consultar um produto nao cadastrado
    When Nos solicitamos a consulta do produto com id '100'
    Then Deve retornar erro de item nao encontrado