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
exports.MitrasService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let MitrasService = class MitrasService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async updateStatus(userId, isOnline) {
        const mitra = await this.prisma.mitraProfile.findUnique({ where: { userId } });
        if (!mitra)
            throw new common_1.NotFoundException("Profil mitra tidak ditemukan");
        return this.prisma.mitraProfile.update({ where: { userId }, data: { isOnline } });
    }
    async getOrders(userId) {
        const mitra = await this.prisma.mitraProfile.findUnique({ where: { userId } });
        if (!mitra)
            throw new common_1.NotFoundException("Profil mitra tidak ditemukan");
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
    async acceptOrder(userId, orderId) {
        const mitra = await this.prisma.mitraProfile.findUnique({ where: { userId } });
        if (!mitra)
            throw new common_1.NotFoundException("Profil mitra tidak ditemukan");
        const order = await this.prisma.order.findUnique({ where: { id: orderId } });
        if (!order)
            throw new common_1.NotFoundException("Order tidak ditemukan");
        if (order.status !== "PENDING")
            throw new common_1.ForbiddenException("Order sudah diambil");
        return this.prisma.order.update({
            where: { id: orderId },
            data: { mitraId: mitra.id, status: "CONFIRMED" },
        });
    }
    async updateOrderStatus(userId, orderId, status) {
        const mitra = await this.prisma.mitraProfile.findUnique({ where: { userId } });
        if (!mitra)
            throw new common_1.NotFoundException("Profil mitra tidak ditemukan");
        const order = await this.prisma.order.findUnique({ where: { id: orderId } });
        if (!order)
            throw new common_1.NotFoundException("Order tidak ditemukan");
        if (order.mitraId !== mitra.id)
            throw new common_1.ForbiddenException();
        const validTransitions = {
            CONFIRMED: ["SHOPPING"],
            SHOPPING: ["READY_TO_DELIVER"],
            READY_TO_DELIVER: ["ON_DELIVERY"],
            ON_DELIVERY: ["DELIVERED"],
        };
        if (!validTransitions[order.status]?.includes(status)) {
            throw new common_1.ForbiddenException("Transisi status tidak valid");
        }
        return this.prisma.order.update({
            where: { id: orderId },
            data: { status: status },
        });
    }
};
exports.MitrasService = MitrasService;
exports.MitrasService = MitrasService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], MitrasService);
//# sourceMappingURL=mitras.service.js.map