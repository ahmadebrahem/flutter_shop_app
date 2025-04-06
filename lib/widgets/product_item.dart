// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/cart_provider.dart';
// import '../screens/product_detail_screen.dart';

// class ProductItem extends StatelessWidget {
//   final String id;
//   final String title;
//   final String imageUrl;
//   final double price;

//   const ProductItem({
//     super.key,
//     required this.id,
//     required this.title,
//     required this.imageUrl,
//     required this.price,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<CartProvider>(context, listen: false);

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: GridTile(
//         footer: GridTileBar(
//           backgroundColor: Colors.black87,
//           title: Text(title, textAlign: TextAlign.center),
//           subtitle: Text(
//             '${price.toString()} ريال',
//             textAlign: TextAlign.center,
//           ),
//           trailing: IconButton(
//             icon: const Icon(Icons.shopping_cart),
//             onPressed: () {
//               cart.addItem(id, price, title);
//               ScaffoldMessenger.of(context).hideCurrentSnackBar();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('تمت إضافة المنتج إلى سلة التسوق!'),
//                   duration: const Duration(seconds: 2),
//                   action: SnackBarAction(
//                     label: 'تراجع',
//                     onPressed: () {
//                       cart.removeSingleItem(id);
//                     },
//                   ),
//                 ),
//               );
//             },
//             color: Theme.of(context).colorScheme.secondary,
//           ),
//         ),
//         child: GestureDetector(
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (ctx) => ProductDetailScreen(productId: id),
//               ),
//             );
//           },
//           child: Image.network(imageUrl, fit: BoxFit.cover),
//         ),
//       ),
//     );
//   }
// }
// lib/widgets/product_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                product.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (ctx, error, _) => Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 50),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  cartProvider.addItem(product);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Added item to cart!'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cartProvider.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  minimumSize: const Size(0, 30),
                ),
                child: const Text('Add to Cart'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
