import { Module } from '@nestjs/common';
import { APP_FILTER } from '@nestjs/core';
import { ApplicationModule } from 'src/application/application.module';
import { CategoriaProdutoRestApi } from 'src/presentation/rest/categoria/api/categoria-produto.api';
import { NaoEncontradoExceptionHandler } from 'src/presentation/rest/handler/nao-encontrado-application-exception.handler';
import { GeneralExceptionHandler } from 'src/presentation/rest/handler/general-exception.handler';
import { GeneralHttpExceptionHandler } from 'src/presentation/rest/handler/general-http-exception.handler';
import { InfraestructureExceptionHandler } from 'src/presentation/rest/handler/infraestructure-exception.handler';
import { ValidationExceptionHandler } from 'src/presentation/rest/handler/validation-exception.handler';
import { HealthRestApi } from 'src/presentation/rest/health/api/health.api';
import { ProdutoRestApi } from 'src/presentation/rest/produto/api/produto.api';

@Module({
  imports: [ApplicationModule],
  providers: [
    { provide: APP_FILTER, useClass: GeneralExceptionHandler },
    { provide: APP_FILTER, useClass: GeneralHttpExceptionHandler },
    { provide: APP_FILTER, useClass: InfraestructureExceptionHandler },
    { provide: APP_FILTER, useClass: ValidationExceptionHandler },
    { provide: APP_FILTER, useClass: NaoEncontradoExceptionHandler },
  ],
  controllers: [ProdutoRestApi, CategoriaProdutoRestApi, HealthRestApi],
})
export class PresentationModule {}
