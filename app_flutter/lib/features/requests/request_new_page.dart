import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/api.dart';

class RequestNewPage extends StatefulWidget {
  const RequestNewPage({super.key});

  @override
  State<RequestNewPage> createState() => _RequestNewPageState();
}

class _RequestNewPageState extends State<RequestNewPage> {
  List<dynamic> vehicles = [];
  Map<String, List<dynamic>> specialties = {};
  String? selectedVehicle;
  String? selectedSpecialty;
  final sintomas = TextEditingController();
  String? info;

  Future<void> _loadVehicles() async {
    final dio = await Api.client();
    final res = await dio.get('/vehiculos');
    setState(() { vehicles = res.data as List; });
  }

  Future<void> _loadSpecialties() async {
    final dio = await Api.client();
    final res = await dio.get('/catalog/specialties');
    setState(() { specialties = Map<String, List<dynamic>>.from(res.data as Map); });
  }

  Future<Position> _getPosition() async {
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    return Geolocator.getCurrentPosition();
  }

  Future<void> _createRequest() async {
    if (selectedVehicle == null || selectedSpecialty == null || sintomas.text.isEmpty) {
      setState(() { info = 'Selecciona vehículo, especialidad y describe los síntomas.'; });
      return;
    }
    final pos = await _getPosition();
    final dio = await Api.client();
    final res = await dio.post('/solicitudes', data: {
      'idVehiculo': selectedVehicle,
      'especialidad': selectedSpecialty,
      'sintomas': sintomas.text,
      'geo': { 'lat': pos.latitude, 'lng': pos.longitude }
    });
    setState(() { info = 'Solicitud creada: ${res.data['id']}'; });
  }

  @override
  void initState() {
    super.initState();
    _loadVehicles();
    _loadSpecialties();
  }

  @override
  Widget build(BuildContext context) {
    final flatSpecs = specialties.entries.expand((e) => e.value.map((v) => {'group': e.key, 'value': v['value'], 'label': v['label']})).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedVehicle,
              items: vehicles.map((v) => DropdownMenuItem<String>(value: v['id'], child: Text('${v['marca']} ${v['modelo']} (${v['anio']})'))).toList(),
              onChanged: (v)=>setState(()=>selectedVehicle=v),
              decoration: const InputDecoration(labelText: 'Vehículo'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedSpecialty,
              items: flatSpecs.map((s)=>DropdownMenuItem<String>(value: s['value'] as String, child: Text('${s['label']} (${s['group']})'))).toList(),
              onChanged: (v)=>setState(()=>selectedSpecialty=v),
              decoration: const InputDecoration(labelText: 'Especialidad'),
            ),
            const SizedBox(height: 12),
            TextField(controller: sintomas, maxLines: 3, decoration: const InputDecoration(labelText: 'Síntomas / descripción')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _createRequest, child: const Text('Crear solicitud')),
            if (info != null) Padding(padding: const EdgeInsets.only(top:12), child: Text(info!)),
          ],
        ),
      ),
    );
  }
}
