import { CategoriaProdutosProviders } from './categoria.providers';

describe('CategoriaProdutosProviders', () => {
  it('should contains properly providers', () => {
    expect(CategoriaProdutosProviders).toHaveLength(2);
  });
});
