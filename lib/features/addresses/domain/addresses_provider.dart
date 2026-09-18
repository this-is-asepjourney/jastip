import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/addresses_repository.dart';
import '../../orders/data/order_models.dart';

final _addressesRepo = AddressesRepository();

class AddressesNotifier extends StateNotifier<AsyncValue<List<AddressModel>>> {
  AddressesNotifier() : super(const AsyncValue.loading()) {
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    state = const AsyncValue.loading();
    try {
      final addresses = await _addressesRepo.getAddresses();
      state = AsyncValue.data(addresses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAddress(Map<String, dynamic> data) async {
    final addr = await _addressesRepo.createAddress(data);
    state = AsyncValue.data([...state.value ?? [], addr]);
  }

  Future<void> updateAddress(String id, Map<String, dynamic> data) async {
    await _addressesRepo.updateAddress(id, data);
    await loadAddresses();
  }

  Future<void> deleteAddress(String id) async {
    await _addressesRepo.deleteAddress(id);
    state = AsyncValue.data(state.value?.where((a) => a.id != id).toList() ?? []);
  }
}

final addressesNotifierProvider =
    StateNotifierProvider<AddressesNotifier, AsyncValue<List<AddressModel>>>(
  (_) => AddressesNotifier(),
);

final selectedAddressIdProvider = StateProvider<String?>((ref) {
  final addresses = ref.watch(addressesNotifierProvider).value ?? [];
  if (addresses.isEmpty) return null;
  return addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first).id;
});
