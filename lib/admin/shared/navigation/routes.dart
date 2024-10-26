
import 'package:car_workshop_admin/admin/pages/entry_point.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const EntryPoint(),
    ),
   
  ],
);
