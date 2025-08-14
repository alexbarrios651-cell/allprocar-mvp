import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/login_page.dart';
import 'features/home/home_page.dart';
import 'features/requests/request_new_page.dart';
import 'features/vehicles/vehicles_page.dart';

void main() {
  runApp(const AllprocarApp());
}

class AllprocarApp extends StatelessWidget {
  const AllprocarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomePage()),
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/vehicles', builder: (_, __) => const VehiclesPage()),
        GoRoute(path: '/request/new', builder: (_, __) => const RequestNewPage()),
      ],
    );

    return MaterialApp.router(
      title: 'Allprocar',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(primary: Color(0xFF0E6BA8)),
        scaffoldBackgroundColor: const Color(0xFF0B132B),
      ),
      routerConfig: router,
    );
  }
}
