import { Inject, Injectable, Logger } from '@nestjs/common';
import { NaoEncontradoApplicationException } from 'src/application/exception/nao-encontrado.exception';
import { ServiceException } from 'src/enterprise/exception/service.exception';
import { Produto } from 'src/enterprise/produto/model/produto.model';
import { IRepository } from 'src/enterprise/repository/repository';
import { ProdutoConstants } from 'src/shared/constants';

@Injectable()
export class BuscarProdutoPorIdCategoriaUseCase {
  private logger = new Logger(BuscarProdutoPorIdCategoriaUseCase.name);

  constructor(@Inject(ProdutoConstants.IREPOSITORY) private repository: IRepository<Produto>) {}

  async buscarProdutoPorIdCategoria(idCategoriaProduto: number): Promise<Produto[]> {
    const produtos = await this.repository.findBy({ idCategoriaProduto: idCategoriaProduto }).catch((error) => {
      this.logger.error(`Erro ao buscar produto idCategoriaProduto=${idCategoriaProduto} no banco de dados: ${error}`);
      throw new ServiceException(
        `Erro ao buscar produto idCategoriaProduto=${idCategoriaProduto} no banco de dados: ${error}`,
      );
    });

    if (!produtos.length) {
      this.logger.debug(`Produtos não encontrados para idCategoriaProduto: ${idCategoriaProduto}`);
      throw new NaoEncontradoApplicationException(
        `Produtos não encontrados para idCategoriaProduto: ${idCategoriaProduto}`,
      );
    }

    return produtos;
  }
}
