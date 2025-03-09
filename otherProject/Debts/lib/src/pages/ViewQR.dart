import 'package:debts/src/models/ModelQrCode.dart';
import 'package:debts/src/widgets/Dialogs.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:debts/src/models/ClassOfWorkWithModelQr.dart'; // Импортируем класс для работы с базой данных

class FullScreenQrScreen extends StatelessWidget {
  final String name;
  final File image;

  const FullScreenQrScreen({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Image.file(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class QrListScreen extends StatefulWidget {
  @override
  _QrListScreenState createState() => _QrListScreenState();
}

class _QrListScreenState extends State<QrListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<QrCode> qrCodes = [];

  @override
  void initState() {
    super.initState();
    _loadQrCodes();
  }

  // Загрузка QR-кодов из базы данных
  Future<void> _loadQrCodes() async {
    final qrCodesFromDb = await _dbHelper.getQrCodes();
    setState(() {
      qrCodes = qrCodesFromDb;
    });
  }

  // Отображение диалогового окна для добавления QR-кода
  void _showAddQrDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddQrDialog(
          onAddPressed: (String name, File? image) async {
            if (name.isNotEmpty && image != null) {
              final qrCode = QrCode(
                name: name,
                imagePath: image.path,
              );
              await _dbHelper.insertQrCode(qrCode);
              _loadQrCodes(); // Обновляем список после добавления
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список QR-кодов'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddQrDialog,
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: qrCodes.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final qr = qrCodes[index];
          return GestureDetector(
            onTap: () {
              // Открываем QR-код на весь экран
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenQrScreen(
                    name: qr.name,
                    image: File(qr.imagePath),
                  ),
                ),
              );
            },
            child: Container(
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
                    qr.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (qr.imagePath.isNotEmpty)
                    Image.file(
                      File(qr.imagePath),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}