
// A simple data model for a User. In a real app, this would be more complex.
class User {
  final String id;
  final String email;
  String hashedPassword; // For mock service only
  final String? name;
  final String? accountName;
  final String? phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.hashedPassword,
    this.name,
    this.accountName,
    this.phoneNumber,
  });

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}
