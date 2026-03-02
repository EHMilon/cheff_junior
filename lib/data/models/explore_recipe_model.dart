/// Model for Explore Recipe API Response
/// Endpoint: GET $baseUrl/recipes/explore
///
/// Response format:
/// [
///   {
///     "id": 3,
///     "title": "Spicy Chicken Pizza",
///     "difficulty": "Medium",
///     "cooking_time": "45 min",
///     "category": "Fast Food",
///     "image_url": "https://example.com/pizza.jpg",
///     "is_favorite": false,
///     "favorites_count": 0
///   }
/// ]
class ExploreRecipe {
  final int id;
  final String title;
  final String difficulty;
  final String cookingTime;
  final String category;
  final String imageUrl;
  final bool isFavorite;
  final int favoritesCount;

  ExploreRecipe({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.cookingTime,
    required this.category,
    required this.imageUrl,
    required this.isFavorite,
    required this.favoritesCount,
  });

  /// Create ExploreRecipe from JSON (backend API response)
  factory ExploreRecipe.fromJson(Map<String, dynamic> json) {
    return ExploreRecipe(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      difficulty: json['difficulty'] ?? 'Medium',
      cookingTime: json['cooking_time'] ?? '0 min',
      category: json['category'] ?? 'General',
      imageUrl: json['image_url'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      favoritesCount: json['favorites_count'] ?? 0,
    );
  }

  /// Convert ExploreRecipe to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'difficulty': difficulty,
      'cooking_time': cookingTime,
      'category': category,
      'image_url': imageUrl,
      'is_favorite': isFavorite,
      'favorites_count': favoritesCount,
    };
  }

  /// Create a copy of this recipe with updated fields
  ExploreRecipe copyWith({
    int? id,
    String? title,
    String? difficulty,
    String? cookingTime,
    String? category,
    String? imageUrl,
    bool? isFavorite,
    int? favoritesCount,
  }) {
    return ExploreRecipe(
      id: id ?? this.id,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      cookingTime: cookingTime ?? this.cookingTime,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      favoritesCount: favoritesCount ?? this.favoritesCount,
    );
  }

  @override
  String toString() {
    return 'ExploreRecipe(id: $id, title: $title, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExploreRecipe && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
