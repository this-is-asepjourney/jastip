import { PrismaService } from "../prisma/prisma.service";
export declare class UsersService {
    private prisma;
    constructor(prisma: PrismaService);
    getMe(userId: string): Promise<{
        id: string;
        email: string;
        phone: string;
        name: string;
        role: import(".prisma/client").$Enums.Role;
        status: import(".prisma/client").$Enums.UserStatus;
        createdAt: Date;
    }>;
    updateMe(userId: string, data: {
        name?: string;
        email?: string;
    }): Promise<{
        id: string;
        email: string;
        phone: string;
        name: string;
        role: import(".prisma/client").$Enums.Role;
    }>;
}
