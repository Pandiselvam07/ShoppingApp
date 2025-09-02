import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error.dart';
import '../../../../core/widgets/loading.dart';
import '../../providers/products_providers.dart';
import '../widgets/custom_drop_down_button.dart';
import '../widgets/product_grid.dart';
import '../widgets/search_bar.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsViewModelProvider.notifier).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsViewModelProvider);
    final viewModel = ref.read(productsViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenSize = ref.watch(
              screenSizeProvider(constraints.maxWidth),
            );
            final isLargeScreen =
                screenSize == ScreenSize.desktop ||
                screenSize == ScreenSize.largeDesktop;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: true,
                  elevation: 2,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  title: Text(
                    'Products',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isLargeScreen ? 28 : 24,
                    ),
                  ),
                  centerTitle: !isLargeScreen,
                  actions: isLargeScreen
                      ? [
                          Container(
                            width: 500,
                            margin: const EdgeInsets.only(
                              right: 16,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(child: SearchBarWidget()),
                                Expanded(
                                  child: SortDropdown(
                                    selectedSort: state.currentSort,
                                    onSortSelected: viewModel.setSortOption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      : null,
                ),

                if (!isLargeScreen)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(child: SearchBarWidget()),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SortDropdown(
                              selectedSort: state.currentSort,
                              onSortSelected: viewModel.setSortOption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SliverFillRemaining(
                  child: _buildContent(state, viewModel, constraints),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(state, viewModel, BoxConstraints constraints) {
    if (state.isLoading && state.products.isEmpty) {
      return const LoadingWidget();
    }

    if (state.error != null && state.products.isEmpty) {
      return CustomErrorWidget(
        error: state.error!,
        onRetry: () {
          viewModel.clearError();
          viewModel.fetchProducts();
        },
      );
    }

    if (state.showNoProductsState) {
      return const EmptyStateWidget(
        icon: Icons.shopping_bag_outlined,
        title: 'No Products Available',
        subtitle: 'Check back later for new products',
      );
    }

    if (state.showEmptyState) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No Products Found',
        subtitle: 'Try adjusting your search terms',
        actionLabel: 'Clear Search',
        onAction: viewModel.clearSearch,
      );
    }

    return Column(
      children: [
        if (state.searchQuery.isNotEmpty || state.hasSorting)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Found ${state.filteredProducts.length} products${state.searchQuery.isNotEmpty ? ' for "${state.searchQuery}"' : ''}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (state.hasSorting)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Sorted by ${state.sortDisplayText}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: ProductGrid(
            products: state.filteredProducts,
            constraints: constraints,
          ),
        ),
      ],
    );
  }
}
