import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';

import { MainModule } from '../../src/main.module';
import { AddItemPedidoRequest } from 'src/application/web/item-pedido/request';
import { ItemPedido } from 'src/domain/item-pedido/model';

describe('ItemPedidoController (e2e)', () => {
   let app: INestApplication;
   let addItemPedidoRequest: AddItemPedidoRequest;
   let itemPedido: ItemPedido;

   beforeEach(() => {
      addItemPedidoRequest = {
         pedidoId: 1,
         produtoId: 1,
         quantidade: 1,
      };

      itemPedido = {
         id: 1,
         pedidoId: 1,
         produtoId: 1,
         quantidade: 1,
      };
   });

   beforeAll(async () => {
      // Configuração do módulo de teste
      const module: TestingModule = await Test.createTestingModule({
         imports: [MainModule],
      }).compile();

      // Desabilita a saída de log
      module.useLogger(false);

      app = module.createNestApplication();

      // Configuração de validações global inputs request
      app.useGlobalPipes(new ValidationPipe({ stopAtFirstError: true }));
      await app.init();
   });

   afterAll(async () => {
      await app.close();
   });

   it('POST /v1/item - Deve adicionar um novo item ao pedido e retornar o ID', async () => {
      // realiza requisição e compara a resposta
      return await request(app.getHttpServer())
         .post('/v1/item')
         .set('Content-type', 'application/json')
         .send(addItemPedidoRequest)
         .then((response) => {
            expect(response.status).toEqual(201);
            expect(response.body).toEqual(itemPedido);
            expect(response.body).toHaveProperty('id');
            expect(response.body.pedidoId).toEqual(addItemPedidoRequest.pedidoId);
         });
   });
});
