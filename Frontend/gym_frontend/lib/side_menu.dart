import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'config/api_config.dart';

class SideMenu extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback toggleMenu;
  final Animation<Offset> slideAnimation;

  const SideMenu({
    super.key,
    required this.user,
    required this.toggleMenu,
    required this.slideAnimation,
  });

  Widget _menuButton(
      BuildContext context, String title, IconData icon, String route,
      {bool isLogout = false}) {
    return SizedBox(
      width: 180,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        icon: Icon(icon, size: 22),
        label: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        onPressed: () {
          if (isLogout) {
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pushReplacementNamed(
              context,
              route,
              arguments: user,
            );
          }
          toggleMenu();
        },
      ),
    );
  }

  Widget _elegantDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Container(
        height: 1,
        color: Colors.grey.withOpacity(0.25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: Align(
        alignment: Directionality.of(context) == TextDirection.rtl
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          width: 280,
          height: double.infinity,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundImage: user['profile_picture'] != null
                          ? NetworkImage(
                              ApiConfig.getUploadUrl(user['profile_picture']))
                          : null,
                      child: user['profile_picture'] == null
                          ? const Icon(Icons.person,
                              size: 38, color: Colors.tealAccent)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${user['type_account'] == 'admin' ? AppLocalizations.of(context)!.dashboardAdmin : AppLocalizations.of(context)!.dashboardUser}: ${user['username'] ?? user['name'] ?? AppLocalizations.of(context)!.dashboardUser}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _menuButton(context,
                          AppLocalizations.of(context)!.dashboardAccount,
                          Icons.person, '/account'),
                      _elegantDivider(context),

                      _menuButton(context,
                          AppLocalizations.of(context)!.dashboardComponents,
                          Icons.extension, '/components'),
                      const SizedBox(height: 15),
                      _menuButton(context,
                          AppLocalizations.of(context)!.dashboardProducts,
                          Icons.inventory, '/products'),
                      _elegantDivider(context),

                      _menuButton(context,
                          AppLocalizations.of(context)!.stockMovementsSideMenu,
                          Icons.trending_up, '/stock-movements'),
                      const SizedBox(height: 15),
                      _menuButton(context,
                          AppLocalizations.of(context)!.sessionLogsTitle,
                          Icons.history, '/session-logs'),
                      const SizedBox(height: 15),
                      _menuButton(context,
                          AppLocalizations.of(context)!.lowStockTitle,
                          Icons.warning, '/low-stock'),
                      _elegantDivider(context),

                      _menuButton(context,
                          AppLocalizations.of(context)!.dashboardLogout,
                          Icons.logout, '/login',
                          isLogout: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
