// // lib/screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/products_provider.dart';
// import '../providers/cart_provider.dart';
// import '../widgets/product_item.dart';
// import 'cart_screen.dart';
// import 'profile_screen.dart';
// import 'categories_screen.dart';
// import 'search_screen.dart';
// import 'category_products_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('متجرنا الإلكتروني'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Theme.of(context).colorScheme.onPrimary,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               Navigator.of(
//                 context,
//               ).push(MaterialPageRoute(builder: (ctx) => const SearchScreen()));
//             },
//             tooltip: 'البحث',
//           ),
//           IconButton(
//             icon: const Icon(Icons.person),
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(builder: (ctx) => const ProfileScreen()),
//               );
//             },
//             tooltip: 'الملف الشخصي',
//           ),
//           Consumer<CartProvider>(
//             builder:
//                 (_, cart, ch) => Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.shopping_cart),
//                       onPressed: () {
//                         Navigator.of(context).pushNamed('/cart');
//                       },
//                       tooltip: 'سلة التسوق',
//                     ),
//                     if (cart.itemCount > 0)
//                       Positioned(
//                         right: 8,
//                         top: 8,
//                         child: Container(
//                           padding: const EdgeInsets.all(2.0),
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).colorScheme.secondary,
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           constraints: const BoxConstraints(
//                             minWidth: 16,
//                             minHeight: 16,
//                           ),
//                           child: Text(
//                             '${cart.itemCount}',
//                             style: const TextStyle(
//                               fontSize: 10,
//                               color: Colors.white,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//           ),
//         ],
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
//               final featuredProducts = productsProvider.featuredProducts;
//               final categories = productsProvider.categories;

//               return SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // بانر ترويجي
//                     Container(
//                       width: double.infinity,
//                       height: 200,
//                       margin: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         gradient: LinearGradient(
//                           colors: [
//                             Theme.of(context).colorScheme.primary,
//                             Theme.of(context).colorScheme.secondary,
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'عروض خاصة!',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),

//                     // الفئات
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 5,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'الفئات',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (ctx) => const CategoriesScreen(),
//                                 ),
//                               );
//                             },
//                             child: const Text('عرض الكل'),
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(
//                       height: 100,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         itemCount: categories.length,
//                         itemBuilder:
//                             (ctx, i) => Container(
//                               width: 100,
//                               margin: const EdgeInsets.only(right: 10),
//                               child: InkWell(
//                                 onTap: () {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder:
//                                           (ctx) => CategoryProductsScreen(
//                                             category: categories[i],
//                                           ),
//                                     ),
//                                   );
//                                 },
//                                 borderRadius: BorderRadius.circular(15),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(
//                                       context,
//                                     ).colorScheme.primary.withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       categories[i],
//                                       style: TextStyle(
//                                         color:
//                                             Theme.of(
//                                               context,
//                                             ).colorScheme.primary,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                       ),
//                     ),

//                     // المنتجات المميزة
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 5,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'منتجات مميزة',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               // يمكن إضافة شاشة لعرض جميع المنتجات المميزة
//                             },
//                             child: const Text('عرض الكل'),
//                           ),
//                         ],
//                       ),
//                     ),

//                     if (featuredProducts.isEmpty)
//                       const Center(child: Text('لا توجد منتجات مميزة'))
//                     else
//                       GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         padding: const EdgeInsets.all(10.0),
//                         itemCount: featuredProducts.length,
//                         itemBuilder:
//                             (ctx, i) => ProductItem(
//                               id: featuredProducts[i].id,
//                               title: featuredProducts[i].title,
//                               imageUrl: featuredProducts[i].imageUrl,
//                               price: featuredProducts[i].price,
//                             ),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               childAspectRatio: 3 / 2,
//                               crossAxisSpacing: 10,
//                               mainAxisSpacing: 10,
//                             ),
//                       ),

//                     // أحدث المنتجات
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 5,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'أحدث المنتجات',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               // يمكن إضافة شاشة لعرض جميع المنتجات
//                             },
//                             child: const Text('عرض الكل'),
//                           ),
//                         ],
//                       ),
//                     ),

//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       padding: const EdgeInsets.all(10.0),
//                       itemCount:
//                           productsProvider.items.length > 4
//                               ? 4
//                               : productsProvider.items.length,
//                       itemBuilder:
//                           (ctx, i) => ProductItem(
//                             id: productsProvider.items[i].id,
//                             title: productsProvider.items[i].title,
//                             imageUrl: productsProvider.items[i].imageUrl,
//                             price: productsProvider.items[i].price,
//                           ),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             childAspectRatio: 3 / 2,
//                             crossAxisSpacing: 10,
//                             mainAxisSpacing: 10,
//                           ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/product_item.dart';
import 'categories_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchProducts().then((_) {
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
    final authProvider = Provider.of<AuthProvider>(context);
    final featuredProducts = productsProvider.featuredProducts;
    final categories = productsProvider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => const SearchScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () => productsProvider.fetchProducts(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categories section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Categories',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => const CategoriesScreen(),
                                  ),
                                );
                              },
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 120,
                        child:
                            categories.isEmpty
                                ? const Center(
                                  child: Text('No categories found'),
                                )
                                : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder:
                                      (ctx, i) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (ctx) =>
                                                        CategoryProductsScreen(
                                                          category:
                                                              categories[i],
                                                        ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundColor: Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                    .withOpacity(0.2),
                                                child: Text(
                                                  categories[i][0]
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(categories[i]),
                                            ],
                                          ),
                                        ),
                                      ),
                                ),
                      ),

                      // Featured products section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text(
                          'Featured Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      featuredProducts.isEmpty
                          ? const Center(
                            child: Text('No featured products found'),
                          )
                          : GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2 / 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: featuredProducts.length,
                            itemBuilder:
                                (ctx, i) =>
                                    ProductItem(product: featuredProducts[i]),
                          ),
                    ],
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
