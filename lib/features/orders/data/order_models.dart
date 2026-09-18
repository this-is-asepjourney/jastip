// Order status
enum OrderStatus {
  pending,
  confirmed,
  shopping,
  readyToDeliver,
  onDelivery,
  delivered,
  cancelled,
  waitingQuote,
  waitingApproval,
}

extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending: return "Menunggu Konfirmasi";
      case OrderStatus.confirmed: return "Dikonfirmasi";
      case OrderStatus.shopping: return "Sedang Belanja";
      case OrderStatus.readyToDeliver: return "Siap Dikirim";
      case OrderStatus.onDelivery: return "Dalam Pengiriman";
      case OrderStatus.delivered: return "Terkirim";
      case OrderStatus.cancelled: return "Dibatalkan";
      case OrderStatus.waitingQuote: return "Menunggu Harga";
      case OrderStatus.waitingApproval: return "Menunggu Persetujuan";
    }
  }

  String get apiValue {
    switch (this) {
      case OrderStatus.pending: return "PENDING";
      case OrderStatus.confirmed: return "CONFIRMED";
      case OrderStatus.shopping: return "SHOPPING";
      case OrderStatus.readyToDeliver: return "READY_TO_DELIVER";
      case OrderStatus.onDelivery: return "ON_DELIVERY";
      case OrderStatus.delivered: return "DELIVERED";
      case OrderStatus.cancelled: return "CANCELLED";
      case OrderStatus.waitingQuote: return "WAITING_QUOTE";
      case OrderStatus.waitingApproval: return "WAITING_APPROVAL";
    }
  }

  static OrderStatus fromString(String s) {
    switch (s.toUpperCase()) {
      case "CONFIRMED": return OrderStatus.confirmed;
      case "SHOPPING": return OrderStatus.shopping;
      case "READY_TO_DELIVER": return OrderStatus.readyToDeliver;
      case "ON_DELIVERY": return OrderStatus.onDelivery;
      case "DELIVERED": return OrderStatus.delivered;
      case "CANCELLED": return OrderStatus.cancelled;
      case "WAITING_QUOTE": return OrderStatus.waitingQuote;
      case "WAITING_APPROVAL": return OrderStatus.waitingApproval;
      default: return OrderStatus.pending;
    }
  }

  bool get isActive => ![OrderStatus.delivered, OrderStatus.cancelled].contains(this);

  int get stepIndex {
    switch (this) {
      case OrderStatus.pending: return 0;
      case OrderStatus.confirmed: return 1;
      case OrderStatus.shopping: return 2;
      case OrderStatus.readyToDeliver: return 3;
      case OrderStatus.onDelivery: return 4;
      case OrderStatus.delivered: return 5;
      default: return 0;
    }
  }

  String? get nextStatus {
    switch (this) {
      case OrderStatus.confirmed: return "SHOPPING";
      case OrderStatus.shopping: return "READY_TO_DELIVER";
      case OrderStatus.readyToDeliver: return "ON_DELIVERY";
      case OrderStatus.onDelivery: return "DELIVERED";
      default: return null;
    }
  }

  String? get nextStatusLabel {
    switch (this) {
      case OrderStatus.confirmed: return "Mulai Belanja";
      case OrderStatus.shopping: return "Siap Dikirim";
      case OrderStatus.readyToDeliver: return "Mulai Antar";
      case OrderStatus.onDelivery: return "Selesai Antar";
      default: return null;
    }
  }
}

// Order type
enum OrderType { product, customJastip }

// Order item
class OrderItemModel {
  final String id;
  final String? productId;
  final String productName;
  final int qty;
  final double estimatedPrice;
  final double? actualPrice;
  final String? note;

  const OrderItemModel({
    required this.id,
    this.productId,
    required this.productName,
    required this.qty,
    required this.estimatedPrice,
    this.actualPrice,
    this.note,
  });

