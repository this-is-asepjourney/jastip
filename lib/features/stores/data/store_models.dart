// Store model
class StoreModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String? image;
  final String status;
  final double? latitude;
  final double? longitude;

  const StoreModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    this.image,
    this.status = 'ACTIVE',
    this.latitude,
    this.longitude,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        address: json['address'] ?? '',
        image: json['image'],
        status: json['status'] ?? 'ACTIVE',
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
      );
}

// Category model
class CategoryModel {
  final String id;
  final String name;
  final String? image;
  final String status;

  const CategoryModel({
    required this.id,
    required this.name,
    this.image,
    this.status = 'ACTIVE',
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        image: json['image'],
        status: json['status'] ?? 'ACTIVE',
      );
}

// Product model
class ProductModel {
  final String id;
  final String storeId;
  final String storeName;
  final String? categoryId;
  final String name;
  final String description;
  final double price;
  final String? image;
  final int stock;
  final String status;

  const ProductModel({
    required this.id,
    required this.storeId,
    required this.storeName,
    this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    required this.stock,
    this.status = 'ACTIVE',
  });

  bool get isAvailable => status == 'ACTIVE' && stock > 0;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] ?? '',
        storeId: json['store_id'] ?? '',
        storeName: json['store_name'] ?? '',
        categoryId: json['category_id'],
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        image: json['image'],
        stock: (json['stock'] as num?)?.toInt() ?? 0,
        status: json['status'] ?? 'ACTIVE',
      );
}

// Mock data
class MockData {
  static final List<CategoryModel> categories = [
    const CategoryModel(id: '1', name: 'Sembako', image: null),
    const CategoryModel(id: '2', name: 'Makanan', image: null),
    const CategoryModel(id: '3', name: 'Minuman', image: null),
    const CategoryModel(id: '4', name: 'Sayur & Buah', image: null),
    const CategoryModel(id: '5', name: 'Perawatan', image: null),
    const CategoryModel(id: '6', name: 'Elektronik', image: null),
    const CategoryModel(id: '7', name: 'Fashion', image: null),
    const CategoryModel(id: '8', name: 'Lainnya', image: null),
  ];

  static final List<StoreModel> stores = [
    const StoreModel(
      id: '1',
      name: 'Indomaret Wirosari',
      description: 'Minimarket lengkap di pusat kota Wirosari.',
      address: 'Jl. Wirosari No. 1, Wirosari, Grobogan',
      latitude: -7.0564,
      longitude: 111.0031,
    ),
    const StoreModel(
      id: '2',
      name: 'Alfamart Wirosari',
      description: 'Belanja kebutuhan sehari-hari dengan harga terjangkau.',
      address: 'Jl. Raya Wirosari, Wirosari, Grobogan',
      latitude: -7.0571,
      longitude: 111.0038,
    ),
    const StoreModel(
      id: '3',
      name: 'Toko Sembako Bu Sri',
      description: 'Sembako lengkap, harga grosir.',
      address: 'Pasar Wirosari, Wirosari, Grobogan',
    ),
    const StoreModel(
      id: '4',
      name: 'Warung Makan Pak Budi',
      description: 'Masakan rumahan, lauk-pauk segar setiap hari.',
      address: 'Jl. Veteran Wirosari, Grobogan',
    ),
  ];

  static final List<ProductModel> products = [
    ProductModel(
      id: '1',
      storeId: '1',
      storeName: 'Indomaret Wirosari',
      categoryId: '1',
      name: 'Beras Rojolele 5kg',
      description: 'Beras kualitas premium, pulen dan wangi.',
      price: 65000,
      stock: 50,
    ),
    ProductModel(
      id: '2',
      storeId: '1',
      storeName: 'Indomaret Wirosari',
      categoryId: '3',
      name: 'Aqua 1.5L',
      description: 'Air mineral dalam kemasan botol besar.',
      price: 5000,
      stock: 100,
    ),
    ProductModel(
      id: '3',
      storeId: '1',
      storeName: 'Indomaret Wirosari',
      categoryId: '1',
      name: 'Minyak Bimoli 2L',
      description: 'Minyak goreng sawit pilihan.',
      price: 38000,
      stock: 30,
    ),
    ProductModel(
      id: '4',
      storeId: '2',
      storeName: 'Alfamart Wirosari',
      categoryId: '2',
      name: 'Indomie Goreng Ayam',
      description: 'Mi instan favorit rasa ayam panggang.',
      price: 3500,
      stock: 200,
    ),
    ProductModel(
      id: '5',
      storeId: '2',
      storeName: 'Alfamart Wirosari',
      categoryId: '5',
      name: 'Sabun Lifebuoy 100g',
      description: 'Sabun antibakteri untuk perlindungan keluarga.',
      price: 5500,
      stock: 80,
    ),
    ProductModel(
      id: '6',
      storeId: '3',
      storeName: 'Toko Sembako Bu Sri',
      categoryId: '1',
      name: 'Gula Pasir 1kg',
      description: 'Gula pasir putih berkualitas.',
      price: 16000,
      stock: 60,
    ),
  ];
}
