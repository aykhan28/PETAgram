class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String photoURL;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoURL,
  });

  /// Firestore'dan veri çevirme
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      photoURL: data['photoURL'] ?? '',
    );
  }

  /// Firestore'a veri kaydetme
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photoURL': photoURL,
    };
  }
}