import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../auth/domain/auth_provider.dart';
import '../../driver/data/driver_models.dart';
import '../../driver/domain/driver_provider.dart';
import '../../driver/presentation/driver_map_screen.dart';
import '../../auth/data/auth_models.dart';
import '../../orders/data/order_models.dart';
import '../../../routes/app_router.dart';

class MitraHomeScreen extends ConsumerStatefulWidget {
  const MitraHomeScreen({super.key});

  @override
  ConsumerState<MitraHomeScreen> createState() => _MitraHomeScreenState();
}

class _MitraHomeScreenState extends ConsumerState<MitraHomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final isOnline = ref.watch(driverOnlineProvider);
    final myActiveOffers = ref.watch(myActiveOffersProvider);
    // pendingOffers is shown via DriverMapScreen tab

    return Scaffold(
      body: IndexedStack(
        index: _navIndex,
        children: [
          // Tab 0: Peta penawaran
          const DriverMapScreen(),

          // Tab 1: Pesanan aktif saya
          _ActiveOrdersTab(
            user: user,
            isOnline: isOnline,
            activeOffers: myActiveOffers,
          ),

          // Tab 2: Profil driver
          _ProfileTab(user: user),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        indicatorColor: AppColors.primaryLight,
        backgroundColor: Colors.white,
        elevation: 8,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.map_rounded),
            selectedIcon: const Icon(Icons.map_rounded,
                color: AppColors.primary),
            label: 'Peta',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: myActiveOffers.isNotEmpty,
              label: Text('${myActiveOffers.length}'),
              child: const Icon(Icons.receipt_long_rounded),
            ),
            selectedIcon: Badge(
              isLabelVisible: myActiveOffers.isNotEmpty,
              label: Text('${myActiveOffers.length}'),
              child: const Icon(Icons.receipt_long_rounded,
                  color: AppColors.primary),
            ),
            label: 'Pesanan',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_rounded),
            selectedIcon: const Icon(Icons.person_rounded,
                color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ─── Tab Pesanan Aktif ──────────────────────────────────────────────────────

class _ActiveOrdersTab extends StatelessWidget {
  final UserModel? user;
  final bool isOnline;
  final List<OfferModel> activeOffers;

  const _ActiveOrdersTab({
    required this.user,
    required this.isOnline,
    required this.activeOffers,
  });

  @override
  Widget build(BuildContext context) {
    final mockOrders = MockOrders.orders;
    final activeOrders = mockOrders.where((o) {
      return o.status != OrderStatus.pending &&
          o.status != OrderStatus.delivered &&
          o.status != OrderStatus.cancelled;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryDark, AppColors.primary],
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ${user?.name.split(' ').first ?? 'Driver'} 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isOnline
                          ? 'Kamu sedang Online — siap terima order'
                          : 'Kamu sedang Offline',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _StatCard(
                          label: 'Penawaran Tersedia',
                          value: '${activeOffers.length}',
                          icon: Icons.local_offer_rounded,
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          label: 'Pesanan Aktif',
                          value: '${activeOrders.length}',
                          icon: Icons.directions_bike_rounded,
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          label: 'Selesai Hari Ini',
                          value: '${mockOrders.where((o) => o.status == OrderStatus.delivered).length}',
                          icon: Icons.check_circle_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Pesanan yang sedang dikerjakan (offer yang sudah diambil)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order yang Saya Ambil',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (activeOffers.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${activeOffers.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            if (activeOffers.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.inbox_rounded,
                            size: 48, color: AppColors.textHint),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada order yang diambil.\nBuka tab Peta untuk melihat penawaran.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _ActiveOfferCard(offer: activeOffers[i]),
                  childCount: activeOffers.length,
                ),
              ),

            // Pesanan lama (mock)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: const Text(
                  'Riwayat Pesanan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _OldOrderCard(order: activeOrders[i]),
                childCount: activeOrders.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

// ─── Active Offer Card (dari mock) ───────────────────────────────────────────

class _ActiveOfferCard extends StatelessWidget {
  final OfferModel offer;
  const _ActiveOfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag_rounded,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  offer.storeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Diambil',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            offer.itemSummary,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.home_rounded,
                  size: 12, color: AppColors.textHint),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  offer.deliveryAddress,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Old Order Card ───────────────────────────────────────────────────────────

class _OldOrderCard extends StatelessWidget {
  final OrderModel order;
  const _OldOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/mitra/orders/${order.id}'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(Icons.receipt_long_rounded,
                color: AppColors.textHint, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${order.items.length} item — ${order.items.map((i) => i.productName).take(2).join(', ')}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              CurrencyFormatter.format(order.total),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tab Profil ───────────────────────────────────────────────────────────────

class _ProfileTab extends ConsumerWidget {
  final UserModel? user;
  const _ProfileTab({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil Driver'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Keluar'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (user?.name ?? 'D').substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              user?.name ?? 'Driver',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Center(
            child: Text(
              user?.phone ?? '-',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Driver Jastip',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Stats card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DriverStat(label: 'Total Order', value: '48'),
                _DriverStat(label: 'Rating', value: '4.9 ⭐'),
                _DriverStat(label: 'Bergabung', value: '3 bln'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Menu
          _ProfileMenuItem(
            icon: Icons.history_rounded,
            label: 'Riwayat Pengiriman',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Penghasilan',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.directions_bike_rounded,
            label: 'Kendaraan',
            onTap: () {},
          ),
          _ProfileMenuItem(
            icon: Icons.help_outline_rounded,
            label: 'Bantuan',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _DriverStat extends StatelessWidget {
  final String label;
  final String value;
  const _DriverStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      );
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ProfileMenuItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(label,
          style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing:
          const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    );
  }
}

// ─── Stat Card ─────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
