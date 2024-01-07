import { PersistenceTypeOrmProviders } from './persistence-typeorm.providers';

describe('PersistenceTypeOrmProviders', () => {
  it('deve conter a quantidade de providers esperada', () => {
    expect(PersistenceTypeOrmProviders).toHaveLength(2);
  });
});
