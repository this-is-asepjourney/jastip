import { PrismaService } from "../prisma/prisma.service";
export declare class ProductsService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(query?: {
        storeId?: string;
        categoryId?: string;
        search?: string;
    }): Promise<({
        category: {
            id: string;
            name: string;
        };
        store: {
            id: string;
            name: string;
        };
    } & {
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
    })[]>;
    findOne(id: string): Promise<{
        category: {
            id: string;
            name: string;
            createdAt: Date;
            updatedAt: Date;
            image: string | null;
            isActive: boolean;
        };
        store: {
            id: string;
            name: string;
            createdAt: Date;
            updatedAt: Date;
            image: string | null;
            isActive: boolean;
            description: string;
            address: string;
            latitude: number | null;
            longitude: number | null;
        };
    } & {
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
    }>;
}
