class Pet {
  final String id;
  final String name;
  final int age;
  final int weight;
  final String imagePath;

  Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.imagePath,
  });

  // Método para converter um objeto JSON em um Pet
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      weight: json['weight'],
      imagePath: json['imagePath'],
    );
  }

  // Método para converter um Pet em um objeto JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'imagePath': imagePath,
    };
  }
}
