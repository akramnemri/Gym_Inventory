import 'package:flutter/material.dart';
import 'dart:convert';
import 'dashboard_back_button.dart';
import 'component_details_screen.dart';
import 'widgets/hover_card.dart';
import 'theme.dart';
import 'l10n/app_localizations.dart';
import 'config/api_config.dart';
import 'config/api_client.dart';

class ComponentFilter {
  String searchText = '';
  String selectedType = 'All';
  double? minLength;
  double? maxLength;
  double? minWeight;
  double? maxWeight;
  double? minHeight;
  double? maxHeight;
  int? minStock;
  int? maxStock;
  String dimensionsText = '';
  String referenceText = '';

  bool get hasActiveFilters =>
      searchText.isNotEmpty ||
      selectedType != 'All' ||
      minLength != null ||
      maxLength != null ||
      minWeight != null ||
      maxWeight != null ||
      minHeight != null ||
      maxHeight != null ||
      minStock != null ||
      maxStock != null ||
      dimensionsText.isNotEmpty ||
      referenceText.isNotEmpty;

  void clear() {
    searchText = '';
    selectedType = 'All';
    minLength = null;
    maxLength = null;
    minWeight = null;
    maxWeight = null;
    minHeight = null;
    maxHeight = null;
    minStock = null;
    maxStock = null;
    dimensionsText = '';
    referenceText = '';
  }

  bool matchesComponent(Map<String, dynamic> component) {
    // Text search (name and reference)
    if (searchText.isNotEmpty) {
      final name = component['name']?.toString().toLowerCase() ?? '';
      final reference = component['reference']?.toString().toLowerCase() ?? '';
      final searchLower = searchText.toLowerCase();
      if (!name.contains(searchLower) && !reference.contains(searchLower)) {
        return false;
      }
    }

    // Type filter
    if (selectedType != 'All' && component['type_name'] != selectedType) {
      return false;
    }

    // Reference text filter
    if (referenceText.isNotEmpty) {
      final reference = component['reference']?.toString().toLowerCase() ?? '';
      if (!reference.contains(referenceText.toLowerCase())) {
        return false;
      }
    }

    // Dimensions text filter
    if (dimensionsText.isNotEmpty) {
      final dimensions = component['dimensions']?.toString().toLowerCase() ?? '';
      if (!dimensions.contains(dimensionsText.toLowerCase())) {
        return false;
      }
    }

    // Numeric range filters
    if (!_isInRange(component['length'], minLength, maxLength)) return false;
    if (!_isInRange(component['weight'], minWeight, maxWeight)) return false;
    if (!_isInRange(component['height'], minHeight, maxHeight)) return false;
    if (!_isInRange(component['stock'], minStock?.toDouble(), maxStock?.toDouble())) return false;

    return true;
  }

  bool _isInRange(dynamic value, double? min, double? max) {
    if (min == null && max == null) return true;
    
    final numValue = double.tryParse(value?.toString() ?? '0') ?? 0;
    if (min != null && numValue < min) return false;
    if (max != null && numValue > max) return false;
    
    return true;
  }
}

class ComponentSearchBar extends StatefulWidget {
  final ComponentFilter filter;
  final VoidCallback onFilterChanged;
  final List<String> componentTypes;
  final Map<String, String> localizedComponentTypes;

  const ComponentSearchBar({
    Key? key,
    required this.filter,
    required this.onFilterChanged,
    required this.componentTypes,
    required this.localizedComponentTypes,
  }) : super(key: key);

  @override
  _ComponentSearchBarState createState() => _ComponentSearchBarState();
}

