import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../data/order_models.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final order = MockOrders.orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => MockOrders.orders.first,
    );

    final steps = [
      _TrackingStep(
        icon: Icons.receipt_rounded,
        label: 'Pesanan Dibuat',
        description: 'Pesananmu sudah diterima sistem.',
        status: 'DONE',
      ),
      _TrackingStep(
        icon: Icons.check_circle_rounded,
        label: 'Dikonfirmasi',
        description: 'Mitra sudah menerima pesananmu.',
        status: order.status.stepIndex >= 1 ? 'DONE' : 'PENDING',
      ),
      _TrackingStep(
        icon: Icons.shopping_basket_rounded,
        label: 'Sedang Belanja',
        description: 'Mitra sedang berbelanja di toko.',
        status: order.status.stepIndex >= 2 ? 'DONE' : 'PENDING',
      ),
      _TrackingStep(
        icon: Icons.inventory_rounded,
        label: 'Siap Dikirim',
        description: 'Barang sudah siap dan akan segera dikirim.',
        status: order.status.stepIndex >= 3 ? 'DONE' : 'PENDING',
      ),
      _TrackingStep(
        icon: Icons.delivery_dining_rounded,
        label: 'Dalam Pengiriman',
        description: 'Mitra sedang mengantar pesananmu.',
        status: order.status.stepIndex >= 4 ? 'DONE' : 'PENDING',
        isActive: order.status == OrderStatus.onDelivery,
      ),
      _TrackingStep(
        icon: Icons.home_rounded,
        label: 'Terkirim',
        description: 'Pesanan berhasil diterima. Terima kasih!',
        status: order.status == OrderStatus.delivered ? 'DONE' : 'PENDING',
        isLast: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lacak Pesanan'),
            Text(
              order.orderNumber,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.track_changes_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    order.status.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (order.mitraName != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Mitra: ${order.mitraName}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Tracking stepper
            ...steps.asMap().entries.map((entry) {
              final i = entry.key;
              final step = entry.value;
              final isDone = step.status == 'DONE';
              final isActive = step.isActive ||
                  (i == order.status.stepIndex && !isDone);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDone
                              ? AppColors.primary
                              : isActive
                                  ? AppColors.primaryLight
                                  : AppColors.surfaceVariant,
                          shape: BoxShape.circle,
                          border: isActive
                              ? Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Icon(
                          step.icon,
                          color: isDone
                              ? Colors.white
                              : isActive
                                  ? AppColors.primary
                                  : AppColors.textHint,
                          size: 22,
                        ),
                      ),
                      if (!step.isLast)
                        Container(
                          width: 2,
                          height: 48,
                          color: isDone
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.label,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDone || isActive
                                  ? AppColors.textPrimary
                                  : AppColors.textHint,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            step.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDone
                                  ? AppColors.textSecondary
                                  : AppColors.textHint,
                            ),
                          ),
                          SizedBox(height: step.isLast ? 0 : 36),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TrackingStep {
  final IconData icon;
  final String label;
  final String description;
  final String status;
  final bool isActive;
  final bool isLast;

  const _TrackingStep({
    required this.icon,
    required this.label,
    required this.description,
    required this.status,
    this.isActive = false,
    this.isLast = false,
  });
}
