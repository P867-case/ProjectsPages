import 'package:debts/src/pages/GetMoneyPage.dart';
import 'package:debts/src/pages/MainPage.dart';
import 'package:debts/src/pages/SettingsPage.dart';
import 'package:debts/src/pages/ViewBank.dart';
import 'package:debts/src/pages/ViewQR.dart';
import 'package:debts/src/widgets/ThemeProviderMyCode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeProvider.primaryColor as MaterialColor,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: themeProvider.primaryColor as MaterialColor,
        brightness: Brightness.dark,
      ),
      themeMode: themeProvider.themeMode,
      home: MainPage(),
      routes: {
        "home": (context) => MainPage(),
        'requzit': (context) => GetMoneyPage(),
        'qr_code_list': (context) => QrListScreen(),
        "bank_view": (context) => BankListScreen(),
        'settings': (context) => SettingsScreen()
      },
    );
  }
}