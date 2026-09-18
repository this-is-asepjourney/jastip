import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_router.dart';

class CustomJastipScreen extends StatefulWidget {
  const CustomJastipScreen({super.key});

  @override
  State<CustomJastipScreen> createState() => _CustomJastipScreenState();
}

class _CustomJastipScreenState extends State<CustomJastipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameCtrl = TextEditingController();
  final _storeCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');
  final _noteCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _productNameCtrl.dispose();
    _storeCtrl.dispose();
    _qtyCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Buat Penawaran'),
            Text(
              'Driver akan membelikan & mengantarkan',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Banner alur baru ───────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      AppColors.primaryLight.withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: const Row(
                  children: [
                    Text('🛵', style: TextStyle(fontSize: 28)),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bagaimana cara kerjanya?',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Isi detail barang → Driver terdekat lihat di peta → Driver belanja & antar ke rumahmu.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Detail Barang ──────────────────────────────────────
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

              // ── Titik Koordinat (COMING SOON) ──────────────────────
              const Text(
                'Titik Lokasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              // Lokasi toko belanja
              _LocationFieldComingSoon(
                icon: Icons.store_rounded,
                iconColor: AppColors.secondary,
                title: 'Lokasi Toko Belanja',
                subtitle: 'Tandai di peta tempat driver harus belanja',
                badgeLabel: 'Coming Soon',
              ),
              const SizedBox(height: 10),

              // Lokasi antar / tujuan
              _LocationFieldComingSoon(
                icon: Icons.home_rounded,
                iconColor: AppColors.primary,
                title: 'Lokasi Pengantaran',
                subtitle: 'Tandai di peta tujuan pengantaran barang',
                badgeLabel: 'Coming Soon',
              ),
              const SizedBox(height: 8),

              // Keterangan sementara
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.25),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_rounded,
                        color: AppColors.secondary, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sementara menggunakan alamat default di profilmu. Fitur pilih koordinat dari peta segera hadir!',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Alamat Antar (sementara dari profil) ──────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                  border: const Border.fromBorderSide(
                    BorderSide(color: AppColors.border),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        color: AppColors.primary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Alamat Pengantaran (Default)',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Jl. Merdeka No. 12, Wirosari, Grobogan',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                label: const Text('Kirim Penawaran ke Driver'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widget lokasi coming soon ─────────────────────────────────────────────

class _LocationFieldComingSoon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badgeLabel;

  const _LocationFieldComingSoon({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badgeLabel,
              style: const TextStyle(
                color: AppColors.secondary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
