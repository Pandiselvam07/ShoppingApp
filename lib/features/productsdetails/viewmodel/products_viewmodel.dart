import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/features/productsdetails/viewmodel/products_states.dart';
import 'dart:async';
import '../repository/products_repository.dart';

class ProductsViewModel extends StateNotifier<ProductsStates> {
  final ProductsRepository _repository;
  Timer? _searchTimer;

  ProductsViewModel(this._repository) : super(ProductsStates());

  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.fetchProducts();
      state = state.copyWith(products: response.products, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);

    _searchTimer?.cancel();

    if (query.isEmpty) {
      state = state.copyWith(isSearching: false);
      return;
    }

    state = state.copyWith(isSearching: true);

    _searchTimer = Timer(const Duration(milliseconds: 250), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    try {
      state = state.copyWith(isSearching: true, error: null);
      final response = await _repository.searchProducts(query);
      state = state.copyWith(products: response.products, isSearching: false);
    } catch (e) {
      state = state.copyWith(isSearching: false, error: e.toString());
    }
  }

  void clearSearch() {
    _searchTimer?.cancel();
    state = state.copyWith(searchQuery: '', isSearching: false);
    fetchProducts();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  void setSortOption(SortOption sortOption) {
    state = state.copyWith(currentSort: sortOption);
  }

  void clearSort() {
    state = state.copyWith(currentSort: SortOption.none);
  }

  void toggleSort(SortType sortType) {
    SortOption newSort;

    switch (sortType) {
      case SortType.name:
        newSort = state.currentSort == SortOption.nameAsc
            ? SortOption.nameDesc
            : SortOption.nameAsc;
        break;
      case SortType.price:
        newSort = state.currentSort == SortOption.priceLowToHigh
            ? SortOption.priceHighToLow
            : SortOption.priceLowToHigh;
        break;
    }

    setSortOption(newSort);
  }

  SortDirection getSortDirection(SortType sortType) {
    switch (sortType) {
      case SortType.name:
        if (state.currentSort == SortOption.nameAsc) {
          return SortDirection.ascending;
        }
        if (state.currentSort == SortOption.nameDesc) {
          return SortDirection.descending;
        }
        break;
      case SortType.price:
        if (state.currentSort == SortOption.priceLowToHigh) {
          return SortDirection.ascending;
        }
        if (state.currentSort == SortOption.priceHighToLow) {
          return SortDirection.descending;
        }
        break;
    }
    return SortDirection.none;
  }
}

enum SortType { name, price }

enum SortDirection { none, ascending, descending }
