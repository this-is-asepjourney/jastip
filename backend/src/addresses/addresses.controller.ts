import { Controller, Get, Post, Put, Delete, Body, Param } from "@nestjs/common";
import { AddressesService } from "./addresses.service";
import { CurrentUser } from "../common/decorators/current-user.decorator";

@Controller("addresses")
export class AddressesController {
  constructor(private addressesService: AddressesService) {}

  @Get()
  findAll(@CurrentUser() user: any) { return this.addressesService.findAll(user.id); }

  @Get(":id")
  findOne(@Param("id") id: string, @CurrentUser() user: any) { return this.addressesService.findOne(id, user.id); }

  @Post()
  create(@CurrentUser() user: any, @Body() body: any) { return this.addressesService.create(user.id, body); }

  @Put(":id")
  update(@Param("id") id: string, @CurrentUser() user: any, @Body() body: any) { return this.addressesService.update(id, user.id, body); }

  @Delete(":id")
  remove(@Param("id") id: string, @CurrentUser() user: any) { return this.addressesService.remove(id, user.id); }
}
