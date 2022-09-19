class Signup {
  final String email;
  final String name;
  final String password;
  Signup(this.email, this.name, this.password);

  factory Signup.fromJson(Map<String, dynamic> json) {
    return Signup(
      json["email"] ?? "",
      json["name"] ?? "",
      json["password"] ?? "",
    );
  }
}
