class User {
  final String name;
  final String email;

  User({
    required this.name,
    required this.email,
  });

  String get displayName => name;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }

  @override
  String toString() {
    return 'User(name: $name, email: $email)';
  }
}