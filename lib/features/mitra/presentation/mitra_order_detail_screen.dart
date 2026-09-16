import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../orders/data/order_models.dart';

class MitraOrderDetailScreen extends StatefulWidget {
  final String orderId;

  const MitraOrderDetailScreen({super.key, required this.orderId});

  @override
  State<MitraOrderDetailScreen> createState() => _MitraOrderDetailScreenState();
}

class _MitraOrderDetailScreenState extends State<MitraOrderDetailScreen> {
  late OrderStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    final order = MockOrders.orders.firstWhere(
      (o) => o.id == widget.orderId,
      orElse: () => MockOrders.orders.first,
    );
    _currentStatus = order.status;
  }

  OrderStatus? get _nextStatus {
    switch (_currentStatus) {
      case OrderStatus.pending:
        return OrderStatus.confirmed;
      case OrderStatus.confirmed:
        return OrderStatus.shopping;
      case OrderStatus.shopping:
        return OrderStatus.readyToDeliver;
      case OrderStatus.readyToDeliver:
        return OrderStatus.onDelivery;
      case OrderStatus.onDelivery:
        return OrderStatus.delivered;
      default:
        return null;
    }
  }

  String get _nextStatusLabel {
    switch (_nextStatus) {
      case OrderStatus.confirmed:
        return 'Konfirmasi Pesanan';
      case OrderStatus.shopping:
        return 'Mulai Belanja';
      case OrderStatus.readyToDeliver:
        return 'Siap Dikirim';
      case OrderStatus.onDelivery:
        return 'Mulai Kirim';
      case OrderStatus.delivered:
        return 'Tandai Terkirim';
      default:
        return '';
    }
  }

  void _updateStatus() {
    if (_nextStatus == null) return;
    setState(() => _currentStatus = _nextStatus!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status diperbarui: ${_currentStatus.label}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = MockOrders.orders.firstWhere(
      (o) => o.id == widget.orderId,
      orElse: () => MockOrders.orders.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detail Pesanan'),
            Text(
              order.orderNumber,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status Saat Ini',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentStatus.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Customer info
            _Card(
              title: 'Informasi Customer',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.person_rounded,
                          size: 16, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Ahmad Wirosari',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.phone_rounded,
                          size: 16, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('081234567890'),
                    ],
                  ),
                  if (order.address != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.address!.address,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Shopping list
            _Card(
              title: 'Daftar Belanja',
              child: Column(
                children: order.items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.check_box_outline_blank_rounded,
                                size: 14,
                                color: AppColors.textHint,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${item.qty}x — Est. ${CurrencyFormatter.format(item.estimatedPrice)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  if (item.note != null)
                                    Text(
                                      '📝 ${item.note}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.warning,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),

            if (order.customerNote != null)
              _Card(
                title: 'Catatan Customer',
                child: Text(
                  order.customerNote!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Update status button
            if (_nextStatus != null)
              ElevatedButton.icon(
                onPressed: _updateStatus,
                icon: const Icon(Icons.update_rounded),
                label: Text(_nextStatusLabel),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border.fromBorderSide(
          BorderSide(color: AppColors.divider),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
