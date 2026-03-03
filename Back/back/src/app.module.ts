import { Module, OnApplicationBootstrap } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config'; // Importante
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductsModule } from './products/products.module';
import { SeedService } from './database/seed.service';
import { Product } from './products/entities/products.entity';
import { Category } from './products/entities/category.entity';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true, // Hace que las variables estén disponibles en toda la app
    }),
    
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: 5440,
      username: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      autoLoadEntities: true,
      synchronize: true,
    }),
    TypeOrmModule.forFeature([Product, Category]),
    ProductsModule
  ],
  providers:[SeedService]
})

export class AppModule implements OnApplicationBootstrap {
  constructor(private readonly seedService: SeedService ){}
  onApplicationBootstrap() {
    this.seedService.runSeed()
  }

}
