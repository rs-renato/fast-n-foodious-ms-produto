import { Module } from '@nestjs/common';
import { TypeOrmModule, TypeOrmModuleOptions } from '@nestjs/typeorm';
import { CategoriaProdutoEntity } from 'src/infrastructure/persistence/categoria/entity/categoria-produto.entity';
import { MysqlConfig } from 'src/infrastructure/persistence/mysql/mysql.config';
import { DatabaseConstants } from 'src/infrastructure/persistence/mysql/mysql.constants';
import { ProdutoEntity } from 'src/infrastructure/persistence/produto/entity/produto.entity';
import { PersistenceTypeOrmProviders } from 'src/infrastructure/persistence/providers/persistence-typeorm.providers';

@Module({
  imports: [
    DatabaseConstants,
    TypeOrmModule.forFeature([ProdutoEntity, CategoriaProdutoEntity]),
    TypeOrmModule.forRootAsync({
      imports: [MysqlConfig],
      useFactory: async (config: TypeOrmModuleOptions) => config,
      inject: [DatabaseConstants.DATABASE_CONFIG_NAME],
    }),
  ],
  providers: [...PersistenceTypeOrmProviders],
  exports: [...PersistenceTypeOrmProviders],
})
export class TypeormDatabaseModule {}
