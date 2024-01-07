import { DynamicModule } from '@nestjs/common';
import { MemoryDatabaseModule } from 'src/infrastructure/persistence/memory-database.module';
import { TypeormDatabaseModule } from 'src/infrastructure/persistence/typeorm-database.module';
import { DatabaseModule } from './database.module';

describe('DatabaseModule', () => {
  describe('forFeature', () => {
    it('should return MemoryDatabaseModule in local-mock-repository environment', () => {
      // Set NODE_ENV to 'local-mock-repository'
      process.env.NODE_ENV = 'local-mock-repository';

      const module: DynamicModule = DatabaseModule.forFeature();

      expect(module).toEqual({
        module: MemoryDatabaseModule,
        exports: [MemoryDatabaseModule],
      });
    });

    it('should return TypeormDatabaseModule in other environments', () => {
      // Set NODE_ENV to a different value
      process.env.NODE_ENV = 'production';

      const module: DynamicModule = DatabaseModule.forFeature();

      expect(module).toEqual({
        module: TypeormDatabaseModule,
        exports: [TypeormDatabaseModule],
      });
    });
  });
});
