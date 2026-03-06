import { Entity, Column, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Category } from './category.entity';


@Entity()
export class Product {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column('decimal')
  price: number;

  @Column({nullable:true})
  imageUrl: string;

  @Column()
  description: string;

  @ManyToOne(() => Category, { eager: true }) 
  category: Category;
}