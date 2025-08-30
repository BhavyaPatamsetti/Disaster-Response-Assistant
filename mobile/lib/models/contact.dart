class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? avatar;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'avatar': avatar,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}