class User {
  String? name;
  String? email;
  String? phone;
  String? password;
  String? confirmpassword;

  User({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.confirmpassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "confirmpassword": confirmpassword,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      password: json["password"],
      confirmpassword: json["confirmpassword"], // A confirmação de senha
    );
  }
}
