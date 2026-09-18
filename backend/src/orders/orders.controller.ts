import { Controller, Get, Post, Param, Body } from "@nestjs/common";
import { OrdersService } from "./orders.service";
import { CreateOrderDto } from "./dto/create-order.dto";
import { CurrentUser } from "../common/decorators/current-user.decorator";

@Controller("orders")
export class OrdersController {
  constructor(private ordersService: OrdersService) {}

  @Post()
  create(@CurrentUser() user: any, @Body() dto: CreateOrderDto) {
    return this.ordersService.create(user.id, dto);
  }

  @Get()
  findAll(@CurrentUser() user: any) {
    return this.ordersService.findAll(user.id);
  }

  @Get(":id")
  findOne(@Param("id") id: string, @CurrentUser() user: any) {
    return this.ordersService.findOne(id, user.id, user.role);
  }

  @Post(":id/cancel")
  cancel(@Param("id") id: string, @CurrentUser() user: any) {
    return this.ordersService.cancel(id, user.id);
  }

  @Post("custom")
  createCustom(@CurrentUser() user: any, @Body() body: any) {
    return this.ordersService.createCustom(user.id, body);
  }
}
