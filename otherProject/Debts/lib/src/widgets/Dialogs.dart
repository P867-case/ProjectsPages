import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddQrDialog extends StatefulWidget {
  // Функция, которая будет вызвана при нажатии на кнопку "Добавить"
  final Function(String name, File? image) onAddPressed;

  AddQrDialog({required this.onAddPressed});

  @override
  _AddQrDialogState createState() => _AddQrDialogState();
}

class _AddQrDialogState extends State<AddQrDialog> {
  // Контроллер для текстового поля
  final TextEditingController _nameController = TextEditingController();

  // Переменная для хранения выбранного файла
  File? _selectedImage;

  // Функция для выбора изображения
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Добавить QR-код'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Поле для ввода названия
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Краткое название',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          // Кнопка для выбора изображения
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Выбрать файл QR-кода'),
          ),
          SizedBox(height: 8),
          // Отображение выбранного файла
          if (_selectedImage != null)
            Text(
              'Файл выбран: ${_selectedImage!.path.split('/').last}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
        ],
      ),
      actions: [
        // Кнопка "Отмена"
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Закрыть диалог
          },
          child: Text('Отмена'),
        ),
        // Кнопка "Добавить"
        TextButton(
          onPressed: () {
            // Вызываем функцию onAddPressed с данными
            widget.onAddPressed(_nameController.text, _selectedImage);
            Navigator.of(context).pop(); // Закрыть диалог
          },
          child: Text('Добавить'),
        ),
      ],
    );
  }
}

class AddDebtDialog extends StatefulWidget {
  final Function(String name, String amount, String priority) onSave;

  AddDebtDialog({required this.onSave});

  @override
  _AddDebtDialogState createState() => _AddDebtDialogState();
}

class _AddDebtDialogState extends State<AddDebtDialog> {
  String name = '';
  String amount = '';
  String priority = 'medium'; // Начальное значение приоритета

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Добавить долг'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Имя кому должны'),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Сумма долга'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                amount = value;
              });
            },
          ),
          DropdownButton<String>(
            value: priority,
            onChanged: (String? newValue) {
              setState(() {
                priority = newValue!; // Обновляем значение приоритета
              });
            },
            items: <String>['high', 'medium', 'low']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Закрываем диалог
          },
          child: Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            if (name.isNotEmpty && amount.isNotEmpty) {
              widget.onSave(name, amount, priority);
              Navigator.of(context).pop();// Передаем данные обратно
            }
          },
          child: Text('Добавить'),
        ),
      ],
    );
  }
}

class AddBankDialog extends StatelessWidget {
  // Контроллеры для текстовых полей
  final TextEditingController nameController;
  final TextEditingController phoneController;

  // Функция, которая будет вызвана при нажатии на кнопку "Добавить"
  final VoidCallback onAddPressed;

  AddBankDialog({
    required this.nameController,
    required this.phoneController,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Добавить банк'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Поле для ввода названия банка
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Название банка',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          // Поле для ввода номера телефона
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Номер для пополнения',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        // Кнопка "Отмена"
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Закрыть диалог
          },
          child: Text('Отмена'),
        ),
        // Кнопка "Добавить"
        TextButton(
          onPressed: onAddPressed,
          child: Text('Добавить'),
        ),
      ],
    );
  }
}