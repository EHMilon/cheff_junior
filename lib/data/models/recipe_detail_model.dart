/// Model for Recipe Detail API Response
/// Endpoint: GET $baseUrl/recipes/{id}
///
/// Response format:
/// {
///   "title": "Spicy Chicken Pizza",
///   "description": "A delicious homemade pizza with spicy chicken toppings.",
///   "difficulty": "Medium",
///   "category": "Fast Food",
///   "cooking_time": "45 min",
///   "servings": 4,
///   "image_url": "https://example.com/pizza.jpg",
///   "video_url": "https://www.youtube.com/watch?v=123456",
///   "id": 3,
///   "ingredients": [
///     {
///       "name": "Tomato",
///       "origin": "asd",
///       "type": "vegetable",
///       "history": "sad",
///       "fun_facts": "asd",
///       "image_url": "/uploads/ce44a384-ec04-47cf-a15c-19de43077521.jpg",
///       "protein": "1",
///       "carbohydrates": "1",
///       "others": "2",
///       "id": 1,
///       "quantity": "250gm"
///     }
///   ],
///   "is_favorite": false,
///   "views_count": 2,
///   "favorites_count": 0,
///   "average_rating": 4.5,
///   "total_reviews": 10
/// }
class RecipeDetail {
  final int id;
  final String title;
  final String description;
  final String difficulty;
  final String category;
  final String cookingTime;
  final int servings;
  final String imageUrl;
  final String? videoUrl;
  final List<RecipeDetailIngredient> ingredients;
  final bool isFavorite;
  final int viewsCount;
  final int favoritesCount;
  final double averageRating;
  final int totalReviews;

  RecipeDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.category,
    required this.cookingTime,
    required this.servings,
    required this.imageUrl,
    this.videoUrl,
    required this.ingredients,
    required this.isFavorite,
    required this.viewsCount,
    required this.favoritesCount,
    this.averageRating = 0.0,
    this.totalReviews = 0,
  });

  /// Create RecipeDetail from JSON (backend API response)
  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? 'Medium',
      category: json['category'] ?? 'General',
      cookingTime: json['cooking_time'] ?? '0 min',
      servings: json['servings'] ?? 1,
      imageUrl: json['image_url'] ?? '',
      videoUrl: json['video_url'],
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
                .map(
                  (e) => RecipeDetailIngredient.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : [],
      isFavorite: json['is_favorite'] ?? false,
      viewsCount: json['views_count'] ?? 0,
      favoritesCount: json['favorites_count'] ?? 0,
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
    );
  }

  /// Convert RecipeDetail to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'category': category,
      'cooking_time': cookingTime,
      'servings': servings,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'is_favorite': isFavorite,
      'views_count': viewsCount,
      'favorites_count': favoritesCount,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
    };
  }

  /// Create a copy of this recipe with updated fields
  RecipeDetail copyWith({
    int? id,
    String? title,
    String? description,
    String? difficulty,
    String? category,
    String? cookingTime,
    int? servings,
    String? imageUrl,
    String? videoUrl,
    List<RecipeDetailIngredient>? ingredients,
    bool? isFavorite,
    int? viewsCount,
    int? favoritesCount,
    double? averageRating,
    int? totalReviews,
  }) {
    return RecipeDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      cookingTime: cookingTime ?? this.cookingTime,
      servings: servings ?? this.servings,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      ingredients: ingredients ?? this.ingredients,
      isFavorite: isFavorite ?? this.isFavorite,
      viewsCount: viewsCount ?? this.viewsCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }

  @override
  String toString() {
    return 'RecipeDetail(id: $id, title: $title, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecipeDetail && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Ingredient model for Recipe Detail
class RecipeDetailIngredient {
  final int id;
  final String name;
  final String? origin;
  final String? type;
  final String? history;
  final String? funFacts;
  final String? imageUrl;
  final String? protein;
  final String? carbohydrates;
  final String? fats;
  final String? others;
  final String quantity;
  final String? amount; // Alternative field name for quantity
  final String? icon; // Emoji icon for the ingredient

  RecipeDetailIngredient({
    required this.id,
    required this.name,
    this.origin,
    this.type,
    this.history,
    this.funFacts,
    this.imageUrl,
    this.protein,
    this.carbohydrates,
    this.fats,
    this.others,
    required this.quantity,
    this.amount,
    this.icon,
  });

  /// Create RecipeDetailIngredient from JSON
  factory RecipeDetailIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeDetailIngredient(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      origin: json['origin'],
      type: json['type'],
      history: json['history'],
      funFacts: json['fun_facts'],
      imageUrl: json['image_url'],
      protein: json['protein']?.toString(),
      carbohydrates: json['carbohydrates']?.toString(),
      fats: json['fats']?.toString(),
      others: json['others']?.toString(),
      quantity: json['quantity'] ?? '',
      amount: json['amount']?.toString() ?? json['quantity']?.toString(),
      icon: json['icon'],
    );
  }

  /// Convert RecipeDetailIngredient to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'type': type,
      'history': history,
      'fun_facts': funFacts,
      'image_url': imageUrl,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fats': fats,
      'others': others,
      'quantity': quantity,
      'amount': amount,
      'icon': icon,
    };
  }

  @override
  String toString() {
    return 'RecipeDetailIngredient(id: $id, name: $name, quantity: $quantity)';
  }
}
