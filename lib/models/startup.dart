class Startup {
  final String id;
  final String name;
  final String description;
  final String? logo;
  final List<String> founderIds;
  final String category;
  final String stage;
  final DateTime foundedDate;
  final String? website;
  final List<String> tags;
  final bool isSaved;

  Startup({
    required this.id,
    required this.name,
    required this.description,
    this.logo,
    required this.founderIds,
    required this.category,
    required this.stage,
    required this.foundedDate,
    this.website,
    this.tags = const [],
    this.isSaved = false,
  });

  factory Startup.fromJson(Map<String, dynamic> json) {
    return Startup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logo: json['logo'],
      founderIds: List<String>.from(json['founderIds']),
      category: json['category'],
      stage: json['stage'],
      foundedDate: DateTime.parse(json['foundedDate']),
      website: json['website'],
      tags: List<String>.from(json['tags'] ?? []),
      isSaved: json['isSaved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'founderIds': founderIds,
      'category': category,
      'stage': stage,
      'foundedDate': foundedDate.toIso8601String(),
      'website': website,
      'tags': tags,
      'isSaved': isSaved,
    };
  }

  Startup copyWith({bool? isSaved}) {
    return Startup(
      id: id,
      name: name,
      description: description,
      logo: logo,
      founderIds: founderIds,
      category: category,
      stage: stage,
      foundedDate: foundedDate,
      website: website,
      tags: tags,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}