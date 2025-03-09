class QrCode {
  int? id;
  String name;
  String imagePath;

  QrCode({
    this.id,
    required this.name,
    required this.imagePath,
  });

  // Преобразование объекта в Map для сохранения в базу данных
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
    };
  }

  // Создание объекта из Map
  factory QrCode.fromMap(Map<String, dynamic> map) {
    return QrCode(
      id: map['id'],
      name: map['name'],
      imagePath: map['imagePath'],
    );
  }
}