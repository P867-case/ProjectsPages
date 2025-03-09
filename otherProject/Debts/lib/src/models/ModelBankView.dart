class Bank {
  int? id;
  String name;
  String phone;

  Bank({
    this.id,
    required this.name,
    required this.phone,
  });

  // Преобразование объекта в Map для сохранения в базу данных
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

  // Создание объекта из Map
  factory Bank.fromMap(Map<String, dynamic> map) {
    return Bank(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
    );
  }
}