import { PrismaService } from "../prisma/prisma.service";
import { CreateOrderDto } from "./dto/create-order.dto";
export declare class OrdersService {
    private prisma;
    constructor(prisma: PrismaService);
    private generateOrderNumber;
    create(customerId: string, dto: CreateOrderDto): Promise<{
        address: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            address: string;
            note: string | null;
            userId: string;
            label: string;
            recipientName: string;
            phone: string;
            latitude: number | null;
            longitude: number | null;
            isDefault: boolean;
        };
        items: {
            id: string;
            subtotal: number;
            productName: string;
            qty: number;
            estimatedPrice: number;
            actualPrice: number | null;
            note: string | null;
            productId: string | null;
            orderId: string;
        }[];
        payment: {
            id: string;
            status: import(".prisma/client").$Enums.PaymentStatus;
            createdAt: Date;
            orderId: string;
            method: import(".prisma/client").$Enums.PaymentMethod;
            amount: number;
            transactionId: string | null;
            paidAt: Date | null;
        };
    } & {
        id: string;
        orderNumber: string;
        orderType: import(".prisma/client").$Enums.OrderType;
        status: import(".prisma/client").$Enums.OrderStatus;
        subtotal: number;
        serviceFee: number;
        deliveryFee: number;
        discount: number;
        total: number;
        customerNote: string | null;
        createdAt: Date;
        updatedAt: Date;
        customerId: string;
        mitraId: string | null;
        addressId: string | null;
    }>;
    findAll(customerId: string): Promise<({
        mitra: {
            user: {
                name: string;
            };
        } & {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            userId: string;
            isOnline: boolean;
            area: string | null;
            vehicleType: string | null;
            vehicleNumber: string | null;
            rating: number;
            totalOrders: number;
        };
        address: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            address: string;
            note: string | null;
            userId: string;
            label: string;
            recipientName: string;
            phone: string;
            latitude: number | null;
            longitude: number | null;
            isDefault: boolean;
        };
        items: {
            id: string;
            subtotal: number;
            productName: string;
            qty: number;
            estimatedPrice: number;
            actualPrice: number | null;
            note: string | null;
            productId: string | null;
            orderId: string;
        }[];
    } & {
        id: string;
        orderNumber: string;
        orderType: import(".prisma/client").$Enums.OrderType;
        status: import(".prisma/client").$Enums.OrderStatus;
        subtotal: number;
        serviceFee: number;
        deliveryFee: number;
        discount: number;
        total: number;
        customerNote: string | null;
        createdAt: Date;
        updatedAt: Date;
        customerId: string;
        mitraId: string | null;
        addressId: string | null;
    })[]>;
    findOne(id: string, userId: string, userRole: string): Promise<{
        mitra: {
            user: {
                name: string;
                phone: string;
            };
        } & {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            userId: string;
            isOnline: boolean;
            area: string | null;
            vehicleType: string | null;
            vehicleNumber: string | null;
            rating: number;
            totalOrders: number;
        };
        address: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            address: string;
            note: string | null;
            userId: string;
            label: string;
            recipientName: string;
            phone: string;
            latitude: number | null;
            longitude: number | null;
            isDefault: boolean;
        };
        items: ({
            product: {
                id: string;
                createdAt: Date;
                updatedAt: Date;
                name: string;
                storeId: string;
                categoryId: string | null;
                description: string;
                price: number;
                image: string | null;
                stock: number;
                isAvailable: boolean;
            };
        } & {
            id: string;
            subtotal: number;
            productName: string;
            qty: number;
            estimatedPrice: number;
            actualPrice: number | null;
            note: string | null;
            productId: string | null;
            orderId: string;
        })[];
        payment: {
            id: string;
            status: import(".prisma/client").$Enums.PaymentStatus;
            createdAt: Date;
            orderId: string;
            method: import(".prisma/client").$Enums.PaymentMethod;
            amount: number;
            transactionId: string | null;
            paidAt: Date | null;
        };
        delivery: {
            id: string;
            status: import(".prisma/client").$Enums.DeliveryStatus;
            createdAt: Date;
            updatedAt: Date;
            mitraId: string | null;
            note: string | null;
            orderId: string;
            pickupLat: number | null;
            pickupLng: number | null;
            destinationLat: number | null;
            destinationLng: number | null;
            pickedUpAt: Date | null;
            deliveredAt: Date | null;
        };
    } & {
        id: string;
        orderNumber: string;
        orderType: import(".prisma/client").$Enums.OrderType;
        status: import(".prisma/client").$Enums.OrderStatus;
        subtotal: number;
        serviceFee: number;
        deliveryFee: number;
        discount: number;
        total: number;
        customerNote: string | null;
        createdAt: Date;
        updatedAt: Date;
        customerId: string;
        mitraId: string | null;
        addressId: string | null;
    }>;
    cancel(id: string, userId: string): Promise<{
        id: string;
        orderNumber: string;
        orderType: import(".prisma/client").$Enums.OrderType;
        status: import(".prisma/client").$Enums.OrderStatus;
        subtotal: number;
        serviceFee: number;
        deliveryFee: number;
        discount: number;
        total: number;
        customerNote: string | null;
        createdAt: Date;
        updatedAt: Date;
        customerId: string;
        mitraId: string | null;
        addressId: string | null;
    }>;
    createCustom(customerId: string, body: any): Promise<{
        items: {
            id: string;
            subtotal: number;
            productName: string;
            qty: number;
            estimatedPrice: number;
            actualPrice: number | null;
            note: string | null;
            productId: string | null;
            orderId: string;
        }[];
        delivery: {
            id: string;
            status: import(".prisma/client").$Enums.DeliveryStatus;
            createdAt: Date;
            updatedAt: Date;
            mitraId: string | null;
            note: string | null;
            orderId: string;
            pickupLat: number | null;
            pickupLng: number | null;
            destinationLat: number | null;
            destinationLng: number | null;
            pickedUpAt: Date | null;
            deliveredAt: Date | null;
        };
    } & {
        id: string;
        orderNumber: string;
        orderType: import(".prisma/client").$Enums.OrderType;
        status: import(".prisma/client").$Enums.OrderStatus;
        subtotal: number;
        serviceFee: number;
        deliveryFee: number;
        discount: number;
        total: number;
        customerNote: string | null;
        createdAt: Date;
        updatedAt: Date;
        customerId: string;
        mitraId: string | null;
        addressId: string | null;
    }>;
    findOffers(): Promise<({
        customer: {
            name: string;
            phone: string;
        };
        address: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            address: string;
            note: string | null;
            userId: string;
            label: string;
            recipientName: string;
            phone: string;
            latitude: number | null;
            longitude: number | null;
            isDefault: boolean;
        };
        items: {
            id: string;
            subtotal: number;
            productName: string;
            qty: number;
            estimatedPrice: number;
            actualPrice: number | null;
            note: string | null;
            productId: string | null;
            orderId: string;
        }[];
        delivery: {
            id: string;
            status: import(".prisma/client").$Enums.DeliveryStatus;
            createdAt: Date;
            updatedAt: Date;
            mitraId: string | null;
            note: string | null;
            orderId: string;
            pickupLat: number | null;
            pickupLng: number | null;
            destinationLat: number | null;
            destinationLng: number | null;
            pickedUpAt: Date | null;
            deliveredAt: Date | null;
        };
    } & {
        id: string;
        orderNumber: string;
        orderType: import(".prisma/client").$Enums.OrderType;
        status: import(".prisma/client").$Enums.OrderStatus;
        subtotal: number;
        serviceFee: number;
        deliveryFee: number;
        discount: number;
        total: number;
        customerNote: string | null;
        createdAt: Date;
        updatedAt: Date;
        customerId: string;
        mitraId: string | null;
        addressId: string | null;
    })[]>;
    takeOrder(orderId: string, mitraId: string): Promise<{
        customer: {
            name: string;
            phone: string;
        };
        address: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            address: string;
            note: string | null;
            userId: string;
            label: string;
            recipientName: string;
            phone: string;
            latitude: number | null;
            longitude: number | null;
            isDefault: boolean;
        };
        items: {
            id: string;
            subtotal: number;
            productName: string;
            qty: number;
            estimatedPrice: number;
            actualPrice: number | null;
            note: string | null;
            productId: string | null;
            orderId: string;
        }[];
        delivery: {
            id: string;
            status: import(".prisma/client").$Enums.DeliveryStatus;
            createdAt: Date;
            updatedAt: Date;
            mitraId: string | null;
            note: string | null;
            orderId: string;
            pickupLat: number | null;
            pickupLng: number | null;
            destinationLat: number | null;
            destinationLng: number | null;
            pickedUpAt: Date | null;
            deliveredAt: Date | null;
        };
    } & {
        id: string;
        orderNumber: string;
        orderType: import(".prisma/client").$Enums.OrderType;
        status: import(".prisma/client").$Enums.OrderStatus;
        subtotal: number;
        serviceFee: number;
        deliveryFee: number;
        discount: number;
        total: number;
        customerNote: string | null;
        createdAt: Date;
        updatedAt: Date;
        customerId: string;
        mitraId: string | null;
        addressId: string | null;
    }>;
}
