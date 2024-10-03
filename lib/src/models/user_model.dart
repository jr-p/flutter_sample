class User {
  final int id;
  final String email;
  final String phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.phoneNumber,
  });

  // JSONからUserインスタンスを作成するファクトリーメソッド
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phone_number'],
    );
  }

  // UserインスタンスをJSONに変換するメソッド
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
    };
  }
}