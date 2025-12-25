class User {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? profileImage;
  final List<String> skills;
  final List<String> interests;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.profileImage,
    this.skills = const [],
    this.interests = const [],
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
      profileImage: json['profileImage'],
      skills: List<String>.from(json['skills'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImage': profileImage,
      'skills': skills,
      'interests': interests,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}