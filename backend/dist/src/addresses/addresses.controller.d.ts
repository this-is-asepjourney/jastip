import { AddressesService } from "./addresses.service";
export declare class AddressesController {
    private addressesService;
    constructor(addressesService: AddressesService);
    findAll(user: any): import(".prisma/client").Prisma.PrismaPromise<{
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
    findOne(id: string, user: any): Promise<{
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
    create(user: any, body: any): Promise<{
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
    update(id: string, user: any, body: any): Promise<{
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
    remove(id: string, user: any): Promise<{
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
