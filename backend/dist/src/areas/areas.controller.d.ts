import { AreasService } from "./areas.service";
export declare class AreasController {
    private areasService;
    constructor(areasService: AreasService);
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
    getFee(distance: string): Promise<number>;
}
