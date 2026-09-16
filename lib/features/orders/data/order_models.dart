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
      case OrderStatus.pending:
        return 'Menunggu';
      case OrderStatus.confirmed:
        return 'Dikonfirmasi';
      case OrderStatus.shopping:
        return 'Sedang Belanja';
      case OrderStatus.readyToDeliver:
        return 'Siap Dikirim';
      case OrderStatus.onDelivery:
        return 'Dalam Pengiriman';
      case OrderStatus.delivered:
        return 'Terkirim';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
      case OrderStatus.waitingQuote:
        return 'Menunggu Harga';
      case OrderStatus.waitingApproval:
        return 'Menunggu Persetujuan';
    }
  }

  static OrderStatus fromString(String s) {
    switch (s.toUpperCase()) {
      case 'CONFIRMED':
        return OrderStatus.confirmed;
      case 'SHOPPING':
        return OrderStatus.shopping;
      case 'READY_TO_DELIVER':
        return OrderStatus.readyToDeliver;
      case 'ON_DELIVERY':
        return OrderStatus.onDelivery;
      case 'DELIVERED':
        return OrderStatus.delivered;
      case 'CANCELLED':
        return OrderStatus.cancelled;
      case 'WAITING_QUOTE':
        return OrderStatus.waitingQuote;
      case 'WAITING_APPROVAL':
        return OrderStatus.waitingApproval;
      default:
        return OrderStatus.pending;
    }
  }

  bool get isActive => ![
        OrderStatus.delivered,
        OrderStatus.cancelled,
      ].contains(this);

  int get stepIndex {
    switch (this) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.shopping:
        return 2;
      case OrderStatus.readyToDeliver:
        return 3;
      case OrderStatus.onDelivery:
        return 4;
      case OrderStatus.delivered:
        return 5;
      default:
        return 0;
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
        id: json['id'] ?? '',
        productId: json['product_id'],
        productName: json['product_name'] ?? '',
        qty: (json['qty'] as num?)?.toInt() ?? 1,
        estimatedPrice: (json['estimated_price'] as num?)?.toDouble() ?? 0,
        actualPrice: (json['actual_price'] as num?)?.toDouble(),
        note: json['note'],
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
        id: json['id'] ?? '',
        label: json['label'] ?? '',
        recipientName: json['recipient_name'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        isDefault: json['is_default'] ?? false,
        note: json['note'],
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
      );
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] ?? '',
        orderNumber: json['order_number'] ?? '',
        orderType: json['order_type'] == 'CUSTOM_JASTIP'
            ? OrderType.customJastip
            : OrderType.product,
        status: OrderStatusExt.fromString(json['status'] ?? 'PENDING'),
        items: (json['items'] as List<dynamic>?)
                ?.map((e) => OrderItemModel.fromJson(e))
                .toList() ??
            [],
        address: json['address'] != null
            ? AddressModel.fromJson(json['address'])
            : null,
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
        serviceFee: (json['service_fee'] as num?)?.toDouble() ?? 0,
        deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
        discount: (json['discount'] as num?)?.toDouble() ?? 0,
        total: (json['total'] as num?)?.toDouble() ?? 0,
        customerNote: json['customer_note'],
        mitraName: json['mitra_name'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : DateTime.now(),
      );
}

// Mock orders
class MockOrders {
  static List<OrderModel> get orders => [
        OrderModel(
          id: 'o1',
          orderNumber: 'JW-20240916-001',
          orderType: OrderType.product,
          status: OrderStatus.onDelivery,
          items: [
            const OrderItemModel(
              id: 'oi1',
              productId: '1',
              productName: 'Beras Rojolele 5kg',
              qty: 1,
              estimatedPrice: 65000,
            ),
            const OrderItemModel(
              id: 'oi2',
              productId: '3',
              productName: 'Minyak Bimoli 2L',
              qty: 2,
              estimatedPrice: 38000,
            ),
          ],
          subtotal: 141000,
          serviceFee: 5000,
          deliveryFee: 8000,
          discount: 0,
          total: 154000,
          customerNote: 'Tolong diletakkan di depan pintu.',
          mitraName: 'Budi Santoso',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        OrderModel(
          id: 'o2',
          orderNumber: 'JW-20240915-008',
          orderType: OrderType.customJastip,
          status: OrderStatus.delivered,
          items: [
            const OrderItemModel(
              id: 'oi3',
              productName: 'Minyak Bimoli 2 Liter',
              qty: 2,
              estimatedPrice: 38000,
              actualPrice: 38500,
              note: 'Dari Indomaret Wirosari',
            ),
          ],
          subtotal: 77000,
          serviceFee: 5000,
          deliveryFee: 8000,
          discount: 0,
          total: 90000,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 20)),
        ),
      ];
}
