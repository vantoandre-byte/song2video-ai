/// Represents a persistent character/entity that must stay visually
/// consistent across every generated scene ("Character Memory").
class CharacterProfile {
  final String id;
  final String name;
  final String description; // face, hair, clothing, build
  final String colorPalette;
  final Map<String, String> attributes; // e.g. {"species": "human", "role": "shepherd"}
  final String referenceImageUrl;

  const CharacterProfile({
    required this.id,
    required this.name,
    required this.description,
    this.colorPalette = '',
    this.attributes = const {},
    this.referenceImageUrl = '',
  });

  /// Produces a short consistency clause to inject into every scene prompt.
  String toPromptClause() {
    final attrs = attributes.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    return '$name ($description${attrs.isNotEmpty ? ", $attrs" : ""}), '
        'consistent character design, identical appearance across all scenes';
  }

  factory CharacterProfile.fromJson(Map<String, dynamic> json) => CharacterProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        colorPalette: json['colorPalette'] as String? ?? '',
        attributes: Map<String, String>.from(json['attributes'] ?? {}),
        referenceImageUrl: json['referenceImageUrl'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'colorPalette': colorPalette,
        'attributes': attributes,
        'referenceImageUrl': referenceImageUrl,
      };
}
