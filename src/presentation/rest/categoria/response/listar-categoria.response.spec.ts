import { CategoriaProduto } from 'src/enterprise/categoria/model/categoria-produto.model';
import { ListarCategoriaResponse } from './listar-categoria.response';

describe('ListarCategoriaResponse', () => {
  it('deve setar as propriedades corretamente', () => {
    const categoria: CategoriaProduto = {
      id: 1,
      nome: 'Categoria 1',
    };

    const responseCategoria = new ListarCategoriaResponse(categoria);

    expect(responseCategoria.id).toEqual(categoria.id);
    expect(responseCategoria.nome).toEqual(categoria.nome);
  });
});
