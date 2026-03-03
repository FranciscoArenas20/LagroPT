import { Injectable, OnApplicationBootstrap } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from '../products/entities/products.entity';
import { Category } from '../products/entities/category.entity';
import { faker } from '@faker-js/faker';

@Injectable()
export class SeedService {
  constructor(
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,
    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>,
  ) {}

async runSeed() {
    const count = await this.productRepo.count();
    if (count > 0) {
      console.log('✅ La base de datos ya tiene datos. Saltando seed.');
      return;
    }


    console.log('🚜 Iniciando siembra automática de datos...');
    
    const agroCategories = ['Fertilizantes', 'Herramientas', 'Riego', 'EPP'];
    const categories: Category[] = [];

    for (const name of agroCategories) {
      const cat = this.categoryRepo.create({ name });
      categories.push(await this.categoryRepo.save(cat));
    }

    const total = 50000;
    const batchSize = 5000;

    for (let i = 0; i < total; i += batchSize) {
      const batch: Product[] = [];
      for (let j = 0; j < batchSize; j++) {
        batch.push(
          this.productRepo.create({
            name: `${faker.commerce.productAdjective()} ${faker.helpers.arrayElement(['Sulfato', 'Tijeras', 'Aspersor'])}`,
            description: 'Insumo para costos reales sin Excel.',
            price: parseFloat(faker.commerce.price({ min: 50, max: 5000 })),
            category: categories[Math.floor(Math.random() * categories.length)],
          }),
        );
      }
      await this.productRepo.save(batch);
      console.log(`🌱 Lote de ${i + batchSize} registros completado...`);
    }
    console.log('✨ Base de datos agrícola lista.');
  }
}
