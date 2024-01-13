import { Test, TestingModule } from '@nestjs/testing';
import { ValidationException } from 'src/enterprise/exception/validation.exception';
import { Produto } from 'src/enterprise/produto/model/produto.model';
import { IRepository } from 'src/enterprise/repository/repository';
import { ProdutoConstants } from 'src/shared/constants';
import { NomeUnicoProdutoValidator } from './nome-unico-produto.validator';

describe('NomeUnicoProdutoValidator', () => {
  let nomeUnicoProdutoValidator: NomeUnicoProdutoValidator;
  let repository: IRepository<Produto>;

  const produtoUnico: Produto = {
    nome: 'Produto Único',
    idCategoriaProduto: 1,
    descricao: 'Descrição do Produto Único',
    preco: 50.0,
    imagemBase64: 'ImagemBase64',
    ativo: true,
  };

  const produtoDuplicado: Produto = {
    nome: 'Produto Duplicado',
    idCategoriaProduto: 2,
    descricao: 'Descrição do Produto Duplicado',
    preco: 60.0,
    imagemBase64: 'ImagemBase64',
    ativo: true,
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        NomeUnicoProdutoValidator,
        {
          provide: ProdutoConstants.IREPOSITORY,
          useValue: {
            findBy: jest.fn(() => {
              // retorna vazio, simulando que não encontrou registros pelo atributos passados por parâmetro
              return Promise.resolve({});
            }),
          },
        },
      ],
    }).compile();

    // Desabilita a saída de log
    module.useLogger(false);

    repository = module.get<IRepository<Produto>>(ProdutoConstants.IREPOSITORY);
    nomeUnicoProdutoValidator = module.get<NomeUnicoProdutoValidator>(NomeUnicoProdutoValidator);
  });

  it('deve ser definido', () => {
    expect(nomeUnicoProdutoValidator).toBeDefined();
    expect(repository).toBeDefined();
  });

  it('deve validar com sucesso um nome de produto único', async () => {
    // Simule o método findBy do repositório para retornar um array vazio (sem produtos existentes com o mesmo nome)
    repository.findBy = jest.fn().mockResolvedValue([]);

    const resultado = await nomeUnicoProdutoValidator.validate(produtoUnico);
    expect(resultado).toBe(true);

    // Verifique se o método findBy foi chamado com os argumentos corretos
    expect(repository.findBy).toHaveBeenCalledWith({ nome: 'Produto Único', ativo: true });
  });

  it('deve lançar ValidationException para um nome de produto não único', async () => {
    // Simule o método findBy do repositório para retornar um array com um produto existente
    repository.findBy = jest.fn().mockResolvedValue([{ id: 1, nome: 'Produto Duplicado', ativo: true }]);

    try {
      await nomeUnicoProdutoValidator.validate(produtoDuplicado);
      // Se a validação passar, esta linha não deve ser executada
      expect(true).toBe(false);
    } catch (error) {
      expect(error).toBeInstanceOf(ValidationException);
      expect(error.message).toBe(NomeUnicoProdutoValidator.CAMPOS_INVALIDOS_ERROR_MESSAGE);
    }
  });
});
