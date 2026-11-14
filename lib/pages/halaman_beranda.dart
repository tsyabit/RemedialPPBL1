import 'package:flutter/material.dart';
import '../app_routes.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: colors.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.eco, size: 42, color: colors.onPrimaryContainer),
                const SizedBox(height: 12),
                Text(
                  'Selamat Datang di AgriClima LSTM',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aplikasi pencatatan dan pemantauan prediksi mikroklimat tanaman untuk membantu petani mengambil keputusan perawatan lahan.',
                  style: TextStyle(color: colors.onPrimaryContainer),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        const _InfoModel(
          ikon: Icons.memory,
          judul: 'Model Deep Learning',
          isi: 'Long Short-Term Memory (LSTM)',
        ),
        const _InfoModel(
          ikon: Icons.schedule,
          judul: 'Horizon Prediksi',
          isi: 'Kondisi mikroklimat 24 jam ke depan',
        ),
        const _InfoModel(
          ikon: Icons.thermostat,
          judul: 'Parameter',
          isi: 'Suhu udara, kelembapan udara, dan kelembapan tanah',
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.tentang),
          icon: const Icon(Icons.info_outline),
          label: const Text('Tentang Aplikasi'),
        ),
      ],
    );
  }
}

class _InfoModel extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String isi;
  const _InfoModel({required this.ikon, required this.judul, required this.isi});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(ikon, color: Theme.of(context).colorScheme.primary),
        title: Text(judul),
        subtitle: Text(isi),
      ),
    );
  }
}
