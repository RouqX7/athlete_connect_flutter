class Profile {
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final String phone;
  final String image;
  final bool isAgreed;

  Profile({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phone,
    this.image = "",
    required this.isAgreed,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'phone': phone,
      'image': image,
      'isAgreed': isAgreed,
    };
  }
} 