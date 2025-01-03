import 'package:flutter/material.dart';

class StatsItem extends StatelessWidget {
  const StatsItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.value});

  final String title;
  final IconData icon;
  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 4.0),
            Text(value)
          ],
        ),
      ],
    );
  }
}
