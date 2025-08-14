import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../core/api.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  List<dynamic> items = [];
  final marca = TextEditingController();
  final modelo = TextEditingController();
  final anio = TextEditingController();

  Future<void> _load() async {
    final dio = await Api.client();
    final res = await dio.get('/vehiculos');
    setState(() { items = res.data as List; });
  }

  Future<void> _add() async {
    try {
      final dio = await Api.client();
      await dio.post('/vehiculos', data: {
        'marca': marca.text, 'modelo': modelo.text, 'anio': int.tryParse(anio.text) ?? 0
      });
      marca.clear(); modelo.clear(); anio.clear();
      await _load();
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.response?.data?['error']?.toString() ?? 'Error')));
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehículos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: TextField(controller: marca, decoration: const InputDecoration(labelText: 'Marca'))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: modelo, decoration: const InputDecoration(labelText: 'Modelo'))),
              const SizedBox(width: 8),
              SizedBox(width: 100, child: TextField(controller: anio, decoration: const InputDecoration(labelText: 'Año'), keyboardType: TextInputType.number)),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _add, child: const Text('Agregar')),
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final v = items[i];
                  return ListTile(
                    title: Text('${v['marca']} ${v['modelo']}'),
                    subtitle: Text('${v['anio']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
