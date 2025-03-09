import 'package:debts/src/widgets/PanelNvigation.dart';
import 'package:debts/src/widgets/ThemeProviderMyCode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      drawer: PanelNavigation(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Переключение темы (светлая/темная)
          ListTile(
            title: Text('Тема приложения'),
            subtitle: Text(
              themeProvider.themeMode == ThemeMode.light
                  ? 'Светлая'
                  : themeProvider.themeMode == ThemeMode.dark
                  ? 'Темная'
                  : 'Системная',
            ),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),
          Divider(),
          // Выбор базового цвета
          ListTile(
            title: Text('Базовый цвет'),
            subtitle: Text('Выберите цвет темы'),
          ),
          Wrap(
            spacing: 8,
            children: [
              _buildColorChoice(Colors.blue, themeProvider),
              _buildColorChoice(Colors.red, themeProvider),
              _buildColorChoice(Colors.green, themeProvider),
              _buildColorChoice(Colors.orange, themeProvider),
              _buildColorChoice(Colors.purple, themeProvider),
              _buildColorChoice(Colors.teal, themeProvider),
            ],
          ),
        ],
      ),
    );
  }

  // Виджет для выбора цвета
  Widget _buildColorChoice(Color color, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () {
        themeProvider.setPrimaryColor(color);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: themeProvider.primaryColor == color
                ? Colors.black
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}