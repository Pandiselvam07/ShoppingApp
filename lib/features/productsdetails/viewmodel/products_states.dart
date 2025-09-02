
import 'package:shopping_app/features/productsdetails/models/product_model.dart';

enum SortOption { none, nameAsc, nameDesc, priceLowToHigh, priceHighToLow }

class ProductsStates {
  final List<ProductModel> products;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final bool isSearching;
  final SortOption currentSort;

  ProductsStates({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.isSearching = false,
    this.currentSort = SortOption.none,
  });

  ProductsStates copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    String? error,
    String? searchQuery,
    bool? isSearching,
    SortOption? currentSort,
  }) {
    return ProductsStates(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      currentSort: currentSort ?? this.currentSort,
    );
  }

  List<ProductModel> get filteredProducts {
    List<ProductModel> filtered = searchQuery.isEmpty
        ? List.from(products)
        : products
              .where(
                (product) =>
                    product.title.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    product.brand.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    product.category.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
              )
              .toList();

    return _applySorting(filtered);
  }

  List<ProductModel> _applySorting(List<ProductModel> products) {
    final sortedProducts = List<ProductModel>.from(products);

    switch (currentSort) {
      case SortOption.nameAsc:
        sortedProducts.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case SortOption.nameDesc:
        sortedProducts.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        break;
      case SortOption.priceLowToHigh:
        sortedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        sortedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.none:
        break;
    }

    return sortedProducts;
  }

  String get sortDisplayText {
    switch (currentSort) {
      case SortOption.nameAsc:
        return 'Name (A-Z)';
      case SortOption.nameDesc:
        return 'Name (Z-A)';
      case SortOption.priceLowToHigh:
        return 'Price (Low to High)';
      case SortOption.priceHighToLow:
        return 'Price (High to Low)';
      case SortOption.none:
        return 'Default';
    }
  }

  bool get hasProducts => products.isNotEmpty;
  bool get hasFilteredProducts => filteredProducts.isNotEmpty;
  bool get showEmptyState =>
      !isLoading && !hasFilteredProducts && searchQuery.isNotEmpty;
  bool get showNoProductsState =>
      !isLoading && !hasProducts && searchQuery.isEmpty;
  bool get hasSorting => currentSort != SortOption.none;
}
