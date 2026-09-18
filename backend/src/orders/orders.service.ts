import { Injectable, NotFoundException, ForbiddenException, BadRequestException } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service";
import { CreateOrderDto } from "./dto/create-order.dto";

@Injectable()
export class OrdersService {
  constructor(private prisma: PrismaService) {}

  private generateOrderNumber(): string {
    const now = new Date();
    const date = now.toISOString().slice(0, 10).replace(/-/g, "");
    const rand = Math.floor(Math.random() * 9000) + 1000;
    return `JW-${date}-${rand}`;
  }

  async create(customerId: string, dto: CreateOrderDto) {
    const serviceFee = 5000;
    const subtotal = dto.items.reduce((sum, item) => sum + item.estimatedPrice * item.qty, 0);
    const total = subtotal + serviceFee + dto.deliveryFee;

    const order = await this.prisma.order.create({
      data: {
        orderNumber: this.generateOrderNumber(),
        customerId,
        addressId: dto.addressId,
        orderType: dto.orderType as any,
        status: "PENDING",
        subtotal,
        serviceFee,
        deliveryFee: dto.deliveryFee,
        discount: 0,
        total,
        customerNote: dto.customerNote,
        items: {
          create: dto.items.map((item) => ({
            productId: item.productId,
            productName: item.productName,
            qty: item.qty,
            estimatedPrice: item.estimatedPrice,
            subtotal: item.estimatedPrice * item.qty,
            note: item.note,
          })),
        },
      },
      include: {
        items: true,
        address: true,
        payment: true,
      },
    });

    // Create COD payment
    await this.prisma.payment.create({
      data: {
        orderId: order.id,
        method: "COD",
        amount: total,
        status: "PENDING",
      },
    });

    return order;
  }

  async findAll(customerId: string) {
    return this.prisma.order.findMany({
      where: { customerId },
      include: {
        items: true,
        address: true,
        mitra: { include: { user: { select: { name: true } } } },
      },
      orderBy: { createdAt: "desc" },
    });
  }

  async findOne(id: string, userId: string, userRole: string) {
    const order = await this.prisma.order.findUnique({
      where: { id },
      include: {
        items: { include: { product: true } },
        address: true,
        mitra: { include: { user: { select: { name: true, phone: true } } } },
        payment: true,
        delivery: true,
      },
    });
    if (!order) throw new NotFoundException("Order tidak ditemukan");
    if (userRole !== "ADMIN" && userRole !== "MITRA" && order.customerId !== userId) {
      throw new ForbiddenException();
    }
    return order;
  }

  async cancel(id: string, userId: string) {
    const order = await this.prisma.order.findUnique({ where: { id } });
    if (!order) throw new NotFoundException("Order tidak ditemukan");
    if (order.customerId !== userId) throw new ForbiddenException();
    if (!["PENDING", "CONFIRMED"].includes(order.status)) {
      throw new BadRequestException("Order tidak dapat dibatalkan pada status ini");
    }
    return this.prisma.order.update({
      where: { id },
      data: { status: "CANCELLED" },
    });
  }

  // Custom Jastip
  async createCustom(customerId: string, body: any) {
    const serviceFee = 5000;
    const estimatedTotal = body.estimatedPrice * body.qty + serviceFee + (body.deliveryFee || 8000);

    return this.prisma.order.create({
      data: {
        orderNumber: this.generateOrderNumber(),
        customerId,
        addressId: body.addressId,
        orderType: "CUSTOM_JASTIP",
        status: "WAITING_QUOTE",
        subtotal: body.estimatedPrice * body.qty,
        serviceFee,
        deliveryFee: body.deliveryFee || 8000,
        discount: 0,
        total: estimatedTotal,
        customerNote: body.note,
        items: {
          create: [{
            productName: body.itemName,
            qty: body.qty,
            estimatedPrice: body.estimatedPrice,
            subtotal: body.estimatedPrice * body.qty,
            note: body.itemNote,
          }],
        },
        delivery: {
          create: {
            pickupLat: body.storeLat,
            pickupLng: body.storeLng,
            destinationLat: body.deliveryLat,
            destinationLng: body.deliveryLng,
            status: "PENDING",
          }
        }
      },
      include: { items: true, delivery: true },
    });
  }

  // ─── Driver: Lihat penawaran aktif di peta ───────────────────────────────
  async findOffers() {
    return this.prisma.order.findMany({
      where: {
        orderType: "CUSTOM_JASTIP",
        status: { in: ["WAITING_QUOTE", "PENDING"] },
        mitraId: null,
      },
      include: {
        items: true,
        customer: { select: { name: true, phone: true } },
        address: true,
        delivery: true,
      },
      orderBy: { createdAt: "desc" },
    });
  }

  // ─── Driver: Ambil order (first-come-first-served) ────────────────────────
  async takeOrder(orderId: string, mitraId: string) {
    const order = await this.prisma.order.findUnique({ where: { id: orderId } });
    if (!order) throw new NotFoundException("Order tidak ditemukan");
    if (order.mitraId) throw new BadRequestException("Order sudah diambil driver lain");
    if (!["WAITING_QUOTE", "PENDING"].includes(order.status)) {
      throw new BadRequestException("Order tidak tersedia");
    }

    return this.prisma.order.update({
      where: { id: orderId },
      data: {
        mitraId,
        status: "CONFIRMED",
      },
      include: { items: true, customer: { select: { name: true, phone: true } }, address: true, delivery: true },
    });
  }
}
