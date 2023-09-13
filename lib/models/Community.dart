class Community {
  final String banner;
  final String description;
  final String name;
  Community({
    required this.banner,
    required this.description,
    required this.name,
  });

  Community copyWith({
    String? banner,
    String? description,
    String? name,
  }) {
    return Community(
      banner: banner ?? this.banner,
      description: description ?? this.description,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'banner': banner,
      'description': description,
      'name': name,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      banner: map['banner'] as String,
      description: map['description'] as String,
      name: map['name'] as String,
    );
  }

  @override
  String toString() =>
      'Community(banner: $banner, description: $description, name: $name)';

  @override
  bool operator ==(covariant Community other) {
    if (identical(this, other)) return true;

    return other.banner == banner &&
        other.description == description &&
        other.name == name;
  }

  @override
  int get hashCode => banner.hashCode ^ description.hashCode ^ name.hashCode;
}
