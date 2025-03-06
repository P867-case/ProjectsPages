import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// создание MaterialApp без баннера debug
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Padding(
        padding: EdgeInsets.all(32.0),
        child: SquareAnimation(),
      ),
    );
  }
}

/// Основной класс для вызова обьектов
class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

/// класс описания логики
class SquareAnimationState extends State<SquareAnimation>
    with SingleTickerProviderStateMixin {
  static const _squareSize = 50.0; /// размер кубика
  late AnimationController _controller; /// контроллер анимации
  late Animation<double> _animation; 
  double _position = 0.0;
  bool _isAnimating = false; /// переменная для контроля кнопки при анимации

  @override
  void initState() {
    super.initState();
    /// определение контроллера анимации
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    /// анимация
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {
          _position = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isAnimating = false; /// проверка анимации и установка состояния кнопок
          });
        }
      });
  }

  /// функция для вызова анимации
  void _moveSquare(double targetPosition) {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    _animation = Tween<double>(begin: _position, end: targetPosition).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 64; /// Учитываем padding
    final maxPosition = (screenWidth - _squareSize) / 2; /// Максимальное смещение от центра

    return Column(
      children: [
        Transform.translate(
          offset: Offset(_position, 0),
          child: Container(
            width: _squareSize,
            height: _squareSize,
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: _position <= -maxPosition || _isAnimating
                  ? null
                  : () => _moveSquare(-maxPosition),
              child: const Text('Left'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _position >= maxPosition || _isAnimating
                  ? null
                  : () => _moveSquare(maxPosition),
              child: const Text('Right'),
            ),
          ],
        ),
      ],
    );
  }
}