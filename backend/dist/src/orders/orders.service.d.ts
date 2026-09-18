import { PrismaService } from "../prisma/prisma.service";
import { CreateOrderDto } from "./dto/create-order.dto";
export declare class OrdersService {
    private prisma;
    constructor(prisma: PrismaService);
    private generateOrderNumber;
    create(customerId: string, dto: CreateOrderDto): Promise<{
        address: {
            id: string;
            phone: string;
            createdAt: Date;
            updatedAt: Date;
            userId: string;
            address: string;
            latitude: number | null;
            longitude: number | null;
            label: string;
            recipientName: string;
            note: string | null;
            isDefault: boolean;
        };
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
        items: {
            id: string;
            note: string | null;
            productId: string | null;
            productName: string;
            qty: number;
            estimatedPrice: number;
            subtotal: number;
            actualPrice: number | null;
            orderId: string;
        }[];
    } & {
        id: string;
        status: import(".prisma/client").$Enums.OrderStatus;
        createdAt: Date;
        updatedAt: Date;
        addressId: string | null;
        orderType: import(".prisma/client").$Enums.OrderType;
        customerNote: string | null;
        deliveryFee: number;
        orderNumber: string;
        subtotal: number;
        serviceFee: number;
        discount: number;
        total: number;
        customerId: string;
        mitraId: string | null;
    }>;
    findAll(customerId: string): Promise<({
        address: {
            id: string;
            phone: string;
            createdAt: Date;
            updatedAt: Date;
            userId: string;
            address: string;
            latitude: number | null;
            longitude: number | null;
            label: string;
            recipientName: string;
            note: string | null;
            isDefault: boolean;
        };
        items: {
            id: string;
            note: string | null;
            productId: string | null;
            productName: string;
            qty: number;
            estimatedPrice: number;
            subtotal: number;
            actualPrice: number | null;
            orderId: string;
        }[];
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
    } & {
        id: string;
        status: import(".prisma/client").$Enums.OrderStatus;
        createdAt: Date;
        updatedAt: Date;
        addressId: string | null;
        orderType: import(".prisma/client").$Enums.OrderType;
        customerNote: string | null;
        deliveryFee: number;
        orderNumber: string;
        subtotal: number;
        serviceFee: number;
        discount: number;
        total: number;
        customerId: string;
        mitraId: string | null;
    })[]>;
    findOne(id: string, userId: string, userRole: string): Promise<{
        address: {
            id: string;
            phone: string;
            createdAt: Date;
            updatedAt: Date;
            userId: string;
            address: string;
            latitude: number | null;
            longitude: number | null;
            label: string;
            recipientName: string;
            note: string | null;
            isDefault: boolean;
        };
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
            note: string | null;
            mitraId: string | null;
            orderId: string;
            pickupLat: number | null;
            pickupLng: number | null;
            destinationLat: number | null;
            destinationLng: number | null;
            pickedUpAt: Date | null;
            deliveredAt: Date | null;
        };
        items: ({
            product: {
                id: string;
                name: string;
                createdAt: Date;
                updatedAt: Date;
                image: string | null;
                description: string;
                price: number;
                stock: number;
                isAvailable: boolean;
                storeId: string;
                categoryId: string | null;
            };
        } & {
            id: string;
            note: string | null;
            productId: string | null;
            productName: string;
            qty: number;
            estimatedPrice: number;
            subtotal: number;
            actualPrice: number | null;
            orderId: string;
        })[];
        mitra: {
            user: {
                phone: string;
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
    } & {
        id: string;
        status: import(".prisma/client").$Enums.OrderStatus;
        createdAt: Date;
        updatedAt: Date;
        addressId: string | null;
        orderType: import(".prisma/client").$Enums.OrderType;
        customerNote: string | null;
        deliveryFee: number;
        orderNumber: string;
        subtotal: number;
        serviceFee: number;
        discount: number;
        total: number;
        customerId: string;
        mitraId: string | null;
    }>;
    cancel(id: string, userId: string): Promise<{
        id: string;
        status: import(".prisma/client").$Enums.OrderStatus;
        createdAt: Date;
        updatedAt: Date;
        addressId: string | null;
        orderType: import(".prisma/client").$Enums.OrderType;
        customerNote: string | null;
        deliveryFee: number;
        orderNumber: string;
        subtotal: number;
        serviceFee: number;
        discount: number;
        total: number;
        customerId: string;
        mitraId: string | null;
    }>;
    createCustom(customerId: string, body: any): Promise<{
        items: {
            id: string;
            note: string | null;
            productId: string | null;
            productName: string;
            qty: number;
            estimatedPrice: number;
            subtotal: number;
            actualPrice: number | null;
            orderId: string;
        }[];
    } & {
        id: string;
        status: import(".prisma/client").$Enums.OrderStatus;
        createdAt: Date;
        updatedAt: Date;
        addressId: string | null;
        orderType: import(".prisma/client").$Enums.OrderType;
        customerNote: string | null;
        deliveryFee: number;
        orderNumber: string;
        subtotal: number;
        serviceFee: number;
        discount: number;
        total: number;
        customerId: string;
        mitraId: string | null;
    }>;
}
