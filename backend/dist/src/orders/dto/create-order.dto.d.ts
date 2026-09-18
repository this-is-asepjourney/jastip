export declare enum CreateOrderType {
    PRODUCT = "PRODUCT",
    CUSTOM_JASTIP = "CUSTOM_JASTIP"
}
export declare class CreateOrderItemDto {
    productId?: string;
    productName: string;
    qty: number;
    estimatedPrice: number;
    note?: string;
}
export declare class CreateOrderDto {
    addressId?: string;
    orderType: CreateOrderType;
    items: CreateOrderItemDto[];
    customerNote?: string;
    deliveryFee: number;
}
