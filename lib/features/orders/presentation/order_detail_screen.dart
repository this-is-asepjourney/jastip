import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../data/order_models.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final order = MockOrders.orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => MockOrders.orders.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(order.orderNumber),
        actions: [
          if (order.status.isActive)
            IconButton(
              onPressed: () =>
                  context.push('/orders/${order.id}/tracking'),
              icon: const Icon(Icons.track_changes_rounded),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status Pesanan',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.status.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (order.mitraName != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_rounded,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Mitra: ${order.mitraName}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Items
            _Card(
              title: 'Item Pesanan',
              child: Column(
                children: order.items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (item.note != null)
                                    Text(
                                      item.note!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${item.qty}x ${CurrencyFormatter.format(item.estimatedPrice)}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                if (item.actualPrice != null &&
                                    item.actualPrice != item.estimatedPrice)
                                  Text(
                                    'Aktual: ${CurrencyFormatter.format(item.actualPrice!)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.warning,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Address
            if (order.address != null)
              _Card(
                title: 'Alamat Pengantaran',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.address!.recipientName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(order.address!.phone,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(order.address!.address,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
            const SizedBox(height: 12),

            // Notes
            if (order.customerNote != null)
              _Card(
                title: 'Catatan',
                child: Text(
                  order.customerNote!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            const SizedBox(height: 12),

            // Summary
            _Card(
              title: 'Rincian Biaya',
              child: Column(
                children: [
                  _Row('Subtotal', CurrencyFormatter.format(order.subtotal)),
                  const SizedBox(height: 6),
                  _Row('Biaya Layanan',
                      CurrencyFormatter.format(order.serviceFee)),
                  const SizedBox(height: 6),
                  _Row('Ongkir', CurrencyFormatter.format(order.deliveryFee)),
                  if (order.discount > 0) ...[
                    const SizedBox(height: 6),
                    _Row(
                      'Diskon',
                      '- ${CurrencyFormatter.format(order.discount)}',
                      valueColor: AppColors.success,
                    ),
                  ],
                  const Divider(height: 16),
                  _Row(
                    'Total',
                    CurrencyFormatter.format(order.total),
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Timeline
            if (order.status.isActive)
              ElevatedButton.icon(
                onPressed: () =>
                    context.push('/orders/${order.id}/tracking'),
                icon: const Icon(Icons.track_changes_rounded),
                label: const Text('Lacak Pesanan'),
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

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _Row(this.label, this.value, {this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? (isBold ? AppColors.primary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
