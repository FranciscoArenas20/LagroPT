import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './entities/products.entity';

@Injectable()
export class ProductsService {
  constructor(
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,
  ) {}

  async findAll(limit: number = 20, offset: number = 0, categoryId?: string, search?: string) {
    const queryBuilder = this.productRepo.createQueryBuilder('product')
      .leftJoinAndSelect('product.category', 'category') // Traemos la info de la categoría
      .take(limit)
      .skip(offset)
      .orderBy('product.id', 'ASC');

    // Filtro por categoría si existe
    if (categoryId) {
      queryBuilder.andWhere('category.id = :categoryId', { categoryId });
    }

    // Búsqueda por nombre si existe
    if (search) {
      queryBuilder.andWhere('LOWER(product.name) LIKE LOWER(:search)', { 
        search: `%${search}%` 
      });
    }

    const [items, total] = await queryBuilder.getManyAndCount();

    return {
      data: items,
      meta: {
        total,
        limit,
        offset,
        totalPages: Math.ceil(total / limit),
      },
    };
  }
}