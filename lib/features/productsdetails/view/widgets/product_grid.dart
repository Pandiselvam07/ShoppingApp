import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/features/productsdetails/models/product_model.dart';
import 'package:shopping_app/features/productsdetails/view/widgets/product_card.dart';
import '../../providers/products_providers.dart';

class ProductGrid extends ConsumerWidget {
  final List<ProductModel> products;
  final BoxConstraints constraints;

  const ProductGrid({
    super.key,
    required this.products,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = ref.watch(screenSizeProvider(constraints.maxWidth));
    final columns = ref.watch(gridColumnsProvider(screenSize));

    double padding = 16.0;
    double spacing = 16.0;

    if (screenSize == ScreenSize.desktop ||
        screenSize == ScreenSize.largeDesktop) {
      padding = 24.0;
      spacing = 20.0;
    }

    double aspectRatio = 0.75;
    if (screenSize == ScreenSize.mobile) {
      aspectRatio = 0.8;
    } else if (screenSize == ScreenSize.tablet) {
      aspectRatio = 0.75;
    } else {
      aspectRatio = 0.7;
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: screenSize == ScreenSize.largeDesktop
            ? 1400
            : double.infinity,
      ),
      child: GridView.builder(
        padding: EdgeInsets.all(padding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index], screenSize: screenSize);
        },
      ),
    );
  }
}
