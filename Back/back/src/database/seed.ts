import { NestFactory } from '@nestjs/core';
import { DataSource } from 'typeorm';
import { AppModule } from '../app.module';
import { Product } from '../products/entities/products.entity';
import { Category } from '../products/entities/category.entity';
import { faker } from '@faker-js/faker';

async function runSeed() {
  const app = await NestFactory.createApplicationContext(AppModule);
  const dataSource = app.get(DataSource);
  const productRepo = dataSource.getRepository(Product);
  const categoryRepo = dataSource.getRepository(Category);

  console.log('Iniciando seed...');

  const categoriasCount = await categoryRepo.count()
  if(categoriasCount > 0){
    console.log('La BD ya tiene informacion, saltando seed...')
    return;
  }

  // 1. Categorías alineadas al negocio agrícola
  const agroCategories = [
    'Fertilizantes y Nutrición',
    'Control de Plagas (Fitosanitarios)',
    'Herramientas de Cosecha',
    'Equipo de Protección Personal',
    'Sistemas de Riego'
  ];

  const categories: Category[] = [];

  for (const name of agroCategories) {
    const cat = categoryRepo.create({ name });
    categories.push(await categoryRepo.save(cat));
  }

  // 2. Generación masiva (50,000 registros)
  const total = 50000;
  const batchSize = 5000;

  for (let i = 0; i < total; i += batchSize) {
    const batch: Product[] = [];
    for (let j = 0; j < batchSize; j++) {
      batch.push(
        productRepo.create({
          name: `${faker.commerce.productAdjective()} ${faker.helpers.arrayElement(['Sulfato', 'Tijeras Poda', 'Fertilizante NPK', 'Aspersor', 'Malla Sombra'])}`,
          description: `Lote de alta eficiencia para ${faker.helpers.arrayElement(['cultivo de hortalizas', 'frutales', 'invernaderos', 'suelo abierto'])}.`,
          price: parseFloat(faker.commerce.price({ min: 50, max: 5000 })),
          category: categories[Math.floor(Math.random() * categories.length)],
        }),
      );
    }
    await productRepo.save(batch);
    console.log(`Procesados ${i + batchSize} insumos agrícolas en la base de datos...`);
  }

  console.log('¡Siembra completada! 50,000 registros listos en la BD');
  await app.close();
}

runSeed();