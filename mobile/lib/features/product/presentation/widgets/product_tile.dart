import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product, this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = product.category?.name;
    return ListTile(
      onTap: onTap,
      title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: product.sku),
            if (category != null) ...[
              const TextSpan(text: ' · '),
              TextSpan(
                text: category,
                style: TextStyle(color: theme.colorScheme.tertiary, fontWeight: FontWeight.w500),
              ),
            ],
            if (product.description.isNotEmpty) TextSpan(text: ' · ${product.description}'),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        formatRupiah(product.price),
        style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary),
      ),
    );
  }
}
