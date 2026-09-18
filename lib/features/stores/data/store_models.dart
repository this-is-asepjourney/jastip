// Store model
class StoreModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String? image;
  final bool isActive;
  final double? latitude;
  final double? longitude;
  final int? productCount;

  const StoreModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    this.image,
    this.isActive = true,
    this.latitude,
    this.longitude,
    this.productCount,
  });

  String get status => isActive ? 'ACTIVE' : 'INACTIVE';

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        address: json["address"] ?? "",
        image: json["image"],
        isActive: json["isActive"] ?? json["status"] == "ACTIVE" || true,
        latitude: (json["latitude"] as num?)?.toDouble(),
        longitude: (json["longitude"] as num?)?.toDouble(),
        productCount: json["_count"]?["products"],
      );
}

// Category model
class CategoryModel {
  final String id;
  final String name;
  final String? image;
  final bool isActive;
  final int? productCount;

  const CategoryModel({
    required this.id,
    required this.name,
    this.image,
    this.isActive = true,
    this.productCount,
  });

  String get status => isActive ? 'ACTIVE' : 'INACTIVE';

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        image: json["image"],
        isActive: json["isActive"] ?? true,
        productCount: json["_count"]?["products"],
      );
}

// Product model
class ProductModel {
  final String id;
  final String storeId;
  final String storeName;
  final String? categoryId;
  final String? categoryName;
  final String name;
  final String description;
  final double price;
  final String? image;
  final int stock;
  final bool isAvailable;

  const ProductModel({
    required this.id,
    required this.storeId,
    required this.storeName,
    this.categoryId,
    this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    required this.stock,
    this.isAvailable = true,
  });

  String get status => isAvailable ? 'ACTIVE' : 'INACTIVE';

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"] ?? "",
        storeId: json["storeId"] ?? json["store_id"] ?? "",
        storeName: json["store"]?["name"] ?? json["store_name"] ?? "",
        categoryId: json["categoryId"] ?? json["category_id"],
        categoryName: json["category"]?["name"],
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        price: (json["price"] as num?)?.toDouble() ?? 0,
        image: json["image"],
        stock: (json["stock"] as num?)?.toInt() ?? 0,
        isAvailable: json["isAvailable"] ?? true,
      );
}

// Mock data (fallback ketika API tidak tersedia)
class MockData {
  static final List<CategoryModel> categories = [
    const CategoryModel(id: "1", name: "Sembako"),
    const CategoryModel(id: "2", name: "Makanan"),
    const CategoryModel(id: "3", name: "Minuman"),
    const CategoryModel(id: "4", name: "Sayur & Buah"),
    const CategoryModel(id: "5", name: "Perawatan"),
    const CategoryModel(id: "6", name: "Elektronik"),
    const CategoryModel(id: "7", name: "Fashion"),
    const CategoryModel(id: "8", name: "Lainnya"),
  ];

  static final List<StoreModel> stores = [
    const StoreModel(
      id: "1",
      name: "Indomaret Wirosari",
      description: "Minimarket lengkap di pusat kota Wirosari.",
      address: "Jl. Wirosari No. 1, Wirosari, Grobogan",
      latitude: -7.0564,
      longitude: 111.0031,
    ),
    const StoreModel(
      id: "2",
      name: "Alfamart Wirosari",
      description: "Belanja kebutuhan sehari-hari dengan harga terjangkau.",
      address: "Jl. Raya Wirosari, Wirosari, Grobogan",
      latitude: -7.0571,
      longitude: 111.0038,
    ),
    const StoreModel(
      id: "3",
      name: "Toko Sembako Bu Sri",
      description: "Sembako lengkap, harga grosir.",
      address: "Pasar Wirosari, Wirosari, Grobogan",
    ),
  ];

  static final List<ProductModel> products = [
    ProductModel(id: "1", storeId: "1", storeName: "Indomaret Wirosari", categoryId: "1", name: "Beras Rojolele 5kg", description: "Beras kualitas premium, pulen dan wangi.", price: 65000, stock: 50),
    ProductModel(id: "2", storeId: "1", storeName: "Indomaret Wirosari", categoryId: "3", name: "Aqua 1.5L", description: "Air mineral dalam kemasan botol besar.", price: 5000, stock: 100),
    ProductModel(id: "3", storeId: "1", storeName: "Indomaret Wirosari", categoryId: "1", name: "Minyak Bimoli 2L", description: "Minyak goreng sawit pilihan.", price: 38000, stock: 30),
    ProductModel(id: "4", storeId: "2", storeName: "Alfamart Wirosari", categoryId: "2", name: "Indomie Goreng Ayam", description: "Mi instan favorit rasa ayam panggang.", price: 3500, stock: 200),
    ProductModel(id: "5", storeId: "2", storeName: "Alfamart Wirosari", categoryId: "5", name: "Sabun Lifebuoy 100g", description: "Sabun antibakteri untuk perlindungan keluarga.", price: 5500, stock: 80),
    ProductModel(id: "6", storeId: "3", storeName: "Toko Sembako Bu Sri", categoryId: "1", name: "Gula Pasir 1kg", description: "Gula pasir putih berkualitas.", price: 16000, stock: 60),
  ];
}
