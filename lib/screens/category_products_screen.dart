// // lib/screens/category_products_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/products_provider.dart';
// import '../widgets/product_item.dart';

// class CategoryProductsScreen extends StatelessWidget {
//   final String category;

//   const CategoryProductsScreen({super.key, required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(category),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Theme.of(context).colorScheme.onPrimary,
//       ),
//       body: FutureBuilder(
//         future: Provider.of<ProductsProvider>(
//           context,
//           listen: false,
//         ).fetchProductsByCategory(category),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.error != null) {
//             return Center(child: Text('حدث خطأ: ${snapshot.error}'));
//           }

//           return Consumer<ProductsProvider>(
//             builder: (ctx, productsProvider, _) {
//               final products = productsProvider.items;

//               if (products.isEmpty) {
//                 return const Center(child: Text('لا توجد منتجات في هذه الفئة'));
//               }

//               return GridView.builder(
//                 padding: const EdgeInsets.all(10.0),
//                 itemCount: products.length,
//                 itemBuilder:
//                     (ctx, i) => ProductItem(
//                       id: products[i].id,
//                       title: products[i].title,
//                       imageUrl: products[i].imageUrl,
//                       price: products[i].price,
//                     ),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 3 / 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// lib/screens/category_products_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(
        context,
      ).fetchProductsByCategory(widget.category).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = productsProvider.items;

    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : products.isEmpty
              ? const Center(child: Text('No products found in this category'))
              : GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (ctx, i) => ProductItem(product: products[i]),
              ),
    );
  }
}
