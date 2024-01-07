import { Test, TestingModule } from '@nestjs/testing';
import { CategoriaProdutosProviders } from 'src/application/categoria/providers/categoria.providers';
import { ICategoriaProdutoService } from 'src/application/categoria/service/categoria-produto.service.interface';
import { BuscarTodasCategoriasUseCase } from 'src/application/categoria/usecase/buscar-todas-categorias.usecase';
import { CategoriaProduto } from 'src/enterprise/categoria/model/categoria-produto.model';
import { ServiceException } from 'src/enterprise/exception/service.exception';
import { PersistenceInMemoryProviders } from 'src/infrastructure/persistence/providers/persistence-in-memory.providers';
import { CategoriaProdutoConstants } from 'src/shared/constants';

describe('CategoriaProdutoService', () => {
  let service: ICategoriaProdutoService;
  let usecase: BuscarTodasCategoriasUseCase;

  const categoriaProdutos: Array<CategoriaProduto> = [
    { id: 1, nome: 'Lanche' },
    { id: 2, nome: 'Acompanhamento' },
    { id: 3, nome: 'Bebida' },
    { id: 4, nome: 'Sobremesa' },
  ];

  beforeEach(async () => {
    // Configuração do módulo de teste
    const module: TestingModule = await Test.createTestingModule({
      providers: [...CategoriaProdutosProviders, ...PersistenceInMemoryProviders],
    }).compile();

    // Desabilita a saída de log
    module.useLogger(false);

    // Obtém a instância do repositório, validators e serviço a partir do módulo de teste
    usecase = module.get<BuscarTodasCategoriasUseCase>(CategoriaProdutoConstants.BUSCAR_TODAS_CATEGORIAS_USECASE);
    service = module.get<ICategoriaProdutoService>(CategoriaProdutoConstants.ISERVICE);
  });

  describe('injeção de dependências', () => {
    it('deve existir instâncias de repositório definida', async () => {
      expect(usecase).toBeDefined();
    });
  });

  describe('findAll', () => {
    it('findAll deve retornar uma lista de categorias de produtos', async () => {
      const result = await service.findAll();
      expect(result).toEqual(categoriaProdutos);
    });
    it('não deve buscar lista de categorias de produto quando houver um erro de banco ', async () => {
      const error = new ServiceException('Erro genérico de banco de dados');
      jest.spyOn(usecase, 'buscarTodasCategorias').mockRejectedValue(error);

      // verifica se foi lançada uma exception na camada de serviço
      await expect(service.findAll()).rejects.toThrowError(ServiceException);
    }); // end it não deve buscar lista de categorias de produto quando houver um erro de banco
  }); // end describe findAll
});
