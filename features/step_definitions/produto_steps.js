const { When, Then } = require('@cucumber/cucumber');
const { spec, expect } = require('pactum');
const { BASE_URL } = require('../config');

When('Nos solicitamos a adicao de um novo produto com os dados:', async function ({ rawTable }) {
  const formattedData = rawTable
    .map(([nome, idCategoriaProduto, descricao, preco, imagemBase64], index) => {
      if (index !== 0) {
        return {
          nome,
          idCategoriaProduto: Number(idCategoriaProduto),
          descricao,
          preco: Number(preco),
          imagemBase64,
          ativo: true,
        };
      }
    })
    .filter((content) => content);
  const novoProduto = formattedData[0];

  this.payload = novoProduto;
  this.response = await spec().post(BASE_URL.PRODUTO).withBody(this.payload);
  this.produtoId = this.response.body.id;
});

When('Nos solicitamos a edicao do produto com os dados:', async function ({ rawTable }) {
  let produtoId = null;
  const formattedData = rawTable
    .map(([id, nome, idCategoriaProduto, descricao, preco, imagemBase64], index) => {
      if (index !== 0) {
        produtoId = id;

        return {
          id: Number(id),
          nome,
          idCategoriaProduto: Number(idCategoriaProduto),
          descricao,
          preco: Number(preco),
          imagemBase64,
          ativo: true,
        };
      }
    })
    .filter((content) => content);
  const produto = formattedData[0];

  this.payload = produto;
  this.response = await spec()
    .put(`${BASE_URL.PRODUTO}/{produto_id}`)
    .withPathParams({
      produto_id: produtoId,
    })
    .withBody(this.payload);
});

When('Nos solicitamos a consulta do produto com id {string}', async function (productId) {
  this.response = await spec().get(`${BASE_URL.PRODUTO}/{produto_id}`).withPathParams({
    produto_id: productId,
  });
});

When('Nos solicitamos a delecao do produto com id {string}', async function (productId) {
  this.response = await spec().delete(`${BASE_URL.PRODUTO}/{produto_id}`).withPathParams({
    produto_id: productId,
  });
});

Then('O produto deve conter os dados:', function ({ rawTable }) {
  const formattedData = rawTable
    .map(([id, nome, idCategoriaProduto, descricao, preco, imagemBase64, ativo], index) => {
      if (index !== 0) {
        produtoId = id;

        return {
          id: Number(id),
          nome,
          idCategoriaProduto: Number(idCategoriaProduto),
          descricao,
          preco: Number(preco),
          imagemBase64,
          ativo: ativo === 'true',
        };
      }
    })
    .filter((content) => content);
  const produto = formattedData[0];
  expect(this.response).should.have.body(produto);
});
