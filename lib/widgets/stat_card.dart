import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String judul;
  final int nilai;
  final IconData ikon;

  const StatCard({
    super.key,
    required this.judul,
    required this.nilai,
    required this.ikon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(ikon, color: colors.primary),
            const SizedBox(height: 8),
            Text('$nilai', style: Theme.of(context).textTheme.headlineMedium),
            Text(judul, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
