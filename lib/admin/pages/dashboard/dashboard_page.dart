import 'package:car_workshop_admin/admin/pages/dashboard/widgets/bookinglist.dart';
import 'package:car_workshop_admin/admin/pages/dashboard/widgets/overview.dart';

import 'package:car_workshop_admin/admin/responsive.dart';
import 'package:flutter/material.dart';

import '../../shared/constants/ghaps.dart';




class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!Responsive.isMobile(context)) gapH24,
        Text(
          "Dashboard",
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        gapH20,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const Overview(),
                  gapH16,
                  
                  if (Responsive.isMobile(context))
                    Column(
                      children: [
                         gapH16,
                         BookingList(),
                       
                        gapH8,
                      ],
                    ),
                ],
              ),
            ),
            if (!Responsive.isMobile(context)) gapW16,
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    BookingList(),
                  
                    gapH8,
                  ],
                ),
              ),
          ],
        )
      ],
    );
  }
}
