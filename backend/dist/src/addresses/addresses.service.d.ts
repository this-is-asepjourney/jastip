import { PrismaService } from "../prisma/prisma.service";
export declare class AddressesService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(userId: string): import(".prisma/client").Prisma.PrismaPromise<{
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
    }[]>;
    findOne(id: string, userId: string): Promise<{
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
    }>;
    create(userId: string, data: any): Promise<{
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
    }>;
    update(id: string, userId: string, data: any): Promise<{
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
    }>;
    remove(id: string, userId: string): Promise<{
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
    }>;
}
