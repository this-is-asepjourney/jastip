import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { PrismaModule } from "./prisma/prisma.module";
import { AuthModule } from "./auth/auth.module";
import { UsersModule } from "./users/users.module";
import { StoresModule } from "./stores/stores.module";
import { CategoriesModule } from "./categories/categories.module";
import { ProductsModule } from "./products/products.module";
import { AddressesModule } from "./addresses/addresses.module";
import { OrdersModule } from "./orders/orders.module";
import { MitrasModule } from "./mitras/mitras.module";
import { AreasModule } from "./areas/areas.module";

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    PrismaModule,
    AuthModule,
    UsersModule,
    StoresModule,
    CategoriesModule,
    ProductsModule,
    AddressesModule,
    OrdersModule,
    MitrasModule,
    AreasModule,
  ],
})
export class AppModule {}
