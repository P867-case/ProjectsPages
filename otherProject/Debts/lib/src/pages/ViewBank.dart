import 'package:flutter/material.dart';
import '../models/ClassOfWorkWithBank.dart';
import '../models/ModelBankView.dart';

class BankListScreen extends StatefulWidget {
  @override
  _BankListScreenState createState() => _BankListScreenState();
}

class _BankListScreenState extends State<BankListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Bank> banks = [];

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  // Загрузка банков из базы данных
  Future<void> _loadBanks() async {
    final banksFromDb = await _dbHelper.getBanks();
    setState(() {
      banks = banksFromDb;
    });
  }

  // Отображение диалогового окна для добавления банка
  void _showAddBankDialog() {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить банк'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Название банка',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Номер для пополнения',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty &&
                    _phoneController.text.isNotEmpty) {
                  final bank = Bank(
                    name: _nameController.text,
                    phone: _phoneController.text,
                  );
                  await _dbHelper.insertBank(bank);
                  _loadBanks(); // Обновляем список после добавления
                  Navigator.of(context).pop();
                }
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список банков'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddBankDialog,
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: banks.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final bank = banks[index];
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bank.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Телефон для пополнения: ${bank.phone}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}