import { Injectable } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service";

@Injectable()
export class ProductsService {
  constructor(private prisma: PrismaService) {}

  async findAll(query?: { storeId?: string; categoryId?: string; search?: string }) {
    const where: any = { isAvailable: true };
    if (query?.storeId) where.storeId = query.storeId;
    if (query?.categoryId) where.categoryId = query.categoryId;
    if (query?.search) where.name = { contains: query.search, mode: "insensitive" };

    return this.prisma.product.findMany({
      where,
      include: { store: { select: { id: true, name: true } }, category: { select: { id: true, name: true } } },
      orderBy: { name: "asc" },
    });
  }

  async findOne(id: string) {
    return this.prisma.product.findUnique({
      where: { id },
      include: { store: true, category: true },
    });
  }
}
