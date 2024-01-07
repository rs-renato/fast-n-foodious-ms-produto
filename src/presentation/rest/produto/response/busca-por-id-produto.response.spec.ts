import { Produto } from 'src/enterprise/produto/model/produto.model';
import { BuscaPorIdProdutoResponse } from './busca-por-id-produto.response';

describe('BuscaPorIdProdutoResponse', () => {
  it('deve setar as propriedades corretamente', () => {
    const produto: Produto = {
      ativo: true,
      descricao: 'Produto 1',
      idCategoriaProduto: 1,
      imagemBase64: '',
      nome: 'Nome do produto',
      preco: 10,
    };

    const produtoResponse = new BuscaPorIdProdutoResponse(produto);

    expect(produtoResponse.ativo).toEqual(produto.ativo);
    expect(produtoResponse.descricao).toEqual(produto.descricao);
    expect(produtoResponse.idCategoriaProduto).toEqual(produto.idCategoriaProduto);
    expect(produtoResponse.imagemBase64).toEqual(produto.imagemBase64);
    expect(produtoResponse.nome).toEqual(produto.nome);
    expect(produtoResponse.preco).toEqual(produto.preco);
  });
});
