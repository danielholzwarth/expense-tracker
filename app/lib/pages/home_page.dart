import 'package:app/components/drawer.dart';
import 'package:app/components/expense_summary.dart';
import 'package:app/components/expense_tile.dart';
import 'package:app/data/expense_data.dart';
import 'package:app/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseEurosController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add new expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(hintText: "Expense name"),
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: newExpenseEurosController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Euros"),
                )),
                const SizedBox(width: 8),
                Expanded(
                    child: TextField(
                  controller: newExpenseCentsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Cents"),
                )),
              ],
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () => saveExpense(
              newExpenseNameController.text,
              newExpenseEurosController.text,
              newExpenseCentsController.text,
            ),
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: () {
              clearControllers();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void saveExpense(String name, String euros, String cents) {
    if (name.isNotEmpty) {
      if (euros.isEmpty && cents.isEmpty) return;
      if (euros.isEmpty) euros = "0";
      if (cents.isEmpty) cents = "00";
      if (cents.length == 1) cents = "0$cents";

      String amount = "$euros.$cents";
      ExpenseItem newExpense = ExpenseItem(name: name, amount: amount, dateTime: DateTime.now());
      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
      clearControllers();
      Navigator.pop(context);
    }
  }

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void clearControllers() {
    newExpenseNameController.clear();
    newExpenseEurosController.clear();
    newExpenseCentsController.clear();
  }

  @override
  void initState() {
    Provider.of<ExpenseData>(context, listen: false).prepareData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getAllExpenseList().length,
              itemBuilder: (context, index) => ExpenseTile(
                name: value.getAllExpenseList()[index].name,
                amount: value.getAllExpenseList()[index].amount,
                dateTime: value.getAllExpenseList()[index].dateTime,
                delete: (p0) => deleteExpense(value.getAllExpenseList()[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
