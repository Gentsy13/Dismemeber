class MemeResult {
  final String id;
  final String name;
  final String description;
  final String origin;
  final String year;
  final String viralContext;
  final List<String> variations;
  final List<String> relatedMemes;
  final String? imageUrl;
  final String category; // 'image' or 'audio'

  const MemeResult({
    required this.id,
    required this.name,
    required this.description,
    required this.origin,
    required this.year,
    required this.viralContext,
    required this.variations,
    required this.relatedMemes,
    this.imageUrl,
    required this.category,
  });

  factory MemeResult.fromJson(Map<String, dynamic> json) {
    return MemeResult(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      origin: json['origin'] as String,
      year: json['year'] as String,
      viralContext: json['viral_context'] as String,
      variations: List<String>.from(json['variations'] as List),
      relatedMemes: List<String>.from(json['related_memes'] as List),
      imageUrl: json['image_url'] as String?,
      category: json['category'] as String,
    );
  }
}
