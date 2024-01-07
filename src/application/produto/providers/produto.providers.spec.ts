import { ProdutoProviders } from './produto.providers';

describe('ProdutoProviders', () => {
  it('should contains properly providers', () => {
    expect(ProdutoProviders).toHaveLength(9);
  });
});
