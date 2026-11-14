import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/catatan_perawatan.dart';
import '../models/hasil_prediksi.dart';
import '../state/prediksi_model.dart';

class HalamanInputPrediksi extends StatefulWidget {
  const HalamanInputPrediksi({super.key});

  @override
  State<HalamanInputPrediksi> createState() => _HalamanInputPrediksiState();
}

class _HalamanInputPrediksiState extends State<HalamanInputPrediksi> {
  final _formKey = GlobalKey<FormState>();
  final _suhu = TextEditingController();
  final _udara = TextEditingController();
  final _tanah = TextEditingController();
  final _petugas = TextEditingController();
  String _petak = 'Petak 1';
  String _tanaman = 'Padi';
  bool _benar = false;

  @override
  void dispose() {
    _suhu.dispose();
    _udara.dispose();
    _tanah.dispose();
    _petugas.dispose();
    super.dispose();
  }

  String? _validasiAngka(String? value, {bool rentangPersen = false}) {
    final angka = double.tryParse((value ?? '').trim());
    if (angka == null) return 'Masukkan angka yang valid';
    if (rentangPersen && (angka < 0 || angka > 100)) {
      return 'Nilai harus berada pada rentang 0–100';
    }
    return null;
  }

  Future<void> _simpan() async {
    if (!_benar) return;
    if (!_formKey.currentState!.validate()) return;

    final hasil = HasilPrediksi(
      petak: _petak,
      tanaman: _tanaman,
      suhuUdara: double.parse(_suhu.text.trim()),
      kelembapanUdara: double.parse(_udara.text.trim()),
      kelembapanTanah: double.parse(_tanah.text.trim()),
      namaPetugas: _petugas.text.trim(),
      waktu: DateTime.now(),
    );

    final setuju = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Penyimpanan'),
        content: Text(
          'Simpan prediksi ${hasil.tanaman} di ${hasil.petak} dengan status ${hasil.status}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya, Simpan'),
          ),
        ],
      ),
    );

    if (setuju == true && mounted) {
      context.read<PrediksiModel>().tambahData(hasil);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data tersimpan')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Hasil Prediksi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Lokasi dan Tanaman', style: Theme.of(context).textTheme.titleMedium),
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: const Text('Petak 1'),
              value: 'Petak 1',
              groupValue: _petak,
              onChanged: (v) => setState(() => _petak = v!),
            ),
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: const Text('Petak 2'),
              value: 'Petak 2',
              groupValue: _petak,
              onChanged: (v) => setState(() => _petak = v!),
            ),
            DropdownButtonFormField<String>(
              value: _tanaman,
              decoration: const InputDecoration(
                labelText: 'Nama Tanaman',
                border: OutlineInputBorder(),
              ),
              items: ['Padi', 'Jagung', 'Cabai']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _tanaman = v!),
            ),
            const SizedBox(height: 18),
            Text('Hasil Prediksi', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            TextFormField(
              controller: _suhu,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Prediksi Suhu Udara (°C)',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _validasiAngka(v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _udara,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Prediksi Kelembapan Udara (%)',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _validasiAngka(v, rentangPersen: true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tanah,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Prediksi Kelembapan Tanah (%)',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _validasiAngka(v, rentangPersen: true),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _petugas,
              decoration: const InputDecoration(
                labelText: 'Nama Petugas',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Nama petugas wajib diisi'
                  : null,
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data sudah benar'),
              value: _benar,
              onChanged: (v) => setState(() => _benar = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            if (_benar && _tanah.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Catatan perawatan ${_tanaman}: ${catatanPerawatan[_tanaman]}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            FilledButton.icon(
              onPressed: _benar ? _simpan : null,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
