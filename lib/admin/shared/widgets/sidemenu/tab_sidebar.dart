import 'package:car_workshop_admin/admin/shared/constants/config.dart';
import 'package:car_workshop_admin/admin/shared/constants/defaults.dart';
import 'package:car_workshop_admin/admin/shared/constants/ghaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'icon_tile.dart';
import 'theme_icon_tile.dart';

class TabSidebar extends StatelessWidget {
  const TabSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDefaults.padding,
                vertical: AppDefaults.padding * 1.5),
            child: SvgPicture.asset(AppConfig.logo),
          ),
          gapH16,
          Expanded(
            child: SizedBox(
              width: 48,
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 
                ],
              ),
            ),
          ),
          Column(
            children: [
              IconTile(
                isActive: false,
                activeIconSrc: "assets/icons/arrow_forward_light.svg",
                onPressed: () {},
              ),
              const SizedBox(
                width: 48,
                child: Divider(thickness: 2),
              ),
              gapH4,
              IconTile(
                isActive: false,
                activeIconSrc: "assets/icons/help_light.svg",
                onPressed: () {},
              ),
              gapH4,
              ThemeIconTile(
                isDark: false,
                onPressed: () {},
              ),
              gapH16,
            ],
          )
        ],
      ),
    );
  }
}
