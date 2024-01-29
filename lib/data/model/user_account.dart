class UserAccount {
  final String name;
  final String email;
  final String role;
  final String uid;
  final String docId;
  final DateTime addedAt;
  final DateTime updatedAt;

  UserAccount({
    required this.name,
    required this.email,
    required this.role,
    required this.uid,
    required this.docId,
    required this.addedAt,
    required this.updatedAt,
  });
}
