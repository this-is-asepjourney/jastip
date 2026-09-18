import { Controller, Get, Param, Query } from "@nestjs/common";
import { ProductsService } from "./products.service";
import { Public } from "../common/decorators/public.decorator";

@Controller("products")
export class ProductsController {
  constructor(private productsService: ProductsService) {}

  @Public()
  @Get()
  findAll(
    @Query("storeId") storeId?: string,
    @Query("categoryId") categoryId?: string,
    @Query("search") search?: string,
  ) {
    return this.productsService.findAll({ storeId, categoryId, search });
  }

  @Public()
  @Get(":id")
  findOne(@Param("id") id: string) { return this.productsService.findOne(id); }
}
