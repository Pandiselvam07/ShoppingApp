import 'package:flutter/material.dart';

import '../../viewmodel/products_states.dart';

class SortDropdown extends StatelessWidget {
  final SortOption selectedSort;
  final Function(SortOption) onSortSelected;

  const SortDropdown({
    super.key,
    required this.selectedSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
        color: selectedSort != SortOption.none
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortOption>(
          value: selectedSort,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(
                Icons.sort,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Sort',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: selectedSort != SortOption.none
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          dropdownColor: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          elevation: 8,
          items: _buildDropdownItems(context),
          selectedItemBuilder: (context) => _buildSelectedItems(context),
          onChanged: (SortOption? value) {
            if (value != null) {
              onSortSelected(value);
            }
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<SortOption>> _buildDropdownItems(BuildContext context) {
    return [
      DropdownMenuItem(
        value: SortOption.none,
        child: _buildDropdownItem(
          context,
          Icons.clear,
          'Default',
          'Original order',
          isSelected: selectedSort == SortOption.none,
        ),
      ),
      DropdownMenuItem(
        value: SortOption.nameAsc,
        child: _buildDropdownItem(
          context,
          Icons.sort_by_alpha,
          'Name (A-Z)',
          'Alphabetical ascending',
          isSelected: selectedSort == SortOption.nameAsc,
        ),
      ),
      DropdownMenuItem(
        value: SortOption.nameDesc,
        child: _buildDropdownItem(
          context,
          Icons.sort_by_alpha,
          'Name (Z-A)',
          'Alphabetical descending',
          isSelected: selectedSort == SortOption.nameDesc,
          rotateIcon: true,
        ),
      ),
      DropdownMenuItem(
        value: SortOption.priceLowToHigh,
        child: _buildDropdownItem(
          context,
          Icons.trending_up,
          'Price (Low to High)',
          'Cheapest first',
          isSelected: selectedSort == SortOption.priceLowToHigh,
        ),
      ),
      DropdownMenuItem(
        value: SortOption.priceHighToLow,
        child: _buildDropdownItem(
          context,
          Icons.trending_down,
          'Price (High to Low)',
          'Most expensive first',
          isSelected: selectedSort == SortOption.priceHighToLow,
        ),
      ),
    ];
  }

  List<Widget> _buildSelectedItems(BuildContext context) {
    return [
      _buildSelectedItem(context, Icons.clear, 'Default'),
      _buildSelectedItem(context, Icons.sort_by_alpha, 'Name A-Z'),
      _buildSelectedItem(context, Icons.sort_by_alpha, 'Name Z-A'),
      _buildSelectedItem(context, Icons.trending_up, 'Price ↑'),
      _buildSelectedItem(context, Icons.trending_down, 'Price ↓'),
    ];
  }

  Widget _buildDropdownItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    bool isSelected = false,
    bool rotateIcon = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Transform.rotate(
            angle: rotateIcon ? 3.14159 : 0,
            child: Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }

  Widget _buildSelectedItem(BuildContext context, IconData icon, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: selectedSort != SortOption.none
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: selectedSort != SortOption.none
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: selectedSort != SortOption.none
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
