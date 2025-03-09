import 'package:flutter/material.dart';

class DebtsItem extends StatelessWidget {
  final String name;
  final int amount;
  final String priority;
  final VoidCallback onTap;

  DebtsItem({
    required this.name,
    required this.amount,
    required this.priority,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        title: Text(name),
        subtitle: Text('Сумма: $amount руб'),
        trailing: Text(
          'Приоритет: $priority',
          style: TextStyle(
            color: priority == 'high'
                ? Colors.red
                : priority == 'medium'
                ? Colors.orange
                : Colors.green,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}