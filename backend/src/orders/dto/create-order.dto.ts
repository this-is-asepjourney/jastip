import { IsString, IsArray, IsOptional, IsNumber, IsEnum } from "class-validator";

export enum CreateOrderType {
  PRODUCT = "PRODUCT",
  CUSTOM_JASTIP = "CUSTOM_JASTIP",
}

export class CreateOrderItemDto {
  @IsOptional()
  @IsString()
  productId?: string;

  @IsString()
  productName: string;

  @IsNumber()
  qty: number;

  @IsNumber()
  estimatedPrice: number;

  @IsOptional()
  @IsString()
  note?: string;
}

export class CreateOrderDto {
  @IsOptional()
  @IsString()
  addressId?: string;

  @IsEnum(CreateOrderType)
  orderType: CreateOrderType;

  @IsArray()
  items: CreateOrderItemDto[];

  @IsOptional()
  @IsString()
  customerNote?: string;

  @IsNumber()
  deliveryFee: number;
}
