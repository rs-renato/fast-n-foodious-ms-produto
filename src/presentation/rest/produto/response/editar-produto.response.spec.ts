import { EditarProdutoResponse } from './editar-produto.response';
import { Produto } from 'src/enterprise/produto/model/produto.model';

describe('EditarProdutoResponse', () => {
  it('deve setar as propriedades corretamente', () => {
    const produto: Produto = {
      ativo: true,
      descricao: 'Produto 1',
      idCategoriaProduto: 1,
      imagemBase64: '',
      nome: 'Nome do produto',
      preco: 10,
    };

    const produtoResponse = new EditarProdutoResponse(produto);

    expect(produtoResponse.ativo).toEqual(produto.ativo);
    expect(produtoResponse.descricao).toEqual(produto.descricao);
    expect(produtoResponse.idCategoriaProduto).toEqual(produto.idCategoriaProduto);
    expect(produtoResponse.imagemBase64).toEqual(produto.imagemBase64);
    expect(produtoResponse.nome).toEqual(produto.nome);
    expect(produtoResponse.preco).toEqual(produto.preco);
  });
});
