import { Controller, Get, Put, Post, Param, Body } from "@nestjs/common";
import { MitrasService } from "./mitras.service";
import { CurrentUser } from "../common/decorators/current-user.decorator";
import { Roles } from "../common/decorators/roles.decorator";

@Controller("mitras")
export class MitrasController {
  constructor(private mitrasService: MitrasService) {}

  @Roles("MITRA")
  @Put("status")
  updateStatus(@CurrentUser() user: any, @Body("isOnline") isOnline: boolean) {
    return this.mitrasService.updateStatus(user.id, isOnline);
  }

  @Roles("MITRA")
  @Get("orders")
  getOrders(@CurrentUser() user: any) {
    return this.mitrasService.getOrders(user.id);
  }

  @Roles("MITRA")
  @Post("orders/:id/accept")
  acceptOrder(@CurrentUser() user: any, @Param("id") orderId: string) {
    return this.mitrasService.acceptOrder(user.id, orderId);
  }

  @Roles("MITRA")
  @Put("orders/:id/status")
  updateOrderStatus(
    @CurrentUser() user: any,
    @Param("id") orderId: string,
    @Body("status") status: string,
  ) {
    return this.mitrasService.updateOrderStatus(user.id, orderId, status);
  }
}
