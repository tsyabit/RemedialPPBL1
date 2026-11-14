import 'dart:math';
import 'package:flutter/material.dart';

import '../models/hasil_prediksi.dart';

class PrediksiModel extends ChangeNotifier {
  final List<HasilPrediksi> _data = [];
  String _filterPetak = 'Semua';
  ThemeMode _themeMode = ThemeMode.light;

  List<HasilPrediksi> get data => List.unmodifiable(_data);
  String get filterPetak => _filterPetak;
  ThemeMode get themeMode => _themeMode;

  List<HasilPrediksi> get dataTerfilter => _filterPetak == 'Semua'
      ? data
      : _data.where((e) => e.petak == _filterPetak).toList();

  int get total => _data.length;
  int get jumlahOptimal => _data.where((e) => e.status == 'Optimal').length;
  int get perluTindakan =>
      _data.where((e) => e.status != 'Optimal').length;
  int get jumlahKering => _data.where((e) => e.status == 'Kering').length;
  int get jumlahTerlaluLembap =>
      _data.where((e) => e.status == 'Terlalu Lembap').length;

  void tambahData(HasilPrediksi hasil) {
    _data.insert(0, hasil);
    notifyListeners();
  }

  void hapusData(HasilPrediksi hasil) {
    _data.remove(hasil);
    notifyListeners();
  }

  void hapusSemuaData() {
    _data.clear();
    notifyListeners();
  }

  void setFilterPetak(String value) {
    _filterPetak = value;
    notifyListeners();
  }

  void toggleTheme(bool gelap) {
    _themeMode = gelap ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void muatDataSimulasi() {
    final random = Random();
    const petak = ['Petak 1', 'Petak 2'];
    const tanaman = ['Padi', 'Jagung', 'Cabai'];

    for (var i = 0; i < 10; i++) {
      _data.insert(
        0,
        HasilPrediksi(
          petak: petak[random.nextInt(petak.length)],
          tanaman: tanaman[random.nextInt(tanaman.length)],
          suhuUdara: (18 + random.nextInt(18)).toDouble(),
          kelembapanUdara: (40 + random.nextInt(61)).toDouble(),
          kelembapanTanah: (20 + random.nextInt(71)).toDouble(),
          namaPetugas: 'Petugas Simulasi',
          waktu: DateTime.now().subtract(Duration(hours: i)),
        ),
      );
    }
    notifyListeners();
  }
}
