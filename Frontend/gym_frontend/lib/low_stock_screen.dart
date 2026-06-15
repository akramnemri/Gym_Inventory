import 'package:flutter/material.dart';
import 'dart:convert';
import 'dashboard_back_button.dart';
import 'theme.dart';
import 'l10n/app_localizations.dart';
import 'config/api_client.dart';

class LowStockScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const LowStockScreen({Key? key, required this.user}) : super(key: key);

  @override
  _LowStockScreenState createState() => _LowStockScreenState();
}

class _LowStockScreenState extends State<LowStockScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> lowStockComponents = [];
  bool _loading = false;
  bool _dataLoaded = false;
  String? lowStockError;
  int lowStockThreshold = 5;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 1)
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)
    );
    
    fetchLowStock();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> fetchLowStock() async {
    setState(() {
      _loading = true;
      _dataLoaded = false;
    });
    
    try {
      final res = await ApiClient.get('/api/low-stock?threshold=$lowStockThreshold');

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is List) {
          setState(() {
            lowStockComponents = List<Map<String, dynamic>>.from(decoded);
            lowStockError = null;
            _dataLoaded = true;
          });
        } else {
          setState(() => lowStockError = AppLocalizations.of(context)!.lowStockErrorLoading);
        }
      } else {
        setState(() => lowStockError = 'LowStock fetch failed: ${res.statusCode}');
      }
    } catch (e, st) {
      print('Error in fetchLowStock: $e\n$st');
      setState(() => lowStockError = AppLocalizations.of(context)!.lowStockErrorLoading);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildLowStockCard(Map<String, dynamic> comp) {
    final stock = comp['stock'] ?? 0;
    final isCritical = stock <= (lowStockThreshold * 0.5); // Critical when stock is half of threshold or less
    final isLow = stock <= lowStockThreshold;

    Color cardColor;
    Color borderColor;
    if (isCritical) {
      cardColor = Colors.red[300]!;
      borderColor = Colors.red[700]!;
    } else if (isLow) {
      cardColor = Colors.orange[200]!;
      borderColor = Colors.orange[600]!;
    } else {
      cardColor = Colors.yellow[100]!;
      borderColor = Colors.yellow[600]!;
    }

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: borderColor,
            width: isCritical ? _pulseAnimation.value * 3 : 2,
          ),
        ),
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      comp['name'] ?? AppLocalizations.of(context)!.dashboardUnknown,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCritical ? Colors.red : (isLow ? Colors.orange : Colors.yellow[700]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isCritical 
                        ? AppLocalizations.of(context)!.lowStockCritical
                        : AppLocalizations.of(context)!.lowStockThreshold,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.inventory_2,
                    color: Colors.black54,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${AppLocalizations.of(context)!.dashboardStock}: $stock',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (comp['type_name'] != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      color: Colors.black54,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${AppLocalizations.of(context)!.componentDetailsType}: ${comp['type_name']}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
              if (comp['reference'] != null && comp['reference'].toString().isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.tag,
                      color: Colors.black54,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${AppLocalizations.of(context)!.componentDetailsReference}: ${comp['reference']}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThresholdSelector() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.lowStockThreshold,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: lowStockThreshold.toDouble(),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: lowStockThreshold.toString(),
                    onChanged: (value) {
                      setState(() {
                        lowStockThreshold = value.round();
                      });
                    },
                    onChangeEnd: (value) {
                      fetchLowStock(); // Refresh data when threshold changes
                    },
                  ),
                ),
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lowStockThreshold.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
            Text(AppLocalizations.of(context)!.lowStockTitle),
          ],
        ),
        actions: [
          IconButton(
            onPressed: fetchLowStock,
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.lowStockRefresh,
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
                  onRefresh: fetchLowStock,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildThresholdSelector(),
                        if (lowStockError != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              color: Theme.of(context).colorScheme.errorContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  lowStockError!,
                                  style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                                ),
                              ),
                            ),
                          ),
                        if (lowStockComponents.isEmpty && lowStockError == null)
                          Container(
                            height: 300,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 64,
                                    color: Colors.greenAccent,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppLocalizations.of(context)!.lowStockNoAlerts,
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ...lowStockComponents.map((comp) => _buildLowStockCard(comp)).toList(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}