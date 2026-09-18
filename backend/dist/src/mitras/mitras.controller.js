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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MitrasController = void 0;
const common_1 = require("@nestjs/common");
const mitras_service_1 = require("./mitras.service");
const current_user_decorator_1 = require("../common/decorators/current-user.decorator");
const roles_decorator_1 = require("../common/decorators/roles.decorator");
let MitrasController = class MitrasController {
    constructor(mitrasService) {
        this.mitrasService = mitrasService;
    }
    updateStatus(user, isOnline) {
        return this.mitrasService.updateStatus(user.id, isOnline);
    }
    getOrders(user) {
        return this.mitrasService.getOrders(user.id);
    }
    acceptOrder(user, orderId) {
        return this.mitrasService.acceptOrder(user.id, orderId);
    }
    updateOrderStatus(user, orderId, status) {
        return this.mitrasService.updateOrderStatus(user.id, orderId, status);
    }
};
exports.MitrasController = MitrasController;
__decorate([
    (0, roles_decorator_1.Roles)("MITRA"),
    (0, common_1.Put)("status"),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Body)("isOnline")),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Boolean]),
    __metadata("design:returntype", void 0)
], MitrasController.prototype, "updateStatus", null);
__decorate([
    (0, roles_decorator_1.Roles)("MITRA"),
    (0, common_1.Get)("orders"),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], MitrasController.prototype, "getOrders", null);
__decorate([
    (0, roles_decorator_1.Roles)("MITRA"),
    (0, common_1.Post)("orders/:id/accept"),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Param)("id")),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", void 0)
], MitrasController.prototype, "acceptOrder", null);
__decorate([
    (0, roles_decorator_1.Roles)("MITRA"),
    (0, common_1.Put)("orders/:id/status"),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Param)("id")),
    __param(2, (0, common_1.Body)("status")),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, String]),
    __metadata("design:returntype", void 0)
], MitrasController.prototype, "updateOrderStatus", null);
exports.MitrasController = MitrasController = __decorate([
    (0, common_1.Controller)("mitras"),
    __metadata("design:paramtypes", [mitras_service_1.MitrasService])
], MitrasController);
//# sourceMappingURL=mitras.controller.js.map