import 'dart:js_interop';

import 'package:flutter/material.dart';
import "package:universal_html/html.dart" as html;
import 'package:web/web.dart' as web;

void main() {
  runApp(const MyApp());
}


/// Само приложение
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test of app',
      home: const HomePage()
    );
  }
}

///[Виджет] отображает домашнюю страницу, состоящую из изображения и кнопок.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

///Состояние [Домашней страницы].
class _HomePageState extends State<HomePage> {
  final TextEditingController _url = TextEditingController();
  bool _isActiveButton = false;
  bool _isDarkened = false;
  String? _selectedValue;
  bool _isfullscreen = true;
  
  /// Вызывается после присоединения `element` к DOM.
  void onElementAttached(web.HTMLDivElement element) {
    final web.Element? located = web.document.querySelector('#someIdThatICanFindLater');
    assert(located == element, 'Wrong `element` located!');
    /// Выполнение действия с `element` или `located` или вызовите свой код прямо сейчас...
    element.style.backgroundColor = 'green';
  }

  void onElementCreated(Object element) {
    element as web.HTMLDivElement;
    element.id = 'someIdThatICanFindLater';

    /// Создайте observer
    final web.ResizeObserver observer = web.ResizeObserver((
      JSArray<web.ResizeObserverEntry> entries,
      web.ResizeObserver observer,
    ) {
      if (element.isConnected) {
        /// observer готов, отключите его.
        observer.disconnect();
        /// вызов функции.
        onElementAttached(element);
      }
    }.toJS);

    /// Подключени к observer.
    observer.observe(element);
  }

  void _addImageToHtml(String url) {
    if (url.isNotEmpty) {
      /// Ищем контейнер для добавления
      var container = html.document.getElementById('someIdThatICanFindLater');
      /// очищаем
      container?.innerHtml = '';
      
      /// создаем картинку
      var imageElement = html.ImageElement()
      ..src = url
      ..alt = 'Image from URL'
      ..id = 'Image';

      ///создаем таргет для onDoubleClick
      imageElement.onDoubleClick.listen((event) {
        _toggleFullscreen();
      });

      /// устанавливаем размеры для картинки
      imageElement.style.width = '100%';
      imageElement.style.height = '100%'; 

      container?.append(imageElement);
    }
  }

  /// Функция для перключения режима
  void _toggleFullscreen() {
    ///Получить текущий элемент в полноэкранном режиме
    setState(() {
      _isfullscreen = !_isfullscreen;
    });
  }

  /// Проверка не является пустым текстовым полем URL
  void _checkIfButtonShouldBeEnabled(String text) {
    setState(() {
      _isActiveButton = text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            /// Основной виджет, содержащий инструкции по отображению виджетов.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child:  SizedBox(
                    height: _isfullscreen ? 500 : screenSize.height - 100,
                    child:  Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        /// контейнер для изображения, которое приложение затем добавит с помощью функции _addImageToHtml
                        child:Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:HtmlElementView.fromTagName(
                            tagName: 'div',
                            onElementCreated: (element) => onElementCreated(element),
                          )
                        )
                      ),
                    ),
                  )
                ),
                if (_isfullscreen)
                 Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Image URL'),
                          controller: _url,
                          onChanged: _checkIfButtonShouldBeEnabled,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _isActiveButton ? () => _addImageToHtml(_url.text) : null,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 64)
              ],
            ),
          ),
          /// Добавить затемнение при открытии меню действий
          if (_isDarkened)
            ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.darken),
              child: ModalBarrier(dismissible: false, color: Colors.transparent),
            ),
          Positioned(
            right: 15,
            bottom: 15,
            child: PopupMenuButton<String>(
              offset: Offset(0, -120),
              child:Container(
                width: 56.0,
                height: 56.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.menu,
                  size: 26.0,
                  color: Colors.white,
                ),
              ),
              onCanceled: () {
                setState(() {
                  _isDarkened = false;
                });
              },
              onOpened: () {
                setState(() {
                  _isDarkened = true;
                });
              },
              onSelected: (value) {
                /// Обработать выбор
                if (value == 'Enter fullscreen') {
                  setState(() {
                    _selectedValue = value;
                    _isDarkened = false;
                    _isfullscreen = false;
                  });
                } else {
                  setState(() {
                    _selectedValue = value;
                    _isDarkened = false;
                    _isfullscreen = true;
                  });
                  html.document.exitFullscreen();
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'Enter fullscreen',
                    child: Text('Enter fullscreen'),
                  ),
                  PopupMenuItem(
                    value: 'Exit fullscreen',
                    child: Text('Exit fullscreen'),
                  ),
                ];
              },
            ),
          )
        ],
      ), 
    );
  }
}
