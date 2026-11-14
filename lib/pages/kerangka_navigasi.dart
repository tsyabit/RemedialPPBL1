import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../state/prediksi_model.dart';
import '../widgets/prediksi_card.dart';
import '../widgets/stat_card.dart';
import 'halaman_beranda.dart';

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int _index = 0;
  static const _namaTab = ['Beranda', 'Prediksi', 'Statistik', 'Pengaturan'];

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PrediksiModel>();
    final halaman = [
      const HalamanBeranda(),
      _halamanPrediksi(model),
      _halamanStatistik(model),
      _halamanPengaturan(model),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('AgriClima • ${_namaTab[_index]}'),
      ),
      body: IndexedStack(index: _index, children: halaman),
      floatingActionButton: _index == 1
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.inputPrediksi),
              icon: const Icon(Icons.add),
              label: const Text('Prediksi Baru'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: model.perluTindakan > 0,
              label: Text('${model.perluTindakan}'),
              child: const Icon(Icons.analytics_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: model.perluTindakan > 0,
              label: Text('${model.perluTindakan}'),
              child: const Icon(Icons.analytics),
            ),
            label: 'Prediksi',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  Widget _halamanPrediksi(PrediksiModel model) {
    final list = model.dataTerfilter;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: [
        Text('Riwayat Prediksi', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'Semua', label: Text('Semua')),
            ButtonSegment(value: 'Petak 1', label: Text('Petak 1')),
            ButtonSegment(value: 'Petak 2', label: Text('Petak 2')),
          ],
          selected: {model.filterPetak},
          onSelectionChanged: (v) => model.setFilterPetak(v.first),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.08,
          crossAxisSpacing: 8,
          children: [
            StatCard(judul: 'Total', nilai: model.total, ikon: Icons.dataset),
            StatCard(judul: 'Optimal', nilai: model.jumlahOptimal, ikon: Icons.check_circle),
            StatCard(judul: 'Perlu Tindakan', nilai: model.perluTindakan, ikon: Icons.warning_amber),
          ],
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('Belum ada data')),
          )
        else
          ...list.map(
            (hasil) => PrediksiCard(
              hasil: hasil,
              onDelete: () => model.hapusData(hasil),
            ),
          ),
      ],
    );
  }

  Widget _halamanStatistik(PrediksiModel model) {
    final values = [
      model.jumlahKering.toDouble(),
      model.jumlahOptimal.toDouble(),
      model.jumlahTerlaluLembap.toDouble(),
    ];
    final maxY = (values.reduce((a, b) => a > b ? a : b) + 2).clamp(4, 100).toDouble();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Statistik Mikroklimat', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Jumlah hasil prediksi berdasarkan status kelembapan tanah.'),
        const SizedBox(height: 24),
        SizedBox(
          height: 280,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              barGroups: List.generate(3, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: values[i],
                      width: 34,
                      borderRadius: BorderRadius.circular(6),
                      color: [Colors.orange, Colors.green, Colors.blue][i],
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const labels = ['Kering', 'Optimal', 'Terlalu\\nLembap'];
                      final i = value.toInt();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(i >= 0 && i < labels.length ? labels[i] : ''),
                      );
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        Text('Total data: ${model.total}'),
      ],
    );
  }

  Widget _halamanPengaturan(PrediksiModel model) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Mode Gelap'),
          subtitle: const Text('Ubah tampilan terang atau gelap aplikasi'),
          value: model.themeMode == ThemeMode.dark,
          onChanged: model.toggleTheme,
          secondary: const Icon(Icons.dark_mode_outlined),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.auto_awesome),
          title: const Text('Muat Data Simulasi'),
          subtitle: const Text('Tambahkan 10 data prediksi acak'),
          onTap: () {
            model.muatDataSimulasi();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('10 data simulasi berhasil dimuat')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
          title: const Text('Hapus Semua Data'),
          onTap: () async {
            final yakin = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Hapus semua data?'),
                content: const Text('Seluruh riwayat prediksi akan dihapus.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Batal'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            );
            if (yakin == true) model.hapusSemuaData();
          },
        ),
      ],
    );
  }
}
