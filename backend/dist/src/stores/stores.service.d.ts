import { PrismaService } from "../prisma/prisma.service";
export declare class StoresService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(): Promise<({
        _count: {
            products: number;
        };
    } & {
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
    })[]>;
    findOne(id: string): Promise<{
        products: ({
            category: {
                id: string;
                name: string;
                createdAt: Date;
                updatedAt: Date;
                image: string | null;
                isActive: boolean;
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
        })[];
    } & {
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
    }>;
}
