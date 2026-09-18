import { Controller, Get, Query } from "@nestjs/common";
import { AreasService } from "./areas.service";
import { Public } from "../common/decorators/public.decorator";

@Controller("areas")
export class AreasController {
  constructor(private areasService: AreasService) {}

  @Public()
  @Get()
  findAll() { return this.areasService.findAll(); }

  @Get("fee")
  getFee(@Query("distance") distance: string) {
    return this.areasService.calculateFee(parseFloat(distance));
  }
}
