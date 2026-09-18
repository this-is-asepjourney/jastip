import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../data/auth_models.dart';
import '../data/auth_repository.dart';
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
    bool clearError = false,
  }) => AuthState(
        user: clearUser ? null : user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error,
      );
}

final _authRepo = AuthRepository();

// Auth provider
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final role = LocalStorage.getUserRole();
    final id = LocalStorage.getUserId();
    if (role != null && id != null) {
      state = AuthState(
        user: UserModel(
          id: id,
          name: LocalStorage.getUserName() ?? 'User',
          phone: '',
          role: UserRoleExt.fromString(role),
        ),
      );
      // Fetch real user data
      _fetchMe();
    }
  }

  Future<void> _fetchMe() async {
    try {
      final user = await _authRepo.getMe();
      await LocalStorage.saveUserName(user.name);
      state = state.copyWith(user: user);
    } catch (_) {}
  }

  Future<void> login(String phone, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await _authRepo.login(phone, password);
      final user = UserModel.fromJson(data['user']);
      await LocalStorage.saveUserName(user.name);
      state = AuthState(user: user);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Login gagal. Periksa nomor HP dan password Anda.';
      state = state.copyWith(isLoading: false, error: msg.toString());
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Terjadi kesalahan. Coba lagi.');
    }
  }

  Future<void> register(String name, String phone, String password, [String? email]) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await _authRepo.register(name, phone, password, email);
      final user = UserModel.fromJson(data['user']);
      await LocalStorage.saveUserName(user.name);
      state = AuthState(user: user);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Registrasi gagal.';
      state = state.copyWith(isLoading: false, error: msg.toString());
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Terjadi kesalahan. Coba lagi.');
    }
  }

  Future<void> logout() async {
    await _authRepo.logout();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (_) => AuthNotifier(),
);

// Address providers
final addressesProvider = StateProvider<List<AddressModel>>((_) => []);

final selectedAddressProvider = StateProvider<AddressModel?>(
  (ref) {
    final addresses = ref.watch(addressesProvider);
    if (addresses.isEmpty) return null;
    return addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => addresses.first,
    );
  },
);
