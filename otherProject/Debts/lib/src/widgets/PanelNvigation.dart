import 'package:flutter/material.dart';

class PanelNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text('Главная'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).pushNamed('home');
            },
          ),
          ListTile(
            title: Text('Реквизиты'),
            leading: Icon(Icons.qr_code),
            onTap: () {
              Navigator.of(context).pushNamed('requzit');
            },
          ),
          ListTile(
            title: Text('Настройки'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.of(context).pushNamed('settings');
            },
          ),
        ],
      ),
    );
  }
}