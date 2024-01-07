import { TypeORMError } from 'typeorm';

import { Produto } from 'src/enterprise/produto/model/produto.model';
import { ProdutoEntity } from 'src/infrastructure/persistence/produto/entity/produto.entity';
import { ProdutoMemoryRepository } from 'src/infrastructure/persistence/produto/repository/produto-memory.repository';

describe('ProdutoTypeormRepository', () => {
  let repository: ProdutoMemoryRepository;

  const produtoSalvar: Produto = {
    id: 1,
    nome: 'Nome teste',
    idCategoriaProduto: 1,
    descricao: 'Descrição teste',
    preco: 10,
    imagemBase64: '',
    ativo: true,
  };

  const produtoEditar: Produto = {
    id: 1,
    nome: 'Nome editado',
    idCategoriaProduto: 2,
    descricao: 'Descrição editada',
    preco: 100,
    imagemBase64: '',
    ativo: true,
  };

  const produtoDeletarEntity: ProdutoEntity = {
    id: 1,
    nome: 'Nome',
    idCategoriaProduto: 1,
    descricao: 'Descrição',
    preco: 100,
    imagemBase64: '',
    ativo: false,
  };

  beforeEach(() => {
    repository = new ProdutoMemoryRepository();
  });

  describe('save', () => {
    it('deve salvar produto corretamente', async () => {
      await repository.save(produtoSalvar).then((produtoSalvo) => {
        validateExpectations(produtoSalvo, produtoSalvar);
      });
    });

    it('não deve salvar produto quando houver um erro de banco ', async () => {
      const error = new TypeORMError('Erro genérico do TypeORM');
      jest.spyOn(repository, 'save').mockRejectedValue(error);

      await expect(repository.save(produtoSalvar)).rejects.toThrowError(error);
    });
  });

  describe('findBy', () => {
    beforeEach(async () => {
      await repository.save(produtoSalvar);
    });

    it('deve buscar produto pelo id retornar uma lista vazia', async () => {
      await repository.findBy({ id: 10 }).then((produtosEncontrados) => {
        expect(produtosEncontrados.length).toEqual(0);
      });
    });

    it('deve buscar produto pelo id', async () => {
      await repository.findBy({ id: produtoSalvar.id }).then((produtosEncontrados) => {
        expect(produtosEncontrados.length).toEqual(1);
        produtosEncontrados.forEach((produtoEncontrado) => {
          validateExpectations(produtoEncontrado, produtoSalvar);
        });
      });
    });

    it('deve buscar produto pelo nome e retornar uma lista vazia', async () => {
      await repository.findBy({ nome: 'algum produto' }).then((produtosEncontrados) => {
        expect(produtosEncontrados.length).toEqual(0);
      });
    });

    it('deve buscar produto pelo nome', async () => {
      await repository.findBy({ nome: produtoSalvar.nome }).then((produtosEncontrados) => {
        expect(produtosEncontrados.length).toEqual(1);
        produtosEncontrados.forEach((produtoEncontrado) => {
          validateExpectations(produtoEncontrado, produtoSalvar);
        });
      });
    });

    it('erros de banco na busca devem lançar uma exceção na camada de infra', async () => {
      const error = new TypeORMError('Erro genérico do TypeORM');
      jest.spyOn(repository, 'findBy').mockRejectedValue(error);

      await expect(repository.findBy({})).rejects.toThrowError(error);
    });
  });

  describe('edit', () => {
    beforeEach(async () => {
      await repository.save(produtoSalvar);
    });

    it('deve editar produto corretamente', async () => {
      await repository.edit(produtoEditar).then((produtoEditado) => {
        validateExpectations(produtoEditado, produtoEditar);
      });
    });

    it('não deve editar produto quando houver um erro de banco ', async () => {
      const error = new TypeORMError('Erro genérico do TypeORM');
      jest.spyOn(repository, 'edit').mockRejectedValue(error);

      await expect(repository.edit(produtoEditar)).rejects.toThrowError(error);
    });
  });

  describe('delete', () => {
    beforeEach(async () => {
      await repository.save(produtoSalvar);
    });

    it('deve deletar produto corretamente', async () => {
      jest.spyOn(repository, 'findBy').mockResolvedValue([produtoDeletarEntity]);

      await repository.delete(1).then((result) => {
        expect(result).toBeTruthy();
      });
    });

    it('não deve deletar produto quando houver um erro de banco ', async () => {
      const error = new TypeORMError('Erro genérico do TypeORM');
      jest.spyOn(repository, 'findBy').mockResolvedValue([produtoDeletarEntity]);
      jest.spyOn(repository, 'delete').mockRejectedValue(error);

      await expect(repository.delete(1)).rejects.toThrowError(error);
    });
  });

  describe('findAll', () => {
    it('findAll deve falhar porque não foi implementado', async () => {
      try {
        await expect(repository.findAll());
      } catch (error) {
        expect(error.message).toEqual('Método não implementado.');
      }
    });
  });
});

// método para reaproveitar código de checar Expectations
function validateExpectations(actualProduto: Produto, expectedProduto: Produto): void {
  expect(actualProduto.id).toEqual(expectedProduto.id);
  expect(actualProduto.idCategoriaProduto).toEqual(expectedProduto.idCategoriaProduto);
  expect(actualProduto.nome).toEqual(expectedProduto.nome);
  expect(actualProduto.descricao).toEqual(expectedProduto.descricao);
  expect(actualProduto.preco).toEqual(expectedProduto.preco);
  expect(actualProduto.imagemBase64).toEqual(expectedProduto.imagemBase64);
  expect(actualProduto.ativo).toEqual(expectedProduto.ativo);
}
