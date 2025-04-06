// // lib/screens/search_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/products_provider.dart';
// import '../widgets/product_item.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final _searchController = TextEditingController();
//   List<dynamic> _searchResults = [];
//   bool _isSearching = false;
//   RangeValues _priceRange = const RangeValues(0, 1000);
//   double _maxPrice = 1000;

//   @override
//   void initState() {
//     super.initState();
//     _initMaxPrice();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _initMaxPrice() async {
//     final productsProvider = Provider.of<ProductsProvider>(
//       context,
//       listen: false,
//     );
//     await productsProvider.fetchProducts();

//     if (productsProvider.items.isNotEmpty) {
//       final highestPrice = productsProvider.items
//           .map((product) => product.price)
//           .reduce((value, element) => value > element ? value : element);

//       setState(() {
//         _maxPrice = highestPrice.ceilToDouble() + 100;
//         _priceRange = RangeValues(0, _maxPrice);
//       });
//     }
//   }

//   Future<void> _search() async {
//     if (_searchController.text.isEmpty) {
//       return;
//     }

//     setState(() {
//       _isSearching = true;
//     });

//     try {
//       final productsProvider = Provider.of<ProductsProvider>(
//         context,
//         listen: false,
//       );
//       final searchResults = productsProvider.searchProducts(
//         _searchController.text,
//       );

//       // تطبيق تصفية السعر
//       final filteredResults =
//           searchResults.where((product) {
//             return product.price >= _priceRange.start &&
//                 product.price <= _priceRange.end;
//           }).toList();

//       setState(() {
//         _searchResults = filteredResults;
//         _isSearching = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isSearching = false;
//       });

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('البحث عن المنتجات'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Theme.of(context).colorScheme.onPrimary,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     labelText: 'البحث عن المنتجات',
//                     hintText: 'أدخل اسم المنتج',
//                     prefixIcon: const Icon(Icons.search),
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: () {
//                         _searchController.clear();
//                         setState(() {
//                           _searchResults = [];
//                         });
//                       },
//                     ),
//                     border: const OutlineInputBorder(),
//                   ),
//                   onSubmitted: (_) => _search(),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     const Text('نطاق السعر:'),
//                     const SizedBox(width: 8),
//                     Text(
//                       '${_priceRange.start.toStringAsFixed(0)} - ${_priceRange.end.toStringAsFixed(0)} ريال',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 RangeSlider(
//                   values: _priceRange,
//                   min: 0,
//                   max: _maxPrice,
//                   divisions: 20,
//                   labels: RangeLabels(
//                     _priceRange.start.toStringAsFixed(0),
//                     _priceRange.end.toStringAsFixed(0),
//                   ),
//                   onChanged: (values) {
//                     setState(() {
//                       _priceRange = values;
//                     });
//                   },
//                   onChangeEnd: (_) => _search(),
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: _search,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).colorScheme.primary,
//                     foregroundColor: Theme.of(context).colorScheme.onPrimary,
//                   ),
//                   child: const Text('بحث'),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(),
//           if (_isSearching)
//             const Expanded(child: Center(child: CircularProgressIndicator()))
//           else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
//             const Expanded(child: Center(child: Text('لا توجد نتائج للبحث')))
//           else if (_searchResults.isNotEmpty)
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(10.0),
//                 itemCount: _searchResults.length,
//                 itemBuilder:
//                     (ctx, i) => ProductItem(
//                       id: _searchResults[i].id,
//                       title: _searchResults[i].title,
//                       imageUrl: _searchResults[i].imageUrl,
//                       price: _searchResults[i].price,
//                     ),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 3 / 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  RangeValues _priceRange = const RangeValues(0, 5000);
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final allProducts = productsProvider.items;

    // Filter products based on search query and price range
    final filteredProducts =
        allProducts.where((product) {
          final matchesQuery =
              product.title.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              product.description.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
          final matchesPrice =
              product.price >= _priceRange.start &&
              product.price <= _priceRange.end;
          return matchesQuery && matchesPrice;
        }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter product name or description',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                              _isSearching = false;
                            });
                          },
                        )
                        : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _isSearching = true;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                  _isSearching = true;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('Price Range:'),
                Expanded(
                  child: RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 5000,
                    divisions: 50,
                    labels: RangeLabels(
                      '\$${_priceRange.start.toStringAsFixed(0)}',
                      '\$${_priceRange.end.toStringAsFixed(0)}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _isSearching && _searchQuery.isEmpty
                    ? const Center(child: Text('Enter a search term'))
                    : filteredProducts.isEmpty
                    ? const Center(child: Text('No products found'))
                    : GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: filteredProducts.length,
                      itemBuilder:
                          (ctx, i) => ProductItem(product: filteredProducts[i]),
                    ),
          ),
        ],
      ),
    );
  }
}
