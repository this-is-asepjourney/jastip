import { Controller, Get, Put, Body } from "@nestjs/common";
import { UsersService } from "./users.service";
import { CurrentUser } from "../common/decorators/current-user.decorator";

@Controller("users")
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get("me")
  getMe(@CurrentUser() user: any) {
    return this.usersService.getMe(user.id);
  }

  @Put("me")
  updateMe(@CurrentUser() user: any, @Body() body: { name?: string; email?: string }) {
    return this.usersService.updateMe(user.id, body);
  }
}
