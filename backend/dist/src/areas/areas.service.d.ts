import { PrismaService } from "../prisma/prisma.service";
export declare class AreasService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(): import(".prisma/client").Prisma.PrismaPromise<{
        id: string;
        name: string;
        createdAt: Date;
        updatedAt: Date;
        isActive: boolean;
        description: string | null;
        baseFee: number;
        maxDistance: number;
    }[]>;
    calculateFee(distanceKm: number): Promise<number>;
}
