import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../data/driver_models.dart';
import '../domain/driver_provider.dart';

// Pusat Wirosari — titik awal peta
const _wirosariCenter = LatLng(-7.0626, 110.9149);

// Warna marker per jenis toko
final _storeColors = [
  const Color(0xFF2E7D32), // hijau
  const Color(0xFF1565C0), // biru
  const Color(0xFFE65100), // oranye
  const Color(0xFF6A1B9A), // ungu
  const Color(0xFFC62828), // merah
];

class DriverMapScreen extends ConsumerStatefulWidget {
  const DriverMapScreen({super.key});

  @override
  ConsumerState<DriverMapScreen> createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends ConsumerState<DriverMapScreen>
    with TickerProviderStateMixin {
  final _mapController = MapController();
  OfferModel? _selectedOffer;
  bool _isSheetVisible = false;
  late AnimationController _sheetAnim;

  @override
  void initState() {
    super.initState();
    _sheetAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  void dispose() {
    _sheetAnim.dispose();
    super.dispose();
  }

  void _onMarkerTap(OfferModel offer) {
    setState(() {
      _selectedOffer = offer;
      _isSheetVisible = true;
    });
    _sheetAnim.forward(from: 0);
    _mapController.move(offer.storeLocation, 15.5);
  }

  void _closeSheet() {
    _sheetAnim.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isSheetVisible = false;
          _selectedOffer = null;
        });
      }
    });
  }

  void _takeOffer(String offerId) {
    ref.read(offersProvider.notifier).takeOffer(offerId);
    _closeSheet();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('Order berhasil diambil! Segera belanja.'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(driverOnlineProvider);
    final pendingOffers = ref.watch(pendingOffersProvider);

    return Scaffold(
      body: Stack(
        children: [
          // ── Peta OpenStreetMap ──────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _wirosariCenter,
              initialZoom: 14.5,
              minZoom: 10,
              maxZoom: 18,
            ),
            children: [
              // Tile layer (OpenStreetMap — gratis)
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.jastipwirosari.app',
              ),

              // Marker layer — titik toko (lokasi belanja)
              MarkerLayer(
                markers: pendingOffers.asMap().entries.map((entry) {
                  final i = entry.key;
                  final offer = entry.value;
                  final color = _storeColors[i % _storeColors.length];
                  final isSelected = _selectedOffer?.id == offer.id;

                  return Marker(
                    point: offer.storeLocation,
                    width: isSelected ? 64 : 52,
                    height: isSelected ? 64 : 52,
                    child: GestureDetector(
                      onTap: () => _onMarkerTap(offer),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color
                              : color.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: isSelected ? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: isSelected ? 16 : 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_rounded,
                              color: Colors.white,
                              size: isSelected ? 22 : 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Marker tujuan antar (hanya untuk offer terpilih)
              if (_selectedOffer != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedOffer!.deliveryLocation,
                      width: 48,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.home_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),

              // Garis antar toko → rumah customer (saat offer dipilih)
              if (_selectedOffer != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [
                        _selectedOffer!.storeLocation,
                        _selectedOffer!.deliveryLocation,
                      ],
                      strokeWidth: 3,
                      color: AppColors.primary.withValues(alpha: 0.6),
                      pattern: const StrokePattern.dotted(),
                    ),
                  ],
                ),
            ],
          ),

          // ── Header overlay ──────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppColors.success
                            : AppColors.textSecondary,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isOnline ? 'Online' : 'Offline',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Toggle online/offline
                    GestureDetector(
                      onTap: () => ref
                          .read(driverOnlineProvider.notifier)
                          .state = !isOnline,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          isOnline ? 'Set Offline' : 'Set Online',
                          style: TextStyle(
                            color: isOnline
                                ? AppColors.error
                                : AppColors.success,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Counter penawaran aktif
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${pendingOffers.length} penawaran',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Offline overlay ─────────────────────────────────────────
          if (!isOnline)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: false,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(32),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.offline_bolt_rounded,
                              size: 36,
                              color: AppColors.textHint,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Kamu Sedang Offline',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Aktifkan status Online untuk\nmelihat penawaran dari customer.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => ref
                                .read(driverOnlineProvider.notifier)
                                .state = true,
                            child: const Text('Aktifkan Online'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ── Dimmer ketika sheet terbuka ─────────────────────────────
          if (_isSheetVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeSheet,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),

          // ── Bottom Sheet Penawaran ──────────────────────────────────
          if (_isSheetVisible && _selectedOffer != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _sheetAnim,
                  curve: Curves.easeOutCubic,
                )),
                child: _OfferSheet(
                  offer: _selectedOffer!,
                  onClose: _closeSheet,
                  onTake: () => _takeOffer(_selectedOffer!.id),
                ),
              ),
            ),
        ],
      ),

      // ── FAB Refresh ─────────────────────────────────────────────────
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Kembali ke pusat Wirosari
          FloatingActionButton.small(
            heroTag: 'center',
            onPressed: () => _mapController.move(_wirosariCenter, 14.5),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            child: const Icon(Icons.my_location_rounded),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.small(
            heroTag: 'refresh',
            onPressed: () {
              ref.read(offersProvider.notifier).refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Memuat ulang penawaran...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textSecondary,
            child: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Sheet Penawaran ────────────────────────────────────────────────────

class _OfferSheet extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback onClose;
  final VoidCallback onTake;

  const _OfferSheet({
    required this.offer,
    required this.onClose,
    required this.onTake,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
              color: AppColors.textHint,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.orderNumber,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            offer.storeName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'dari ${offer.customerName}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Daftar barang
                const Text(
                  'Barang yang diminta',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...offer.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${item.name} x${item.qty}'
                            '${item.note != null ? '  — ${item.note}' : ''}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 14),

                // Alamat antar
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.home_rounded,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Antar ke',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            offer.deliveryAddress,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (offer.estimatedBudget != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.payments_rounded,
                          size: 18, color: AppColors.secondary),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estimasi budget',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            currency.format(offer.estimatedBudget),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Estimasi',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),

                // Tombol ambil order
                ElevatedButton.icon(
                  onPressed: onTake,
                  icon: const Icon(Icons.directions_bike_rounded),
                  label: const Text('Ambil Order Ini'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: onClose,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.divider),
                  ),
                  child: const Text('Lewati'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
