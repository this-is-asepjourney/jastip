import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_models.dart';
import '../../orders/data/order_models.dart';
import '../../../core/storage/local_storage.dart';

// Auth state
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isLoggedIn => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
  }) =>
      AuthState(
        user: clearUser ? null : user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

// Auth provider
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final role = LocalStorage.getUserRole();
    final id = LocalStorage.getUserId();
    if (role != null && id != null) {
      // Mock user from storage
      state = AuthState(
        user: UserModel(
          id: id,
          name: 'User',
          phone: '',
          role: UserRoleExt.fromString(role),
        ),
      );
    }
  }

  Future<void> login(String phone, String password) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1)); // Mock API call

    // Mock: any credentials work for demo
    const mockUser = UserModel(
      id: 'u1',
      name: 'Ahmad Wirosari',
      phone: '081234567890',
      email: 'ahmad@wirosari.id',
      role: UserRole.customer,
    );

    await LocalStorage.saveAccessToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
    await LocalStorage.saveUserRole('CUSTOMER');
    await LocalStorage.saveUserId('u1');

    state = AuthState(user: mockUser);
  }

  Future<void> loginAsMitra(String phone, String password) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));

    const mockMitra = UserModel(
      id: 'm1',
      name: 'Budi Santoso',
      phone: '082345678901',
      role: UserRole.mitra,
    );

    await LocalStorage.saveAccessToken('mock_mitra_token');
    await LocalStorage.saveUserRole('MITRA');
    await LocalStorage.saveUserId('m1');

    state = AuthState(user: mockMitra);
  }

  Future<void> register(String name, String phone, String password,
      [String? email]) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));

    final newUser = UserModel(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      email: email,
      role: UserRole.customer,
    );

    await LocalStorage.saveAccessToken('mock_token_new');
    await LocalStorage.saveUserRole('CUSTOMER');
    await LocalStorage.saveUserId(newUser.id);

    state = AuthState(user: newUser);
  }

  Future<void> logout() async {
    await LocalStorage.clearAll();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (_) => AuthNotifier(),
);

// Address provider (mock)
final addressesProvider = StateProvider<List<AddressModel>>((_) => [
      const AddressModel(
        id: 'a1',
        label: 'Rumah',
        recipientName: 'Ahmad Wirosari',
        phone: '081234567890',
        address: 'Jl. Merdeka No. 12, Wirosari, Grobogan',
        isDefault: true,
        note: 'Rumah warna hijau, pagar besi',
      ),
      const AddressModel(
        id: 'a2',
        label: 'Kantor',
        recipientName: 'Ahmad Wirosari',
        phone: '081234567890',
        address: 'Jl. Gadjah Mada No. 5, Wirosari, Grobogan',
      ),
    ]);

final selectedAddressProvider = StateProvider<AddressModel?>(
  (ref) => ref.watch(addressesProvider).firstWhere(
        (a) => a.isDefault,
        orElse: () => ref.watch(addressesProvider).first,
      ),
);
