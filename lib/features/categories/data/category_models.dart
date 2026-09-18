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

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        image: json["image"],
        isActive: json["isActive"] ?? true,
        productCount: json["_count"]?["products"],
      );
}
