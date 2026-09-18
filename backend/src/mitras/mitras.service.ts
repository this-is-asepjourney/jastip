import { Injectable, NotFoundException, ForbiddenException } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service";

@Injectable()
export class MitrasService {
  constructor(private prisma: PrismaService) {}

  async updateStatus(userId: string, isOnline: boolean) {
    const mitra = await this.prisma.mitraProfile.findUnique({ where: { userId } });
    if (!mitra) throw new NotFoundException("Profil mitra tidak ditemukan");
    return this.prisma.mitraProfile.update({ where: { userId }, data: { isOnline } });
  }

  async getOrders(userId: string) {
    const mitra = await this.prisma.mitraProfile.findUnique({ where: { userId } });
    if (!mitra) throw new NotFoundException("Profil mitra tidak ditemukan");
    return this.prisma.order.findMany({
      where: {
        OR: [
          { mitraId: mitra.id },
          { status: "PENDING", mitraId: null },
        ],
      },
      include: {
        items: true,
        address: true,
        customer: { select: { name: true, phone: true } },
      },
      orderBy: { createdAt: "desc" },
    });
  }

  async acceptOrder(userId: string, orderId: string) {
    const mitra = await this.prisma.mitraProfile.findUnique({ where: { userId } });
    if (!mitra) throw new NotFoundException("Profil mitra tidak ditemukan");

    const order = await this.prisma.order.findUnique({ where: { id: orderId } });
    if (!order) throw new NotFoundException("Order tidak ditemukan");
    if (order.status !== "PENDING") throw new ForbiddenException("Order sudah diambil");

    return this.prisma.order.update({
      where: { id: orderId },
      data: { mitraId: mitra.id, status: "CONFIRMED" },
    });
  }

  async updateOrderStatus(userId: string, orderId: string, status: string) {
    const mitra = await this.prisma.mitraProfile.findUnique({ where: { userId } });
    if (!mitra) throw new NotFoundException("Profil mitra tidak ditemukan");

    const order = await this.prisma.order.findUnique({ where: { id: orderId } });
    if (!order) throw new NotFoundException("Order tidak ditemukan");
    if (order.mitraId !== mitra.id) throw new ForbiddenException();

    const validTransitions: Record<string, string[]> = {
      CONFIRMED: ["SHOPPING"],
      SHOPPING: ["READY_TO_DELIVER"],
      READY_TO_DELIVER: ["ON_DELIVERY"],
      ON_DELIVERY: ["DELIVERED"],
    };

    if (!validTransitions[order.status]?.includes(status)) {
      throw new ForbiddenException("Transisi status tidak valid");
    }

    return this.prisma.order.update({
      where: { id: orderId },
      data: { status: status as any },
    });
  }
}
