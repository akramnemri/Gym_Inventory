import 'package:flutter/material.dart';
import 'dart:convert';
import 'dashboard_back_button.dart';
import 'theme.dart';
import 'l10n/app_localizations.dart';
import 'config/api_client.dart';

class SessionLogsScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const SessionLogsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _SessionLogsScreenState createState() => _SessionLogsScreenState();
}

class _SessionLogsScreenState extends State<SessionLogsScreen> {
  List<Map<String, dynamic>> sessionLogs = [];
  Map<String, dynamic>? _groupedSessions;
  bool _loading = false;
  bool _dataLoaded = false;
  String? sessionError;

  Map<String, bool> _weekExpanded = {};
  Map<String, bool> _userExpanded = {};

  @override
  void initState() {
    super.initState();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    setState(() {
      _loading = true;
      _dataLoaded = false;
    });

    try {
      final endpoint = '/api/sessions?user_id=${widget.user['id']}&is_admin=${widget.user['type_account'] == 'admin'}';
      final res = await ApiClient.get(endpoint);
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is Map && decoded.containsKey('grouped_sessions')) {
          setState(() {
            sessionLogs = decoded['raw_logs'] is List
                ? List<Map<String, dynamic>>.from(decoded['raw_logs'])
                : [];
            _groupedSessions = decoded['grouped_sessions'] as Map<String, dynamic>;
            sessionError = null;
            _dataLoaded = true;
          });
        } else if (decoded is List) {
          setState(() {
            sessionLogs = List<Map<String, dynamic>>.from(decoded);
            _groupedSessions = null;
            sessionError = null;
            _dataLoaded = true;
          });
        } else {
          setState(() => sessionError = AppLocalizations.of(context)!.sessionLogsErrorLoading);
        }
      } else {
        setState(() => sessionError = 'Sessions fetch failed: ${res.statusCode}');
      }
    } catch (e, st) {
      print('Error in fetchSessions: $e\n$st');
      setState(() => sessionError = AppLocalizations.of(context)!.sessionLogsErrorLoading);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String getUserFullName(Map<String, dynamic> session) {
    if (session.containsKey('first_name') && session.containsKey('last_name')) {
      return '${session['first_name']} ${session['last_name']}';
    }
    return '';
  }

  String getWeekKey(DateTime dt) {
    int week = ((dt.day - dt.weekday + 10) / 7).floor();
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-W$week';
  }

  Map<String, Map<String, Map<int, List<Map<String, dynamic>>>>> groupSessions(List<Map<String, dynamic>> logs) {
    Map<String, Map<String, Map<int, List<Map<String, dynamic>>>>> grouped = {};
    for (var session in logs) {
      final userId = session['user_id'].toString();
      final fullName = getUserFullName(session);
      final loginTimeStr = session['login_time'];
      final logoutTimeStr = session['logout_time'];

      DateTime? loginTime;

      try { loginTime = DateTime.parse(loginTimeStr.replaceAll(' ', 'T')); } catch (_) {}

      if (loginTime == null) continue;

      final weekKey = getWeekKey(loginTime);
      final dayInt = loginTime.day;
      final dateKey = '${loginTime.year}-${loginTime.month.toString().padLeft(2, '0')}-${loginTime.day.toString().padLeft(2, '0')}';

      grouped.putIfAbsent(weekKey, () => {});
      grouped[weekKey]!.putIfAbsent(userId, () => {});
      grouped[weekKey]![userId]!.putIfAbsent(dayInt, () => []);
      grouped[weekKey]![userId]![dayInt]!.add({
        'login': loginTimeStr,
        'logout': logoutTimeStr,
        'fullName': fullName,
        'dateKey': dateKey,
      });
    }
    return grouped;
  }

  Widget _buildSessionLogCards() {
    final groupedData = _groupedSessions != null
        ? _groupedSessions
        : groupSessions(sessionLogs);

    if (groupedData == null || groupedData.isEmpty) {
      return Container(
        height: 300,
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.sessionLogsNoLogs,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    List<Widget> weekCards = [];
    groupedData.forEach((weekKey, userMap) {
      final parts = weekKey.split('-');
      final year = parts[0];
      final month = parts[1];
      final weekNum = parts[2];
      final weekHeader = '$year, $month, $weekNum';

      weekCards.add(
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          color: Theme.of(context).cardColor,
          elevation: 8,
          child: ExpansionTile(
            title: Text(weekHeader,
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            initiallyExpanded: _weekExpanded[weekKey] ?? false,
            onExpansionChanged: (expanded) {
              setState(() { _weekExpanded[weekKey] = expanded; });
            },
            children: (userMap as Map).entries.map((userEntry) {
              final userId = userEntry.key;
              final perDay = userEntry.value['days'];
              final fullName = userEntry.value['fullName'];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                color: Theme.of(context).cardColor,
                elevation: 4,
                child: ExpansionTile(
                  title: Text('${AppLocalizations.of(context)!.dashboardUserID} ($fullName)',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                  initiallyExpanded: _userExpanded['$weekKey-$userId'] ?? false,
                  onExpansionChanged: (expanded) {
                    setState(() { _userExpanded['$weekKey-$userId'] = expanded; });
                  },
                  children: (perDay as Map).entries.map((dayEntry) {
                    final activityList = dayEntry.value;
                    final dateStr = activityList[0]['login'].toString().substring(0, 10);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      color: Theme.of(context).cardColor,
                      elevation: 2,
                      child: ExpansionTile(
                        title: Text('${AppLocalizations.of(context)!.dashboardLoginDate}: $dateStr',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 2),
                            child: Text('${AppLocalizations.of(context)!.dashboardActivity}:', 
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              )),
                          ),
                          ...activityList.map((activity) {
                            final loginStr = activity['login'];
                            final logoutStr = activity['logout'];
                            DateTime? loginDt;
                            DateTime? logoutDt;
                            try { loginDt = DateTime.parse(loginStr.replaceAll(' ', 'T')); } catch (e) { loginDt = null; }
                            if (logoutStr != null && logoutStr != '') {
                              try { logoutDt = DateTime.parse(logoutStr.replaceAll(' ', 'T')); } catch (e) { logoutDt = null; }
                            } else { logoutDt = null; }
                            String activityStr;
                            bool isActive = false;
                            if (loginDt != null && logoutDt != null) {
                              activityStr =
                                  '${loginDt.hour.toString().padLeft(2, '0')}:${loginDt.minute.toString().padLeft(2, '0')} --> ${logoutDt.hour.toString().padLeft(2, '0')}:${logoutDt.minute.toString().padLeft(2, '0')}';
                            } else if (loginDt != null) {
                              activityStr =
                                  '${loginDt.hour.toString().padLeft(2, '0')}:${loginDt.minute.toString().padLeft(2, '0')} --> ${AppLocalizations.of(context)!.dashboardActive}';
                              isActive = true;
                            } else {
                              activityStr = AppLocalizations.of(context)!.dashboardInvalidDate;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(left: 24.0, top: 4, bottom: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      activityStr,
                                      style: TextStyle(
                                        color: isActive
                                            ? Colors.greenAccent
                                            : Theme.of(context).colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ),
      );
    });

    return Column(children: weekCards);
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
            Text(AppLocalizations.of(context)!.sessionLogsTitle),
          ],
        ),
        actions: [
          IconButton(
            onPressed: fetchSessions,
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.sessionLogsRefresh,
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
                  onRefresh: fetchSessions,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (sessionError != null)
                            Card(
                              color: Theme.of(context).colorScheme.errorContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  sessionError!,
                                  style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          _buildSessionLogCards(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}