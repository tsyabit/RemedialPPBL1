import 'package:flutter/material.dart';

class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      const ListTile(
        leading: Icon(Icons.flag_outlined),
        title: Text('Tujuan Aplikasi'),
        subtitle: Text(
          'Mencatat hasil prediksi mikroklimat, melihat riwayat dan statistik, serta membantu menentukan perawatan tanaman.',
        ),
      ),
      const ListTile(
        leading: Icon(Icons.landscape_outlined),
        title: Text('Lokasi Pemantauan'),
        subtitle: Text('Petak 1 dan Petak 2'),
      ),
      const ListTile(
        leading: Icon(Icons.thermostat),
        title: Text('Suhu Udara'),
        subtitle: Text('Prediksi suhu udara dalam derajat Celsius (°C).'),
      ),
      const ListTile(
        leading: Icon(Icons.air),
        title: Text('Kelembapan Udara'),
        subtitle: Text('Prediksi kelembapan udara dalam persen (%).'),
      ),
      const ListTile(
        leading: Icon(Icons.water_drop_outlined),
        title: Text('Kelembapan Tanah'),
        subtitle: Text('Prediksi kelembapan tanah dalam persen (%).'),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang AgriClima')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) => items[index],
      ),
    );
  }
}
