class User {
  final String id;
  final String name;
  final String email;
  final String password; // 🔹 Tambahan field password
  final String role;

  User({
    this.id = '',
    this.name = '',
    required this.email,
    required this.password,
    required this.role,
  });
}
