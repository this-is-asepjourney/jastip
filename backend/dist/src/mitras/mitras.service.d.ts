import { PrismaService } from "../prisma/prisma.service";
export declare class MitrasService {
    private prisma;
    constructor(prisma: PrismaService);
    updateStatus(userId: string, isOnline: boolean): Promise<{
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
    }>;
    getOrders(userId: string): Promise<({
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
        customer: {
            phone: string;
            name: string;
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
    acceptOrder(userId: string, orderId: string): Promise<{
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
    updateOrderStatus(userId: string, orderId: string, status: string): Promise<{
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
