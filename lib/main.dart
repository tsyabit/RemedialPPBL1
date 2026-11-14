import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_routes.dart';
import 'pages/halaman_input_prediksi.dart';
import 'pages/halaman_tentang.dart';
import 'pages/kerangka_navigasi.dart';
import 'state/prediksi_model.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PrediksiModel(),
      child: const AgriClimaApp(),
    ),
  );
}

class AgriClimaApp extends StatelessWidget {
  const AgriClimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrediksiModel>(
      builder: (context, model, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AgriClima LSTM',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: model.themeMode,
          initialRoute: AppRoutes.beranda,
          routes: {
            AppRoutes.beranda: (_) => const KerangkaNavigasi(),
            AppRoutes.tentang: (_) => const HalamanTentang(),
            AppRoutes.inputPrediksi: (_) => const HalamanInputPrediksi(),
          },
        );
      },
    );
  }
}
