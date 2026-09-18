import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_router.dart';
import '../../driver/data/driver_repository.dart';
import '../../auth/domain/auth_provider.dart';

class CustomJastipScreen extends ConsumerStatefulWidget {
  const CustomJastipScreen({super.key});

  @override
  ConsumerState<CustomJastipScreen> createState() => _CustomJastipScreenState();
}

class _CustomJastipScreenState extends ConsumerState<CustomJastipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameCtrl = TextEditingController();
  final _storeCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');
  final _noteCtrl = TextEditingController();
  bool _isSubmitting = false;

  final _repo = DriverRepository();

  LatLng? _storeLocation;
  LatLng? _deliveryLocation;

  @override
  void dispose() {
    _productNameCtrl.dispose();
    _storeCtrl.dispose();
    _qtyCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickLocation(bool isStore) async {
    final initialLoc = isStore ? _storeLocation : _deliveryLocation;
    final title = isStore ? 'Pilih Lokasi Toko' : 'Pilih Lokasi Pengantaran';

    final result = await context.push<LatLng>(
      AppRoutes.mapPicker,
      extra: {
        'title': title,
        'initialLocation': initialLoc,
      },
    );

    if (result != null) {
      setState(() {
        if (isStore) {
          _storeLocation = result;
        } else {
          _deliveryLocation = result;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_storeLocation == null || _deliveryLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap pilih lokasi toko dan lokasi pengantaran di peta!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    
    try {
      final address = ref.read(selectedAddressProvider);
      
      await _repo.createOffer(
        itemName: _productNameCtrl.text,
        storeName: _storeCtrl.text,
        qty: int.tryParse(_qtyCtrl.text) ?? 1,
        note: _noteCtrl.text.isEmpty ? null : _noteCtrl.text,
        addressId: address?.id,
        storeLocation: _storeLocation!,
        deliveryLocation: _deliveryLocation!,
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryDark, AppColors.primary],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Penawaran Terkirim!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Driver di sekitarmu akan melihat penawaran ini di peta dan segera mengambil order.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.orders);
                  },
                  child: const Text('Lihat Status Pesanan'),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat penawaran: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buat Penawaran',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Driver akan belikan pesananmu',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Detail Barang ────────────────────────────────────────
              const Text(
                'Detail Barang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _productNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang *',
                  hintText: 'Contoh: Minyak Bimoli 2 Liter',
                  prefixIcon: Icon(Icons.inventory_2_rounded),
                ),
                validator: (v) =>
                    (v?.isEmpty ?? true) ? 'Masukkan nama barang' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _storeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Toko / Tempat Belanja *',
                  hintText: 'Contoh: Indomaret Wirosari',
                  prefixIcon: Icon(Icons.store_rounded),
                ),
                validator: (v) =>
                    (v?.isEmpty ?? true) ? 'Masukkan nama toko' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah *',
                  prefixIcon: Icon(Icons.numbers_rounded),
                ),
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Masukkan jumlah';
                  final n = int.tryParse(v!);
                  if (n == null || n < 1) return 'Minimal 1';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _noteCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  hintText: 'Contoh: Jika merek tidak ada, boleh diganti.',
                  prefixIcon: Icon(Icons.notes_rounded),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              // ── Titik Koordinat (Map Picker) ──────────────────────
              const Text(
                'Titik Lokasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              // Lokasi toko belanja
              _LocationFieldActive(
                icon: Icons.store_rounded,
                iconColor: AppColors.secondary,
                title: 'Lokasi Toko Belanja *',
                subtitle: _storeLocation == null
                    ? 'Ketuk untuk pilih di peta'
                    : 'Sudah dipilih: ${_storeLocation!.latitude.toStringAsFixed(4)}, ${_storeLocation!.longitude.toStringAsFixed(4)}',
                isSet: _storeLocation != null,
                onTap: () => _pickLocation(true),
              ),
              const SizedBox(height: 10),

              // Lokasi antar / tujuan
              _LocationFieldActive(
                icon: Icons.home_rounded,
                iconColor: AppColors.primary,
                title: 'Lokasi Pengantaran *',
                subtitle: _deliveryLocation == null
                    ? 'Ketuk untuk pilih di peta'
                    : 'Sudah dipilih: ${_deliveryLocation!.latitude.toStringAsFixed(4)}, ${_deliveryLocation!.longitude.toStringAsFixed(4)}',
                isSet: _deliveryLocation != null,
                onTap: () => _pickLocation(false),
              ),
              
              const SizedBox(height: 32),

              // ── Tombol Submit ──────────────────────────────────────
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(
                  _isSubmitting ? 'Memproses...' : 'Kirim Penawaran',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widget lokasi aktif ─────────────────────────────────────────────

class _LocationFieldActive extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isSet;
  final VoidCallback onTap;

  const _LocationFieldActive({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isSet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSet ? AppColors.success : AppColors.border,
            width: isSet ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isSet ? AppColors.success : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: isSet ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSet ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
              color: isSet ? AppColors.success : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
