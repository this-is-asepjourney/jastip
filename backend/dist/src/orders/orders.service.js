"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.OrdersService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let OrdersService = class OrdersService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    generateOrderNumber() {
        const now = new Date();
        const date = now.toISOString().slice(0, 10).replace(/-/g, "");
        const rand = Math.floor(Math.random() * 9000) + 1000;
        return `JW-${date}-${rand}`;
    }
    async create(customerId, dto) {
        const serviceFee = 5000;
        const subtotal = dto.items.reduce((sum, item) => sum + item.estimatedPrice * item.qty, 0);
        const total = subtotal + serviceFee + dto.deliveryFee;
        const order = await this.prisma.order.create({
            data: {
                orderNumber: this.generateOrderNumber(),
                customerId,
                addressId: dto.addressId,
                orderType: dto.orderType,
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
    async findAll(customerId) {
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
    async findOne(id, userId, userRole) {
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
        if (!order)
            throw new common_1.NotFoundException("Order tidak ditemukan");
        if (userRole !== "ADMIN" && userRole !== "MITRA" && order.customerId !== userId) {
            throw new common_1.ForbiddenException();
        }
        return order;
    }
    async cancel(id, userId) {
        const order = await this.prisma.order.findUnique({ where: { id } });
        if (!order)
            throw new common_1.NotFoundException("Order tidak ditemukan");
        if (order.customerId !== userId)
            throw new common_1.ForbiddenException();
        if (!["PENDING", "CONFIRMED"].includes(order.status)) {
            throw new common_1.BadRequestException("Order tidak dapat dibatalkan pada status ini");
        }
        return this.prisma.order.update({
            where: { id },
            data: { status: "CANCELLED" },
        });
    }
    async createCustom(customerId, body) {
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
            },
            include: { items: true },
        });
    }
};
exports.OrdersService = OrdersService;
exports.OrdersService = OrdersService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], OrdersService);
//# sourceMappingURL=orders.service.js.map