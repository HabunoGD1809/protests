import 'package:flutter/material.dart';
import 'package:project_protestas/models/protest.dart';
import 'package:intl/intl.dart';

class ProtestCard extends StatelessWidget {
  final Protest protest;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProtestCard({super.key,
    required this.protest,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(protest.natureIcon, color: protest.natureColor),
                const SizedBox(width: 8),
                Text(
                  protest.natureName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Provincia: ${protest.province}'),
            SizedBox(height: 4),
            Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(protest.dateTime)}'),
            SizedBox(height: 8),
            Text(
              protest.summary,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}