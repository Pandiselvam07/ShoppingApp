import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/products_repository.dart';
import '../viewmodel/products_states.dart';
import '../viewmodel/products_viewmodel.dart';

// Repository Provider
final productRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepository();
});

// Products ViewModel Provider
final productsViewModelProvider =
    StateNotifierProvider<ProductsViewModel, ProductsStates>((ref) {
      final repository = ref.watch(productRepositoryProvider);
      return ProductsViewModel(repository);
    });

// Responsive breakpoint providers
final screenSizeProvider = Provider.family<ScreenSize, double>((ref, width) {
  if (width < 600) return ScreenSize.mobile;
  if (width < 900) return ScreenSize.tablet;
  if (width < 1200) return ScreenSize.desktop;
  return ScreenSize.largeDesktop;
});

enum ScreenSize { mobile, tablet, desktop, largeDesktop }

// Grid columns provider based on screen size
final gridColumnsProvider = Provider.family<int, ScreenSize>((ref, screenSize) {
  switch (screenSize) {
    case ScreenSize.mobile:
      return 1;
    case ScreenSize.tablet:
      return 2;
    case ScreenSize.desktop:
      return 3;
    case ScreenSize.largeDesktop:
      return 4;
  }
});

// Detail layout provider
final isDetailLayoutLargeProvider = Provider.family<bool, double>((ref, width) {
  return width > 768;
});
final toggleFavoritedProvider = Provider.family<bool, bool>(
  (ref, isFavorited) => !isFavorited,
);
