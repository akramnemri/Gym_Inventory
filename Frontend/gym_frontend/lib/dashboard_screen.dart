import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart' as theme;
import 'l10n/app_localizations.dart';
import 'side_menu.dart'; 
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'config/api_config.dart';
import 'config/api_client.dart';

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const DashboardScreen({super.key, required this.user});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  bool _loading = false;
  bool _statisticsLoading = true;
  late Timer _clockTimer;
  String _currentTime = '';
  bool _isMenuOpen = false;
  late Map<String, dynamic> currentUser;

  // Statistics data
  Map<String, dynamic> _dashboardStats = {};
  Map<String, dynamic> _productionStats = {};
  Map<String, dynamic> _userActivityStats = {};

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _updateClock();
    _clockTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateClock());

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final showWelcome = prefs.getBool('showWelcome') ?? false;
    if (showWelcome && mounted) {
      _showWelcomePopup();
      await prefs.setBool('showWelcome', false);
    }
    _fetchUserDetails();
    _loadAllStatistics();
    if (mounted) {
      _updateSideMenuAnimation();
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      final res = await ApiClient.get(
        '/api/users/${widget.user['id']}',
      );

      if (res.statusCode == 200) {
        final userData = jsonDecode(res.body);
        if (userData is Map<String, dynamic>) {
          setState(() {
            currentUser = {...currentUser, ...userData};
          });
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  void _updateSideMenuAnimation() {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    _slideAnimation = Tween<Offset>(
            begin: isRTL ? const Offset(1, 0) : const Offset(-1, 0),
            end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _updateClock() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _loadAllStatistics() async {
    setState(() => _statisticsLoading = true);
    
    try {
      await Future.wait([
        _loadDashboardStatistics(),
        _loadProductionStatistics(),
        _loadUserActivityStatistics(),
      ]);
    } catch (e) {
      print('Error loading statistics: $e');
    } finally {
      if (mounted) setState(() => _statisticsLoading = false);
    }
  }

  Future<void> _loadDashboardStatistics() async {
    try {
      final response = await ApiClient.get('/api/dashboard/statistics');
      if (response.statusCode == 200) {
        setState(() {
          _dashboardStats = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print('Error loading dashboard statistics: $e');
    }
  }

  Future<void> _loadProductionStatistics() async {
    try {
      final response = await ApiClient.get('/api/dashboard/production-stats?period=month');
      if (response.statusCode == 200) {
        setState(() {
          _productionStats = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print('Error loading production statistics: $e');
    }
  }

  Future<void> _loadUserActivityStatistics() async {
    try {
      final response = await ApiClient.get('/api/dashboard/user-activity');
      if (response.statusCode == 200) {
        setState(() {
          _userActivityStats = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print('Error loading user activity statistics: $e');
    }
  }

  Future<void> _refreshAllData() async {
    if (_loading) return;
    setState(() {
      _loading = true;
    });
    try {
      await _loadAllStatistics();
    } catch (e, st) {
      print('Error in _refreshAllData: $e\n$st');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _clockTimer.cancel();
    super.dispose();
  }

  void _showWelcomePopup() {
    final isAdmin = widget.user['type_account'] == 'admin';
    final username = widget.user['username'] ??
        widget.user['name'] ??
        AppLocalizations.of(context)!.dashboardUser;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '${isAdmin ? AppLocalizations.of(context)!.dashboardWelcomeAdmin : AppLocalizations.of(context)!.dashboardWelcomeUser} $username!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.dashboardWelcomeMessage,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(AppLocalizations.of(context)!.dashboardGotIt),
          ),
        ],
      ),
    );
  }

  // Compact stat card design with improved readability
  Widget _buildCompactStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Welcome card at the top with complete content
  Widget _buildWelcomeCard() {
    final isAdmin = widget.user['type_account'] == 'admin';
    final username = widget.user['username'] ?? widget.user['name'] ?? AppLocalizations.of(context)!.dashboardUser;
    
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isAdmin ? Icons.admin_panel_settings : Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${isAdmin ? AppLocalizations.of(context)!.dashboardWelcomeAdmin : AppLocalizations.of(context)!.dashboardWelcomeUser} $username!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.dashboardWelcomeToDashboard,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _currentTime,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.dashboardNavigationHelp,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickActionChip(AppLocalizations.of(context)!.dashboardComponents, Icons.extension, '/components'),
                _buildQuickActionChip(AppLocalizations.of(context)!.dashboardProducts, Icons.inventory, '/products'),
                _buildQuickActionChip(AppLocalizations.of(context)!.dashboardSessionLogs, Icons.history, '/session-logs'),
                _buildQuickActionChip(AppLocalizations.of(context)!.dashboardLowStockAlerts, Icons.warning, '/low-stock'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentsPieChart() {
    if (_dashboardStats['componentsByType'] == null || _statisticsLoading) {
      return _buildLoadingCard(AppLocalizations.of(context)!.dashboardComponentsByType);
    }

    List<Map<String, dynamic>> componentsByType = 
        List<Map<String, dynamic>>.from(_dashboardStats['componentsByType']);

    if (componentsByType.isEmpty) {
      return _buildEmptyCard(AppLocalizations.of(context)!.dashboardComponentsByType, 
        AppLocalizations.of(context)!.dashboardNoComponentData);
    }

    const othersThreshold = 3;
    List<Map<String, dynamic>> chartData = componentsByType.where((e) {
      final count = e['count'] is num ? (e['count'] as num).toDouble() : double.tryParse(e['count'].toString()) ?? 0.0;
      return count >= othersThreshold;
    }).toList();

    final othersCount = componentsByType.where((e) {
      final count = e['count'] is num ? (e['count'] as num).toDouble() : double.tryParse(e['count'].toString()) ?? 0.0;
      return count < othersThreshold;
    }).fold<double>(0.0, (sum, e) => sum + (e['count'] is num ? (e['count'] as num).toDouble() : double.tryParse(e['count'].toString()) ?? 0.0));

    if (othersCount > 0) {
      chartData.add({'name': 'Others', 'count': othersCount});
    }

    Color generateColor(int index) {
      final hue = (index * 137.508) % 360;
      return HSLColor.fromAHSL(1.0, hue, 0.6, 0.5).toColor();
    }

    return Container(
      height: 320,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bar_chart, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.dashboardComponentsByType,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: (chartData.map((e) => e['count'] is num ? (e['count'] as num).toDouble() : double.tryParse(e['count'].toString()) ?? 0.0).reduce((a, b) => a > b ? a : b) * 1.2).clamp(1.0, double.infinity),
                    barGroups: chartData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final value = data['count'] is num ? (data['count'] as num).toDouble() : double.tryParse(data['count'].toString()) ?? 0.0;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: value,
                            color: generateColor(index),
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= chartData.length) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                chartData[index]['name'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                          reservedSize: 36,
                          interval: 1,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: chartData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: generateColor(index),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${data['name']} (${data['count']})',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated with profile pictures support
  Widget _buildTopUsersCard() {
    if (_userActivityStats['activeUsers'] == null || _statisticsLoading) {
      return _buildLoadingCard(AppLocalizations.of(context)!.dashboardTopActiveUsers);
    }

    List<Map<String, dynamic>> activeUsers = 
        List<Map<String, dynamic>>.from(_userActivityStats['activeUsers']);

    if (activeUsers.isEmpty) {
      return _buildEmptyCard(AppLocalizations.of(context)!.dashboardTopActiveUsers, 
        AppLocalizations.of(context)!.dashboardNoUserActivityData);
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${AppLocalizations.of(context)!.dashboardTopActiveUsers} (${AppLocalizations.of(context)!.dashboardLast30Days})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...activeUsers.take(3).map((user) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  // Profile picture or initials
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: user['profile_picture'] != null && user['profile_picture'].toString().isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              ApiConfig.getUploadUrl(user['profile_picture']),
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    '${user['first_name']?[0] ?? ''}${user['last_name']?[0] ?? ''}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              '${user['first_name']?[0] ?? ''}${user['last_name']?[0] ?? ''}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${user['username'] ?? 'unknown'}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${user['session_count'] ?? 0} ${AppLocalizations.of(context)!.dashboardSessions}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (user['avg_session_minutes'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '~${(user['avg_session_minutes'] is num ? user['avg_session_minutes'] : double.tryParse(user['avg_session_minutes'].toString()) ?? 0.0).round()}${AppLocalizations.of(context)!.dashboardMinAvg}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductionInsights() {
    if (_productionStats.isEmpty || _statisticsLoading) {
      return _buildLoadingCard(AppLocalizations.of(context)!.dashboardProductionInsights);
    }

    final allTimeMost = _productionStats['allTimeMost'];
    final recentProduced = _productionStats['productsProduced'] as List? ?? [];

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.dashboardProductionInsights,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (allTimeMost != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.withOpacity(0.1),
                      Colors.orange.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.emoji_events, color: Colors.amber[700], size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.dashboardAllTimeChampion,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            allTimeMost['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${allTimeMost['total_produced']}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.dashboardUnitsProduced,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (recentProduced.isNotEmpty) ...[
              Text(
                AppLocalizations.of(context)!.dashboardRecentProductionMonth,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              ...recentProduced.take(3).map((product) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${product['total_produced']}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard(String title) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String title, String message) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  BoxDecoration? _getBackgroundDecoration(BuildContext context) {
    final ext = Theme.of(context).extension<theme.CustomThemeExtension>();
    if (ext?.backgroundGradient != null) {
      return BoxDecoration(gradient: ext!.backgroundGradient);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = 280.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.primary),
          onPressed: toggleMenu,
        ),
        title: Row(
          children: [
            // Use theme-integrated logo instead of hardcoded icon
            const theme.AppLogo(height: 32),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.dashboardTitle,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
            tooltip: AppLocalizations.of(context)!.dashboardRefresh,
            onPressed: _refreshAllData,
          ),
        ],
      ),
      body: Container(
        decoration: _getBackgroundDecoration(context),
        child: Stack(
          children: [
            // Main content with proper scaling when menu is open
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()
                ..scale(_isMenuOpen ? (screenWidth - menuWidth) / screenWidth : 1.0)
                ..translate(_isMenuOpen ? (isRTL ? -menuWidth : menuWidth) : 0.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16), // Reduced padding for more compact layout
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: _refreshAllData,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Welcome card moved to top
                                _buildWelcomeCard(),
                                const SizedBox(height: 20),
                                
                                // System Overview title
                                Text(
                                  AppLocalizations.of(context)!.dashboardSystemOverview,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Compact stat cards grid - let cards size to content
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 2.2, // Slightly more compact but readable
                                  children: [
                                    _buildCompactStatCard(
                                      icon: Icons.warning,
                                      title: AppLocalizations.of(context)!.dashboardLowStockAlertsTitle,
                                      value: _statisticsLoading ? '...' : '${_dashboardStats['lowStockCount'] ?? 0}',
                                      color: Colors.orange,
                                      subtitle: AppLocalizations.of(context)!.dashboardItemsNeedAttention,
                                      onTap: () => Navigator.pushReplacementNamed(
                                          context, '/low-stock', arguments: widget.user),
                                    ),
                                    _buildCompactStatCard(
                                      icon: Icons.people,
                                      title: AppLocalizations.of(context)!.dashboardActiveSessionsTitle,
                                      value: _statisticsLoading ? '...' : '${_dashboardStats['activeSessions'] ?? 0}',
                                      color: Colors.green,
                                      subtitle: AppLocalizations.of(context)!.dashboardUsersOnlineNow,
                                      onTap: () => Navigator.pushReplacementNamed(
                                          context, '/session-logs', arguments: widget.user),
                                    ),
                                    _buildCompactStatCard(
                                      icon: Icons.extension,
                                      title: AppLocalizations.of(context)!.dashboardTotalComponentsTitle,
                                      value: _statisticsLoading ? '...' : '${_dashboardStats['totalComponents'] ?? 0}',
                                      color: Colors.blue,
                                      subtitle: AppLocalizations.of(context)!.dashboardInInventory,
                                      onTap: () => Navigator.pushReplacementNamed(
                                          context, '/components', arguments: widget.user),
                                    ),
                                    _buildCompactStatCard(
                                      icon: Icons.inventory,
                                      title: AppLocalizations.of(context)!.dashboardTotalProductsTitle,
                                      value: _statisticsLoading ? '...' : '${_dashboardStats['totalProducts'] ?? 0}',
                                      color: Colors.purple,
                                      subtitle: AppLocalizations.of(context)!.dashboardAvailableProducts,
                                      onTap: () => Navigator.pushReplacementNamed(
                                          context, '/products', arguments: widget.user),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Secondary stats in a row
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildCompactStatCard(
                                        icon: Icons.trending_up,
                                        title: AppLocalizations.of(context)!.dashboardStockMovementsTitle,
                                        value: _statisticsLoading ? '...' : '${_dashboardStats['recentMovements'] ?? 0}',
                                        color: Colors.cyan,
                                        subtitle: AppLocalizations.of(context)!.dashboardToday,
                                        onTap: () => Navigator.pushReplacementNamed(
                                            context, '/stock-movements', arguments: widget.user),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildCompactStatCard(
                                        icon: Icons.schedule,
                                        title: AppLocalizations.of(context)!.dashboardSystemStatusTitle,
                                        value: AppLocalizations.of(context)!.dashboardOnline,
                                        color: Colors.green,
                                        subtitle: AppLocalizations.of(context)!.dashboardAllServicesRunning,
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Analytics section
                                Text(
                                  AppLocalizations.of(context)!.dashboardAnalyticsInsights,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Charts section with responsive layout
                                if (MediaQuery.of(context).size.width > 800 && !_isMenuOpen) ...[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: _buildComponentsPieChart(),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        flex: 1,
                                        child: _buildTopUsersCard(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildProductionInsights(),
                                ] else ...[
                                  // Single column layout for smaller screens or when menu is open
                                  _buildComponentsPieChart(),
                                  const SizedBox(height: 16),
                                  _buildTopUsersCard(),
                                  const SizedBox(height: 16),
                                  _buildProductionInsights(),
                                ],
                                
                                const SizedBox(height: 24),
                              ],
                              
                            ),
                          ),
                        ),
                ),
              ),
            ),
            SideMenu(
              user: currentUser,
              toggleMenu: toggleMenu,
              slideAnimation: _slideAnimation,
            ),
            if (_isMenuOpen)
              Positioned.fill(
                left: isRTL ? 0 : menuWidth,
                right: isRTL ? menuWidth : 0,
                child: GestureDetector(
                  onTap: toggleMenu,
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionChip(String label, IconData icon, String route) {
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(context, route, arguments: widget.user),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}