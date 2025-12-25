class Founder {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String? profileImage;
  final List<String> startupIds;
  final List<String> skills;
  final List<String> interests;
  final bool isConnected;
  final bool isConnectionPending;
  final bool isSaved;
  final DateTime joinedDate;

  Founder({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.profileImage,
    this.startupIds = const [],
    this.skills = const [],
    this.interests = const [],
    this.isConnected = false,
    this.isConnectionPending = false,
    this.isSaved = false,
    required this.joinedDate,
  });

  factory Founder.fromJson(Map<String, dynamic> json) {
    return Founder(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
      profileImage: json['profileImage'],
      startupIds: List<String>.from(json['startupIds'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      isConnected: json['isConnected'] ?? false,
      isConnectionPending: json['isConnectionPending'] ?? false,
      isSaved: json['isSaved'] ?? false,
      joinedDate: DateTime.parse(json['joinedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImage': profileImage,
      'startupIds': startupIds,
      'skills': skills,
      'interests': interests,
      'isConnected': isConnected,
      'isConnectionPending': isConnectionPending,
      'isSaved': isSaved,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }

  Founder copyWith({
    bool? isConnected,
    bool? isConnectionPending,
    bool? isSaved,
  }) {
    return Founder(
      id: id,
      name: name,
      email: email,
      bio: bio,
      profileImage: profileImage,
      startupIds: startupIds,
      skills: skills,
      interests: interests,
      isConnected: isConnected ?? this.isConnected,
      isConnectionPending: isConnectionPending ?? this.isConnectionPending,
      isSaved: isSaved ?? this.isSaved,
      joinedDate: joinedDate,
    );
  }
}