import { Controller, Get, Query } from '@nestjs/common';
import { ProductsService } from './products.service';

@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Get()
  findAll(
    @Query('limit') limit?: number,
    @Query('offset') offset?: number,
    @Query('categoryId') categoryId?: string,
    @Query('search') search?: string,
  ) {
    return this.productsService.findAll(
      limit ? +limit : 20, 
      offset ? +offset : 0, 
      categoryId, 
      search
    );
  }
}
