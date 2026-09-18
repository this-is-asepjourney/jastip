import 'package:flutter/material.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;
  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.$1.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.$1.withValues(alpha: 0.3)),
      ),
      child: Text(
        config.$2,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: config.$1),
      ),
    );
  }

  (Color, String) _getConfig(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING': return (Colors.orange, 'Menunggu');
      case 'CONFIRMED': return (Colors.blue, 'Dikonfirmasi');
      case 'SHOPPING': return (Colors.purple, 'Belanja');
      case 'READY_TO_DELIVER': return (Colors.teal, 'Siap Kirim');
      case 'ON_DELIVERY': return (Colors.indigo, 'Dikirim');
      case 'DELIVERED': return (Colors.green, 'Terkirim');
      case 'CANCELLED': return (Colors.red, 'Dibatalkan');
      case 'WAITING_QUOTE': return (Colors.orange, 'Tunggu Harga');
      case 'WAITING_APPROVAL': return (Colors.amber, 'Tunggu Approve');
      default: return (Colors.grey, status);
    }
  }
}
