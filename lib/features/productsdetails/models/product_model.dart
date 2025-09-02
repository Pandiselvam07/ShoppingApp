class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String brand;
  final String thumbnail;
  final List<String> images;
  final String category;
  final double rating;
  final int stock;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.brand,
    required this.thumbnail,
    required this.images,
    required this.category,
    required this.rating,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      brand: json['brand'] ?? 'Unknown',
      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
    );
  }
}

class ProductsResponse {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  ProductsResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      products: (json['products'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }
}
