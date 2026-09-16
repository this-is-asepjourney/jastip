import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/domain/auth_provider.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/stores/presentation/stores_screen.dart';
import '../features/stores/presentation/store_detail_screen.dart';
import '../features/products/presentation/product_detail_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/checkout/presentation/checkout_screen.dart';
import '../features/orders/presentation/orders_screen.dart';
import '../features/orders/presentation/order_detail_screen.dart';
import '../features/orders/presentation/order_tracking_screen.dart';
import '../features/jastip/presentation/custom_jastip_screen.dart';
import '../features/addresses/presentation/addresses_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/mitra/presentation/mitra_home_screen.dart';
import '../features/mitra/presentation/mitra_order_detail_screen.dart';

// Route names
class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const stores = '/stores';
  static const storeDetail = '/stores/:id';
  static const productDetail = '/products/:id';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orders = '/orders';
  static const orderDetail = '/orders/:id';
  static const orderTracking = '/orders/:id/tracking';
  static const customJastip = '/jastip/custom';
  static const addresses = '/addresses';
  static const profile = '/profile';
  static const mitraHome = '/mitra';
  static const mitraOrderDetail = '/mitra/orders/:id';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (isSplash || isOnboarding || isAuthRoute) return null;

      if (!isLoggedIn) return AppRoutes.login;

      // Redirect mitra to mitra dashboard
      if (authState.user?.role.name == 'MITRA' &&
          !state.matchedLocation.startsWith('/mitra')) {
        return AppRoutes.mitraHome;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.stores,
        builder: (_, __) => const StoresScreen(),
      ),
      GoRoute(
        path: AppRoutes.storeDetail,
        builder: (_, state) => StoreDetailScreen(
          storeId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        builder: (_, state) => ProductDetailScreen(
          productId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (_, __) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (_, __) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.orders,
        builder: (_, __) => const OrdersScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderDetail,
        builder: (_, state) => OrderDetailScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.orderTracking,
        builder: (_, state) => OrderTrackingScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.customJastip,
        builder: (_, __) => const CustomJastipScreen(),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        builder: (_, __) => const AddressesScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.mitraHome,
        builder: (_, __) => const MitraHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.mitraOrderDetail,
        builder: (_, state) => MitraOrderDetailScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Halaman tidak ditemukan: ${state.error}'),
      ),
    ),
  );
});
