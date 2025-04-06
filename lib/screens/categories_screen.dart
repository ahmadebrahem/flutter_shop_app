// // lib/screens/categories_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/products_provider.dart';
// import 'category_products_screen.dart';

// class CategoriesScreen extends StatelessWidget {
//   const CategoriesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('فئات المنتجات'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Theme.of(context).colorScheme.onPrimary,
//       ),
//       body: FutureBuilder(
//         future:
//             Provider.of<ProductsProvider>(
//               context,
//               listen: false,
//             ).fetchProducts(),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.error != null) {
//             return Center(child: Text('حدث خطأ: ${snapshot.error}'));
//           }

//           return Consumer<ProductsProvider>(
//             builder: (ctx, productsProvider, _) {
//               final categories = productsProvider.categories;

//               if (categories.isEmpty) {
//                 return const Center(child: Text('لا توجد فئات متاحة'));
//               }

//               return GridView.builder(
//                 padding: const EdgeInsets.all(16),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 3 / 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                 ),
//                 itemCount: categories.length,
//                 itemBuilder: (ctx, i) => CategoryItem(title: categories[i]),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class CategoryItem extends StatelessWidget {
//   final String title;

//   const CategoryItem({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (ctx) => CategoryProductsScreen(category: title),
//           ),
//         );
//       },
//       borderRadius: BorderRadius.circular(15),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Theme.of(context).colorScheme.primary.withOpacity(0.7),
//               Theme.of(context).colorScheme.primary,
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Center(
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
// }
// lib/screens/categories_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import 'category_products_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final categories = productsProvider.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body:
          categories.isEmpty
              ? const Center(child: Text('No categories found'))
              : ListView.builder(
                itemCount: categories.length,
                itemBuilder:
                    (ctx, i) => Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          child: Text(
                            categories[i][0].toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        title: Text(categories[i]),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (ctx) => CategoryProductsScreen(
                                    category: categories[i],
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
              ),
    );
  }
}
