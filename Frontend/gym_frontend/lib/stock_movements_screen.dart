import 'package:flutter/material.dart';
import 'dart:convert';
import 'dashboard_back_button.dart';
import 'theme.dart';
import 'l10n/app_localizations.dart';
import 'config/api_client.dart';

class StockMovementsScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const StockMovementsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _StockMovementsScreenState createState() => _StockMovementsScreenState();
}

class _StockMovementsScreenState extends State<StockMovementsScreen> {
  List<Map<String, dynamic>> stockMovements = [];
  List<Map<String, dynamic>> filteredMovements = [];
  bool _loading = true; // Start in loading state
  bool _dataLoaded = false;
  String? stockMovementsError;

  // Use keys for logic, not displayed strings
  String _selectedFilterKey = 'all';
  final List<String> _filterKeys = ['all', 'components', 'products', 'increases', 'decreases'];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStockMovements();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchStockMovements() async {
    // Check if mounted before calling setState after an async gap
    if (!mounted) return;
    setState(() {
      _loading = true;
      _dataLoaded = false;
    });

    try {
      final res = await ApiClient.get('/api/stock-movements');

      // Ensure we have access to context for translations
      final l10n = AppLocalizations.of(context)!;
      
      if (!mounted) return;

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is List) {
          setState(() {
            stockMovements = List<Map<String, dynamic>>.from(decoded);
            stockMovementsError = null;
            _dataLoaded = true;
            _applyFilters();
          });
        } else {
          setState(() => stockMovementsError = l10n.stockMovementsErrorUnexpectedFormat);
        }
      } else {
        setState(() => stockMovementsError = l10n.stockMovementsErrorFetchFailed(res.statusCode));
      }
    } catch (e, st) {
      final l10n = AppLocalizations.of(context)!;
      print('Error in fetchStockMovements: $e\n$st');
      if (mounted) setState(() => stockMovementsError = l10n.stockMovementsErrorLoading);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(stockMovements);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchLower = _searchController.text.toLowerCase();
      filtered = filtered.where((movement) {
        final name = (movement['component_name'] ?? movement['product_name'] ?? '').toString().toLowerCase();
        final id = (movement['component_id']?.toString() ?? movement['product_id']?.toString() ?? '').toLowerCase();
        return name.contains(searchLower) || id.contains(searchLower);
      }).toList();
    }

    // Apply type filter using the key
    if (_selectedFilterKey != 'all') {
      filtered = filtered.where((movement) {
        switch (_selectedFilterKey) {
          case 'components':
            return movement['component_id'] != null;
          case 'products':
            return movement['product_id'] != null;
          case 'increases':
            return (movement['quantity_change'] ?? 0) > 0;
          case 'decreases':
            return (movement['quantity_change'] ?? 0) < 0;
          default:
            return true;
        }
      }).toList();
    }

    setState(() {
      filteredMovements = filtered;
    });
  }

  String formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr.replaceAll(' ', 'T'));
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeStr;
    }
  }

 Widget _buildStockMovementCard(Map<String, dynamic> movement) {
  final l10n = AppLocalizations.of(context)!;
  final name = movement['component_name'] ?? movement['product_name'] ?? '';
  final isComponent = movement['component_id'] != null;
  final quantityChange = movement['quantity_change'] ?? 0;
  final isIncrease = quantityChange > 0;
  final userName = movement['user_name'] ?? 'Unknown';

  return Card(
    color: Theme.of(context).cardColor,
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isComponent ? Colors.blue.withOpacity(0.1) : Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isComponent ? Icons.extension : Icons.inventory,
                  color: isComponent ? Colors.blue : Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isComponent
                          ? l10n.stockMovementsCardComponentLabel(movement['component_id']?.toString() ?? 'N/A')
                          : l10n.stockMovementsCardProductLabel(movement['product_id']?.toString() ?? 'N/A'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (name.isNotEmpty)
                      Text(
                        name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isIncrease ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${isIncrease ? '+' : ''}$quantityChange',
                  style: TextStyle(
                    color: isIncrease ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(width: 4),
              Text(
                formatDateTime(movement['change_time'] ?? ''),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.person,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _buildFilterChips(AppLocalizations l10n) {
    // Map keys to their translated display labels
    final filterLabels = {
      'all': l10n.stockMovementsFilterAll,
      'components': l10n.stockMovementsFilterComponents,
      'products': l10n.stockMovementsFilterProducts,
      'increases': l10n.stockMovementsFilterIncreases,
      'decreases': l10n.stockMovementsFilterDecreases,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _filterKeys.map((key) {
          final isSelected = _selectedFilterKey == key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filterLabels[key]!), // Use the translated label
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilterKey = key; // Set the key in state
                  _applyFilters();
                });
              },
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              checkmarkColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }).toList(),
      ),
    );
  }

BoxDecoration? _getBackgroundDecoration(BuildContext context) {
    final ext = Theme.of(context).extension<CustomThemeExtension>();
    // First, check if the extension itself exists.
    if (ext != null && ext.backgroundGradient != null) {
      // Inside this block, Dart knows `ext` is not null.
      return BoxDecoration(gradient: ext.backgroundGradient); // No "!" needed.
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: DashboardBackButton(user: widget.user),
        title: Row(
          children: [
            AppLogo(),
            const SizedBox(width: 8),
            Text(l10n.stockMovementsTitle),
          ],
        ),
        actions: [
          IconButton(
            onPressed: fetchStockMovements,
            icon: const Icon(Icons.refresh),
            tooltip: l10n.stockMovementsRefreshTooltip,
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
                  hintText: l10n.stockMovementsSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                onChanged: (_) => _applyFilters(),
              ),
            ),
            _buildFilterChips(l10n),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedOpacity(
                      opacity: _dataLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: RefreshIndicator(
                        onRefresh: fetchStockMovements,
                        child: filteredMovements.isEmpty && stockMovementsError == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 64,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.stockMovementsNoResults,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : stockMovementsError != null
                                ? Center(
                                    child: Card(
                                      color: Theme.of(context).colorScheme.errorContainer,
                                      margin: const EdgeInsets.all(20),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          stockMovementsError!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    itemCount: filteredMovements.length,
                                    itemBuilder: (context, index) {
                                      return _buildStockMovementCard(filteredMovements[index]);
                                    },
                                  ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}