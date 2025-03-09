import 'package:debts/src/models/ModelDabts.dart';
import 'package:flutter/material.dart';
import 'package:debts/src/widgets/PanelNvigation.dart';
import 'package:debts/src/widgets/Dialogs.dart'; // Импортируем диалог
import 'package:debts/src/widgets/Items.dart'; // Импортируем виджет элемента списка


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, dynamic>> debts = [];
  int _totalAmount = 0; // Инициализируем значением по умолчанию
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadDebts(); // Загружаем долги при запуске
  }

  Future<void> _loadDebts() async {
    final debtsFromDb = await _dbHelper.getDebts();
    setState(() {
      debts = debtsFromDb;
      _calculateTotalAmount(); // Пересчитываем общую сумму
    });
  }

  void _calculateTotalAmount() {
    int total = 0;
    for (final debt in debts) {
      total += debt['amount'] as int;
    }
    setState(() {
      _totalAmount = total; // Обновляем состояние
    });
  }

  Future<void> _addDebt(String name, String amount, String priority) async {
    final int amountInt = int.tryParse(amount) ?? 0;

    if (name.isEmpty || amountInt <= 0) {
      return;
    }

    final newDebt = {
      'name': name,
      'amount': amountInt,
      'priority': priority,
    };

    await _dbHelper.insertDebt(newDebt); // Сохраняем в базу данных
    await _loadDebts(); // Перезагружаем список долгов
  }

  Future<void> _removeDebt(int index) async {
    final debt = debts[index];
    await _dbHelper.deleteDebt(debt['id']); // Удаляем из базы данных
    await _loadDebts(); // Перезагружаем список долгов
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная'),
      ),
      drawer: PanelNavigation(),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            width: size.height - 200,
            child: Center(
              child: Text(
                'Ваш суммарный долг: $_totalAmount руб',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Ваши долги:',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: debts.isEmpty
                ? Center(
              child: Text(
                'Вы пока что не взяли ни одного долга',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
                : ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 10),
              padding: const EdgeInsets.all(10),
              itemCount: debts.length,
              itemBuilder: (BuildContext context, int index) {
                final debt = debts[index];
                return DebtsItem(
                  name: debt['name'],
                  amount: debt['amount'],
                  priority: debt['priority'],
                  onTap: () {
                    _showDeleteConfirmationDialog(context, index); // Открываем диалог
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDebtDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDebtDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddDebtDialog(
          onSave: (name, amount, priority) {
            _addDebt(name, amount, priority); // Добавляем новый долг
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Подтверждение'),
          content: Text('Вы отдали долг ${debts[index]['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалог
              },
              child: Text('Нет'),
            ),
            TextButton(
              onPressed: () {
                _removeDebt(index); // Удаляем долг
                Navigator.of(context).pop(); // Закрываем диалог
              },
              child: Text('Да'),
            ),
          ],
        );
      },
    );
  }
}