import 'package:car_workshop_admin/admin/responsive.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../constants/defaults.dart';
import '../constants/ghaps.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.color = AppColors.secondaryPeach,
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
        gapW8,
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Responsive.isDesktop(context) ? null : 20,
              ),
        )
      ],
    );
  }
}
