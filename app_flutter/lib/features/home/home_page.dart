import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Allprocar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(onPressed: ()=>context.go('/vehicles'), child: const Text('Mis vehículos')),
                ElevatedButton(onPressed: ()=>context.go('/request/new'), child: const Text('Nueva solicitud')),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Bienvenido. Crea una solicitud o gestiona tus vehículos.'),
          ],
        ),
      ),
    );
  }
}
