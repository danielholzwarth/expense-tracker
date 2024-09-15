import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final Function(BuildContext)? delete;

  const ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: delete,
            icon: Icons.delete,
            backgroundColor: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${dateTime.day} / ${dateTime.month} / ${dateTime.year}",
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.inversePrimary),
        ),
        trailing: Text(
          "$amount€",
          style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ),
    );
  }
}
