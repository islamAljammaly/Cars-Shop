class CarModel {
  late String carId, type, image, number, color, userId, email, name;
  late double price;

  CarModel({
    required this.carId, 
    required this.type,
    required this.image,
    required this.number,
    required this.price,
    required this.color,
    required this.email,
    required this.userId,
    required this.name,
  });

  CarModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }

    carId = map['carId'] ?? '';
    type = map['type'];
    image = map['image'];
    color = map['color'];
    number = map['number'];
    userId = map['userId'];
    email = map['email'];
    name = map['name'];
    if (map['price'] is String) {
      price = double.tryParse(map['price']) ?? 0.0;  
    } else {
      price = map['price']?.toDouble() ?? 0.0;  
    }
  }

  toJson() {
    return {
      'carId': carId, 
      'type': type,
      'image': image,
      'color': color,
      'number': number,
      'price': price,
      'userId': userId,
      'email': email,
      'name': name,
    };
  }
}