  double get subtotal => (actualPrice ?? estimatedPrice) * qty;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        id: json["id"] ?? "",
        productId: json["productId"] ?? json["product_id"],
        productName: json["productName"] ?? json["product_name"] ?? "",
        qty: (json["qty"] as num?)?.toInt() ?? 1,
        estimatedPrice: (json["estimatedPrice"] ?? json["estimated_price"] as num?)?.toDouble() ?? 0,
        actualPrice: (json["actualPrice"] ?? json["actual_price"] as num?)?.toDouble(),
        note: json["note"],
      );
}

// Address model
class AddressModel {
  final String id;
  final String label;
  final String recipientName;
  final String phone;
  final String address;
  final bool isDefault;
  final String? note;
  final double? latitude;
  final double? longitude;

  const AddressModel({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.address,
    this.isDefault = false,
    this.note,
    this.latitude,
    this.longitude,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"] ?? "",
        label: json["label"] ?? "",
        recipientName: json["recipientName"] ?? json["recipient_name"] ?? "",
        phone: json["phone"] ?? "",
        address: json["address"] ?? "",
        isDefault: json["isDefault"] ?? json["is_default"] ?? false,
        note: json["note"],
        latitude: (json["latitude"] as num?)?.toDouble(),
        longitude: (json["longitude"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "recipientName": recipientName,
        "phone": phone,
        "address": address,
        "isDefault": isDefault,
        if (note != null) "note": note,
        if (latitude != null) "latitude": latitude,
        if (longitude != null) "longitude": longitude,
      };
}

// Order model
class OrderModel {
  final String id;
  final String orderNumber;
  final OrderType orderType;
  final OrderStatus status;
  final List<OrderItemModel> items;
  final AddressModel? address;
  final double subtotal;
  final double serviceFee;
  final double deliveryFee;
  final double discount;
  final double total;
  final String? customerNote;
  final String? mitraName;
  final String? mitraPhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.orderType,
    required this.status,
    required this.items,
    this.address,
    required this.subtotal,
    required this.serviceFee,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    this.customerNote,
    this.mitraName,
    this.mitraPhone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"] ?? "",
        orderNumber: json["orderNumber"] ?? json["order_number"] ?? "",
        orderType: (json["orderType"] ?? json["order_type"]) == "CUSTOM_JASTIP"
            ? OrderType.customJastip
            : OrderType.product,
        status: OrderStatusExt.fromString(json["status"] ?? "PENDING"),
        items: (json["items"] as List<dynamic>?)
                ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
                .toList() ?? [],
        address: json["address"] != null ? AddressModel.fromJson(json["address"]) : null,
        subtotal: (json["subtotal"] as num?)?.toDouble() ?? 0,
        serviceFee: (json["serviceFee"] ?? json["service_fee"] as num?)?.toDouble() ?? 5000,
        deliveryFee: (json["deliveryFee"] ?? json["delivery_fee"] as num?)?.toDouble() ?? 0,
        discount: (json["discount"] as num?)?.toDouble() ?? 0,
        total: (json["total"] as num?)?.toDouble() ?? 0,
        customerNote: json["customerNote"] ?? json["customer_note"],
        mitraName: json["mitra"]?["user"]?["name"],
        mitraPhone: json["mitra"]?["user"]?["phone"],
        createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now(),
        updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : DateTime.now(),
      );
}

// Mock orders (fallback)
class MockOrders {
  static List<OrderModel> get orders => [
        OrderModel(
          id: "o1",
          orderNumber: "JW-20240916-001",
          orderType: OrderType.product,
          status: OrderStatus.onDelivery,
          items: [
            const OrderItemModel(id: "oi1", productId: "1", productName: "Beras Rojolele 5kg", qty: 1, estimatedPrice: 65000),
            const OrderItemModel(id: "oi2", productId: "3", productName: "Minyak Bimoli 2L", qty: 2, estimatedPrice: 38000),
          ],
          subtotal: 141000,
          serviceFee: 5000,
          deliveryFee: 8000,
          discount: 0,
          total: 154000,
          customerNote: "Tolong diletakkan di depan pintu.",
          mitraName: "Budi Santoso",
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ];
}
