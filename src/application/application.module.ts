import { Module } from '@nestjs/common';

import { CategoriaProdutoService } from 'src/application/categoria/service/categoria-produto.service';
import { ProdutoService } from 'src/application/produto/service/produto.service';
import { ProdutoProviders } from 'src/application/produto/providers/produto.providers';
import { CategoriaProdutosProviders } from 'src/application/categoria/providers/categoria.providers';
import { ProdutoConstants, CategoriaProdutoConstants } from 'src/shared/constants';

@Module({
  providers: [...ProdutoProviders, ...CategoriaProdutosProviders],
  exports: [
    { provide: ProdutoConstants.ISERVICE, useClass: ProdutoService },
    { provide: CategoriaProdutoConstants.ISERVICE, useClass: CategoriaProdutoService },
  ],
})
export class ApplicationModule {}