class _ComponentSearchBarState extends State<ComponentSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();
  final TextEditingController _minLengthController = TextEditingController();
  final TextEditingController _maxLengthController = TextEditingController();
  final TextEditingController _minWeightController = TextEditingController();
  final TextEditingController _maxWeightController = TextEditingController();
  final TextEditingController _minHeightController = TextEditingController();
  final TextEditingController _maxHeightController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _maxStockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _loadFilterValues();
  }

  void _loadFilterValues() {
    _searchController.text = widget.filter.searchText;
    _referenceController.text = widget.filter.referenceText;
    _dimensionsController.text = widget.filter.dimensionsText;
    _minLengthController.text = widget.filter.minLength?.toString() ?? '';
    _maxLengthController.text = widget.filter.maxLength?.toString() ?? '';
    _minWeightController.text = widget.filter.minWeight?.toString() ?? '';
    _maxWeightController.text = widget.filter.maxWeight?.toString() ?? '';
    _minHeightController.text = widget.filter.minHeight?.toString() ?? '';
    _maxHeightController.text = widget.filter.maxHeight?.toString() ?? '';
    _minStockController.text = widget.filter.minStock?.toString() ?? '';
    _maxStockController.text = widget.filter.maxStock?.toString() ?? '';
  }

  void _updateFilter() {
    widget.filter.searchText = _searchController.text;
    widget.filter.referenceText = _referenceController.text;
    widget.filter.dimensionsText = _dimensionsController.text;
    widget.filter.minLength = double.tryParse(_minLengthController.text);
    widget.filter.maxLength = double.tryParse(_maxLengthController.text);
    widget.filter.minWeight = double.tryParse(_minWeightController.text);
    widget.filter.maxWeight = double.tryParse(_maxWeightController.text);
    widget.filter.minHeight = double.tryParse(_minHeightController.text);
    widget.filter.maxHeight = double.tryParse(_maxHeightController.text);
    widget.filter.minStock = int.tryParse(_minStockController.text);
    widget.filter.maxStock = int.tryParse(_maxStockController.text);
    
    widget.onFilterChanged();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _clearFilters() {
    widget.filter.clear();
    _loadFilterValues();
    setState(() {});
    widget.onFilterChanged();
  }

  Widget _buildRangeFilter({
    required String label,
    required TextEditingController minController,
    required TextEditingController maxController,
    bool isInteger = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minController,
                keyboardType: isInteger ? TextInputType.number : const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.filterMin,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (_) => _updateFilter(),
              ),
            ),
            const SizedBox(width: 8),
            const Text('—', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: maxController,
                keyboardType: isInteger ? TextInputType.number : const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.filterMax,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (_) => _updateFilter(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: isDark ? 8 : 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Main search bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.filterSearchHint,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (_) => _updateFilter(),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    onPressed: _toggleExpanded,
                    icon: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.tune),
                    ),
                    tooltip: AppLocalizations.of(context)!.filterAdvanced,
                  ),
                ),
                if (widget.filter.hasActiveFilters)
                  IconButton(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.clear_all),
                    tooltip: AppLocalizations.of(context)!.filterClear,
                  ),
              ],
            ),

            // Advanced filters
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    
                    // Type and text filters
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.filterType, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: widget.filter.selectedType,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'All',
                                    child: Text(AppLocalizations.of(context)!.filterAll)
                                  ),
                                  ...widget.componentTypes.map((type) => 
                                    DropdownMenuItem(
                                      value: type, 
                                      child: Text(widget.localizedComponentTypes[type] ?? type)
                                    )
                                  )
                                ],
                                onChanged: (value) {
                                  widget.filter.selectedType = value ?? 'All';
                                  _updateFilter();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.filterReference, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _referenceController,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.filterReferenceHint,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                onChanged: (_) => _updateFilter(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Dimensions text filter
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.filterDimensions, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _dimensionsController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.filterDimensionsHint,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onChanged: (_) => _updateFilter(),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Numeric range filters
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 3,
                      children: [
                        _buildRangeFilter(
                          label: AppLocalizations.of(context)!.filterLength,
                          minController: _minLengthController,
                          maxController: _maxLengthController,
                        ),
                        _buildRangeFilter(
                          label: AppLocalizations.of(context)!.filterWeight,
                          minController: _minWeightController,
                          maxController: _maxWeightController,
                        ),
                        _buildRangeFilter(
                          label: AppLocalizations.of(context)!.filterHeight,
                          minController: _minHeightController,
                          maxController: _maxHeightController,
                        ),
                        _buildRangeFilter(
                          label: AppLocalizations.of(context)!.filterStock,
                          minController: _minStockController,
                          maxController: _maxStockController,
                          isInteger: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _referenceController.dispose();
    _dimensionsController.dispose();
    _minLengthController.dispose();
    _maxLengthController.dispose();
    _minWeightController.dispose();
    _maxWeightController.dispose();
    _minHeightController.dispose();
    _maxHeightController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    super.dispose();
  }
}


class ComponentsScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const ComponentsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ComponentsScreenState createState() => _ComponentsScreenState();
  
}

class _ComponentsScreenState extends State<ComponentsScreen> {
  List<Map<String, dynamic>> components = [];
  bool _loading = true;
  bool _dataLoaded = false;
  // Filter and search functionality
  final ComponentFilter _filter = ComponentFilter();
  List<Map<String, dynamic>> _filteredComponents = [];
  List<String> _componentTypes = ['Prime Material', 'Consumable Pieces', 'Standard Pieces', 'Furniture'];

  Map<String, String> getLocalizedComponentTypes(BuildContext context) {
  return {
    'Prime Material': AppLocalizations.of(context)!.componentTypePrimeMaterial,
    'Consumable Pieces': AppLocalizations.of(context)!.componentTypeConsumablePieces,
    'Standard Pieces': AppLocalizations.of(context)!.componentTypeStandardPieces,
    'Furniture': AppLocalizations.of(context)!.componentTypeFurniture,
  };
}

  @override
  void initState() {
    super.initState();
    fetchComponents();
  }

  Future<void> fetchComponents() async {
    setState(() {
      _loading = true;
      _dataLoaded = false;
    });
    try {
      final res = await ApiClient.get('/api/components');
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) {
        setState(() {
          components = decoded.map<Map<String, dynamic>>((e) {
            if (e is Map<String, dynamic>) return e;
            print('Unexpected element type: ${e.runtimeType}');
            return {};
          }).toList();
          _applyFilters(); // Apply filters after loading
          _dataLoaded = true;
        });
      } else {
        print('Unexpected response type: ${decoded.runtimeType}');
        showError(AppLocalizations.of(context)!.componentsUnexpectedDataFormat);
      }
    } else {
      showError('${AppLocalizations.of(context)!.componentsErrorFetching}: ${res.statusCode}');
      print('fetchComponents statusCode=${res.statusCode} body=${res.body}');
    }
  } catch (e, st) {
    print('Error in fetchComponents: $e\n$st');
    showError(AppLocalizations.of(context)!.componentsErrorFetching);
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}

void _applyFilters() {
  _filteredComponents = components.where((component) => _filter.matchesComponent(component)).toList();
}

void _onFilterChanged() {
  setState(() {
    _applyFilters();
  });
}

  void showError(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void openComponentDetails(int? compId) async {
  if (compId == null && widget.user['type_account'] != 'admin') return;

  try {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ComponentDetailsScreen(compId: compId, user: widget.user),
      ),
    );

    // Always refresh when returning from details screen
    if (mounted) {
      await fetchComponents();
      
      // Show success message based on the result
      if (result != null && result is Map<String, dynamic>) {
        if (result.containsKey('deletedId')) {
          showError(AppLocalizations.of(context)!.componentsDeleteSuccess);
        } else if (compId == null) {
          showError(AppLocalizations.of(context)!.componentsCreateSuccess);
        } else {
          showError(AppLocalizations.of(context)!.componentsUpdateSuccess);
        }
      }
    }
  } catch (e, st) {
    print('Error in openComponentDetails: $e\n$st');
    showError(AppLocalizations.of(context)!.componentsErrorOpeningDetails);
  }
}

 Future<void> deleteComponent(int? compId) async {
  if (compId == null) return;
  
  // Show confirmation dialog
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.componentsConfirmDeleteTitle),
      content: Text(AppLocalizations.of(context)!.componentsConfirmDeleteMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  setState(() => _loading = true);
  try {
    final res = await ApiClient.delete('/api/components/$compId');
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final msg = decoded['message'] ?? AppLocalizations.of(context)!.componentsDeleteSuccess;
      showError(msg);
      
      // Refresh the components list after deletion
      await fetchComponents();
    } else {
      showError('${AppLocalizations.of(context)!.componentsDeleteFailed}: ${res.statusCode}');
    }
  } catch (e, st) {
    print('Error in deleteComponent: $e\n$st');
    showError(AppLocalizations.of(context)!.componentsErrorDeleting);
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}

  Widget buildComponentCard(Map<String, dynamic> comp) {
    final int? compId = comp['id'] is int ? comp['id'] as int : null;

    String? imageUrl;
    try {
      if (comp['image_path'] != null && comp['image_path'].toString().isNotEmpty) {
        imageUrl = ApiConfig.getUploadUrl(comp['image_path']);
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
                    errorBuilder: (_, __, ___) => const Icon(Icons.extension, size: 80),
                  )
                : const Icon(Icons.extension, size: 80),
            const SizedBox(height: 8),
            Text(comp['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${AppLocalizations.of(context)!.filterStock}: ${comp['stock'] ?? 0}'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => openComponentDetails(compId),
              child: Text(AppLocalizations.of(context)!.details),
            ),
            if (widget.user['type_account'] == 'admin')
              TextButton(
                onPressed: () => deleteComponent(compId),
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
      Text(AppLocalizations.of(context)!.componentsTitle),
    ],
  ),
  actions: [
    IconButton(
      onPressed: fetchComponents,
      icon: const Icon(Icons.refresh),
      tooltip: AppLocalizations.of(context)!.componentsRefresh,
    ),
    if (widget.user['type_account'] == 'admin')
      IconButton(
        onPressed: () => openComponentDetails(null),
        icon: const Icon(Icons.add),
        tooltip: AppLocalizations.of(context)!.componentsAddComponent,
      ),
  ],
),
     body: Container(
  decoration: _getBackgroundDecoration(context),
  child: _loading
      ? const Center(child: CircularProgressIndicator())
      : AnimatedOpacity(
          opacity: _dataLoaded ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: RefreshIndicator(
            onRefresh: fetchComponents,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works even with little content
              child: Column(
                children: [
                  // Search bar
                  ComponentSearchBar(
                    filter: _filter,
                    onFilterChanged: _onFilterChanged,
                    componentTypes: _componentTypes,
                    localizedComponentTypes: getLocalizedComponentTypes(context),
                  ),
                  // Components grid
                  _filteredComponents.isEmpty
                      ? Container(
                          height: 300,
                          child: Center(
                            child: Text(
                              _filter.hasActiveFilters 
                                  ? AppLocalizations.of(context)!.componentsNoMatchingFilters
                                  : AppLocalizations.of(context)!.componentsNoComponentsFound
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _filteredComponents.length,
                          itemBuilder: (context, index) {
                            return buildComponentCard(_filteredComponents[index]);
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
),
    );
  }
}