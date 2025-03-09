import 'package:flutter/material.dart';
import 'package:debts/src/widgets/PanelNvigation.dart';

class GetMoneyPage extends StatefulWidget {
  @override
  _GetMoneyPageState createState() => _GetMoneyPageState();
}

class _GetMoneyPageState extends State<GetMoneyPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Реквизиты'),
      ),
      drawer: PanelNavigation(),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: size.width - 50,
                  height: 300,
                  child: Card(
                    child: Column(
                      spacing: 10,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                            'assets/images/banks.jpg',
                            height: 150,
                        ),
                        Text('Ваши банки'),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('bank_view');
                            },
                            child: Text('Посмотреть')
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: size.width - 50,
                  height: 300,
                  child: Card(
                    child: Column(
                      spacing: 10,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                            'assets/images/images.png'
                        ),
                        Text('Ваши QR коды'),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('qr_code_list');
                            },
                            child: Text('Посмотреть')
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}