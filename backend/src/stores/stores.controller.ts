import { Controller, Get, Param } from "@nestjs/common";
import { StoresService } from "./stores.service";

@Controller("stores")
export class StoresController {
  constructor(private storesService: StoresService) {}

  @Get()
  findAll() { return this.storesService.findAll(); }

  @Get(":id")
  findOne(@Param("id") id: string) { return this.storesService.findOne(id); }
}
