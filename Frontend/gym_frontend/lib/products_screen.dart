import 'package:flutter/material.dart';
import 'dart:convert';
import 'dashboard_back_button.dart';
import 'product_details_screen.dart';
import 'widgets/hover_card.dart';
import 'theme.dart';
import 'l10n/app_localizations.dart';
import 'config/api_config.dart';
import 'config/api_client.dart';

class ProductsScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProductsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProducts); 
    fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    setState(() {
      _loading = true;
      _dataLoaded = false;
    });
    try {
      final res = await ApiClient.get('/api/products');
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is List) {
          setState(() {
            products = decoded.map<Map<String, dynamic>>((e) {
              if (e is Map<String, dynamic>) return e;
              print('Unexpected element type: ${e.runtimeType}');
              return {};
            }).toList();
            _filterProducts(); 
            _dataLoaded = true;
          });
        } else {
          print('Unexpected response type: ${decoded.runtimeType}');
          showError(AppLocalizations.of(context)!.productsUnexpectedDataFormat);
        }
      } else {
        showError('${AppLocalizations.of(context)!.productsErrorFetching}: ${res.statusCode}');
        print('fetchProducts statusCode=${res.statusCode} body=${res.body}');
      }
    } catch (e, st) {
      print('Error in fetchProducts: $e\n$st');
      showError(AppLocalizations.of(context)!.productsErrorFetching);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = products.where((product) {
        final productName = (product['name'] ?? '').toLowerCase();
        return productName.contains(query);
      }).toList();
    });
  }

  void showError(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void openProductDetails(int? prodId) async {
    if (prodId == null && widget.user['type_account'] != 'admin') return;

    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(prodId: prodId, user: widget.user),
        ),
      );
      
      // Always refresh the product list after returning
      await fetchProducts();
      
    } catch (e, st) {
      print('Error in openProductDetails: $e\n$st');
      showError(AppLocalizations.of(context)!.productsErrorOpeningDetails);
    }
  }

  Future<void> deleteProduct(int? prodId) async {
    if (prodId == null) return;
    
    // Show confirmation dialog
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDeleteTitle),
          content: Text(AppLocalizations.of(context)!.confirmDeleteProductMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    setState(() => _loading = true);
    try {
      final res = await ApiClient.delete('/api/products/$prodId');
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final msg = decoded['message'] ?? AppLocalizations.of(context)!.productsDeleteSuccess;
        showError(msg);
        
        // Remove from local list immediately for better UX
        setState(() {
          products.removeWhere((p) => p['id'] == prodId);
          _filterProducts(); // Update filtered list as well
        });
      } else {
        showError('${AppLocalizations.of(context)!.productsDeleteFailed}: ${res.statusCode}');
        print('deleteProduct statusCode=${res.statusCode} body=${res.body}');
      }
    } catch (e, st) {
      print('Error in deleteProduct: $e\n$st');
      showError(AppLocalizations.of(context)!.productsErrorDeleting);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget buildProductCard(Map<String, dynamic> prod) {
    final int? prodId = prod['id'] is int ? prod['id'] as int : null;

    String? imageUrl;
    try {
      if (prod['image_path'] != null && prod['image_path'].toString().isNotEmpty) {
        imageUrl = ApiConfig.getUploadUrl(prod['image_path']);
      }
    } catch (e) {
      print('Error parsing image_path: $e');
    }

    final card = Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, size: 80),
                  )
                : const Icon(Icons.fitness_center, size: 80),
            const SizedBox(height: 8),
            Text(prod['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${AppLocalizations.of(context)!.productsStock}: ${prod['stock'] ?? 0}'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => openProductDetails(prodId),
              child: Text(AppLocalizations.of(context)!.details),
            ),
            if (widget.user['type_account'] == 'admin')
              TextButton(
                onPressed: () => deleteProduct(prodId),
                child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );

    return HoverCard(child: card);
  }

  BoxDecoration? _getBackgroundDecoration(BuildContext context) {
    final ext = Theme.of(context).extension<CustomThemeExtension>();
    if (ext?.backgroundGradient != null) {
      return BoxDecoration(gradient: ext!.backgroundGradient);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: DashboardBackButton(user: widget.user),
        title: Row(
          children: [
            AppLogo(),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.products),
          ],
        ),
        actions: [
          IconButton(
            onPressed: fetchProducts,
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.productsRefresh,
          ),
          if (widget.user['type_account'] == 'admin')
            IconButton(
              onPressed: () => openProductDetails(null),
              icon: const Icon(Icons.add),
              tooltip: AppLocalizations.of(context)!.productsAddNew,
            ),
        ],
      ),
      body: Container(
        decoration: _getBackgroundDecoration(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.productsSearchByName,
                  hintText: AppLocalizations.of(context)!.productsEnterName,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                ),
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedOpacity(
                      opacity: _dataLoaded ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: _filteredProducts.isEmpty
                          ? Center(child: Text(AppLocalizations.of(context)!.productsNoProductsFound))
                          : GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                                childAspectRatio: 3 / 4,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: _filteredProducts.length,
                              itemBuilder: (context, index) {
                                return buildProductCard(_filteredProducts[index]);
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}