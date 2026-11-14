import 'package:flutter/material.dart';
import '../models/hasil_prediksi.dart';

class PrediksiCard extends StatelessWidget {
  final HasilPrediksi hasil;
  final VoidCallback? onDelete;

  const PrediksiCard({super.key, required this.hasil, this.onDelete});

  Color _warna(String status, ColorScheme scheme) {
    switch (status) {
      case 'Kering':
        return Colors.orange;
      case 'Optimal':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  IconData _ikon(String status) {
    switch (status) {
      case 'Kering':
        return Icons.water_drop_outlined;
      case 'Optimal':
        return Icons.check_circle_outline;
      default:
        return Icons.opacity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _warna(hasil.status, Theme.of(context).colorScheme);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${hasil.petak} • ${hasil.tanaman}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  avatar: Icon(_ikon(hasil.status), size: 17, color: color),
                  label: Text(hasil.status),
                  side: BorderSide(color: color),
                ),
                if (onDelete != null)
                  IconButton(
                    tooltip: 'Hapus data',
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text('Kelembapan tanah: ${hasil.kelembapanTanah.toStringAsFixed(0)}%'),
            const SizedBox(height: 5),
            LinearProgressIndicator(
              value: (hasil.kelembapanTanah / 100).clamp(0.0, 1.0),
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                Text('Suhu: ${hasil.suhuUdara.toStringAsFixed(1)} °C'),
                Text('Udara: ${hasil.kelembapanUdara.toStringAsFixed(0)}%'),
              ],
            ),
            const SizedBox(height: 8),
            Text('Rekomendasi: ${hasil.rekomendasi}'),
            Text(
              'Petugas: ${hasil.namaPetugas} • ${hasil.waktu.toLocal().toString().substring(0, 16)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
