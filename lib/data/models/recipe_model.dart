class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String difficulty; // Easy, Medium, Hard
  final int timeInMinutes;
  final String category;
  final int servings;
  final bool isFavorite;
  final double? rating;
  final int? reviewsCount;
  final String? createdAt;
  final String? updatedAt;
  final List<RecipeIngredient>? ingredients;
  final List<RecipeStep>? steps;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.difficulty,
    required this.timeInMinutes,
    required this.category,
    required this.servings,
    this.isFavorite = false,
    this.rating,
    this.reviewsCount,
    this.createdAt,
    this.updatedAt,
    this.ingredients,
    this.steps,
  });

  /// Create Recipe from JSON (backend API response)
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      difficulty: json['difficulty'] ?? 'Medium',
      timeInMinutes: json['time_in_minutes'] ?? json['timeInMinutes'] ?? 0,
      category: json['category'] ?? '',
      servings: json['servings'] ?? 1,
      isFavorite: json['is_favorite'] ?? json['isFavorite'] ?? false,
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      reviewsCount: json['reviews_count'] ?? json['reviewsCount'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
              .map((e) => RecipeIngredient.fromJson(e))
              .toList()
          : null,
      steps: json['steps'] != null
          ? (json['steps'] as List)
              .map((e) => RecipeStep.fromJson(e))
              .toList()
          : null,
    );
  }

  /// Convert Recipe to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'difficulty': difficulty,
      'time_in_minutes': timeInMinutes,
      'category': category,
      'servings': servings,
      'is_favorite': isFavorite,
      'rating': rating,
      'reviews_count': reviewsCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'ingredients': ingredients?.map((e) => e.toJson()).toList(),
      'steps': steps?.map((e) => e.toJson()).toList(),
    };
  }

  /// Create a copy of this recipe with updated fields
  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? difficulty,
    int? timeInMinutes,
    String? category,
    int? servings,
    bool? isFavorite,
    double? rating,
    int? reviewsCount,
    String? createdAt,
    String? updatedAt,
    List<RecipeIngredient>? ingredients,
    List<RecipeStep>? steps,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      difficulty: difficulty ?? this.difficulty,
      timeInMinutes: timeInMinutes ?? this.timeInMinutes,
      category: category ?? this.category,
      servings: servings ?? this.servings,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recipe && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Recipe ingredient model
class RecipeIngredient {
  final String name;
  final String amount;

  RecipeIngredient({
    required this.name,
    required this.amount,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      name: json['name'] ?? '',
      amount: json['amount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}

/// Recipe step model
class RecipeStep {
  final int step;
  final String instruction;

  RecipeStep({
    required this.step,
    required this.instruction,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      step: json['step'] ?? 0,
      instruction: json['instruction'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'instruction': instruction,
    };
  }
}
