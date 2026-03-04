/// Model for Explore Recipe API Response
/// Endpoint: GET $baseUrl/recipes/explore
///
/// Response format:
/// [
///   {
///     "id": 3,
///     "title": "Spicy Chicken Pizza",
///     "description": "A delicious spicy chicken pizza with melted cheese",
///     "difficulty": "Medium",
///     "cooking_time": "45 min",
///     "category": "Fast Food",
///     "servings": 4,
///     "image_url": "https://example.com/pizza.jpg",
///     "is_favorite": false,
///     "favorites_count": 0
///   }
/// ]
class ExploreRecipe {
  final int id;
  final String title;
  final String description;
  final String difficulty;
  final String cookingTime;
  final String category;
  final int servings;
  final String imageUrl;
  final bool isFavorite;
  final int favoritesCount;

  ExploreRecipe({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.cookingTime,
    required this.category,
    required this.servings,
    required this.imageUrl,
    required this.isFavorite,
    required this.favoritesCount,
  });

  /// Create ExploreRecipe from JSON (backend API response)
  factory ExploreRecipe.fromJson(Map<String, dynamic> json) {
    return ExploreRecipe(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? 'Medium',
      cookingTime: json['cooking_time'] ?? '0 min',
      category: json['category'] ?? 'General',
      servings: json['servings'] ?? 9,
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
      'description': description,
      'difficulty': difficulty,
      'cooking_time': cookingTime,
      'category': category,
      'servings': servings,
      'image_url': imageUrl,
      'is_favorite': isFavorite,
      'favorites_count': favoritesCount,
    };
  }

  /// Create a copy of this recipe with updated fields
  ExploreRecipe copyWith({
    int? id,
    String? title,
    String? description,
    String? difficulty,
    String? cookingTime,
    String? category,
    int? servings,
    String? imageUrl,
    bool? isFavorite,
    int? favoritesCount,
  }) {
    return ExploreRecipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      cookingTime: cookingTime ?? this.cookingTime,
      category: category ?? this.category,
      servings: servings ?? this.servings,
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
