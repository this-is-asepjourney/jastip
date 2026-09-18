class AppConstants {
  // Pricing
  static const double defaultServiceFee = 5000;
  static const double defaultDeliveryFeeZoneA = 5000;
  static const double defaultDeliveryFeeZoneB = 8000;
  static const double defaultDeliveryFeeZoneC = 12000;

  // Order status labels (Indonesian)
  static const Map<String, String> orderStatusLabels = {
    'PENDING': 'Menunggu Konfirmasi',
    'CONFIRMED': 'Dikonfirmasi',
    'SHOPPING': 'Sedang Belanja',
    'READY_TO_DELIVER': 'Siap Dikirim',
    'ON_DELIVERY': 'Dalam Pengiriman',
    'DELIVERED': 'Terkirim',
    'CANCELLED': 'Dibatalkan',
    'WAITING_QUOTE': 'Menunggu Harga',
    'WAITING_APPROVAL': 'Menunggu Persetujuan',
  };

  // App info
  static const String appName = 'Jastip Wirosari';
  static const String appTagline = 'Belanja Lebih Mudah di Wirosari';
}
