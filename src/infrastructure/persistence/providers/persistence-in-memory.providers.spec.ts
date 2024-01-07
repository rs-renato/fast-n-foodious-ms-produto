import { PersistenceInMemoryProviders } from './persistence-in-memory.providers';

describe('PersistenceInMemoryProviders', () => {
  it('deve conter a quantidade de providers esperada', () => {
    expect(PersistenceInMemoryProviders).toHaveLength(2);
  });
});
