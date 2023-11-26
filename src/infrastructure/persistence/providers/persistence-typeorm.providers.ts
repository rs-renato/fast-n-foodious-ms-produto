import { Provider } from '@nestjs/common';

import { CategoriaProdutoConstants, ProdutoConstants } from 'src/shared/constants';

import { CategoriaProdutoTypeormRepository } from 'src/infrastructure/persistence/categoria/repository/categoria-produto-typeorm.repository';
import { ProdutoTypeormRepository } from 'src/infrastructure/persistence/produto/repository/produto-typeorm.repository';

export const PersistenceTypeOrmProviders: Provider[] = [
   { provide: ProdutoConstants.IREPOSITORY, useClass: ProdutoTypeormRepository },
   { provide: CategoriaProdutoConstants.IREPOSITORY, useClass: CategoriaProdutoTypeormRepository },
];
