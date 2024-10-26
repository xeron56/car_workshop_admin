import 'package:car_workshop_admin/admin/responsive.dart';
import 'package:car_workshop_admin/admin/shared/constants/defaults.dart';
import 'package:car_workshop_admin/admin/shared/widgets/sidemenu/sidebar.dart';
import 'package:car_workshop_admin/admin/shared/widgets/sidemenu/tab_sidebar.dart';
import 'package:flutter/material.dart';

import '../shared/widgets/header.dart';
import 'dashboard/dashboard_page.dart';

final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: Responsive.isMobile(context) ? Sidebar() : null,
      body: Row(
        children: [
          if (Responsive.isDesktop(context)) Sidebar(),
          if (Responsive.isTablet(context)) const TabSidebar(),
          Expanded(
            child: Column(
              children: [
                Header(drawerKey: _drawerKey),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1360),
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDefaults.padding *
                                (Responsive.isMobile(context) ? 1 : 1.5),
                          ),
                          child: SafeArea(child: DashboardPage()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
