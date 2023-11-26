import { Provider } from '@nestjs/common';

import { CategoriaProdutoConstants, ProdutoConstants } from 'src/shared/constants';
import { CategoriaProdutoMemoryRepository } from 'src/infrastructure/persistence/categoria/repository/categoria-produto-memory.repository';
import { ProdutoMemoryRepository } from 'src/infrastructure/persistence/produto/repository/produto-memory.repository';

export const PersistenceInMemoryProviders: Provider[] = [
   { provide: ProdutoConstants.IREPOSITORY, useClass: ProdutoMemoryRepository },
   { provide: CategoriaProdutoConstants.IREPOSITORY, useClass: CategoriaProdutoMemoryRepository },
];
