class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? videoUrl;
  final String difficulty; // Easy, Medium, Hard
  final int timeInMinutes;
  final String category;
  final int servings;
  final bool isFavorite;
  final double? rating;
  final int? reviewsCount;
  final int? viewsCount;
  final int? likesCount;
  final int? dislikesCount;
  final String? postedTime;
  final String? createdAt;
  final String? updatedAt;
  final List<RecipeIngredient>? ingredients;
  final List<RecipeStep>? steps;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.videoUrl,
    required this.difficulty,
    required this.timeInMinutes,
    required this.category,
    required this.servings,
    this.isFavorite = false,
    this.rating,
    this.reviewsCount,
    this.viewsCount,
    this.likesCount,
    this.dislikesCount,
    this.postedTime,
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
      videoUrl: json['video_url'] ?? json['videoUrl'],
      difficulty: json['difficulty'] ?? 'Medium',
      timeInMinutes: json['time_in_minutes'] ?? json['timeInMinutes'] ?? 0,
      category: json['category'] ?? '',
      servings: json['servings'] ?? 1,
      isFavorite: json['is_favorite'] ?? json['isFavorite'] ?? false,
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      reviewsCount: json['reviews_count'] ?? json['reviewsCount'],
      viewsCount: json['views_count'] ?? json['viewsCount'],
      likesCount: json['likes_count'] ?? json['likesCount'],
      dislikesCount: json['dislikes_count'] ?? json['dislikesCount'],
      postedTime: json['posted_time'] ?? json['postedTime'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
                .map((e) => RecipeIngredient.fromJson(e))
                .toList()
          : null,
      steps: json['steps'] != null
          ? (json['steps'] as List).map((e) => RecipeStep.fromJson(e)).toList()
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
      'video_url': videoUrl,
      'difficulty': difficulty,
      'time_in_minutes': timeInMinutes,
      'category': category,
      'servings': servings,
      'is_favorite': isFavorite,
      'rating': rating,
      'reviews_count': reviewsCount,
      'views_count': viewsCount,
      'likes_count': likesCount,
      'dislikes_count': dislikesCount,
      'posted_time': postedTime,
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
    String? videoUrl,
    String? difficulty,
    int? timeInMinutes,
    String? category,
    int? servings,
    bool? isFavorite,
    double? rating,
    int? reviewsCount,
    int? viewsCount,
    int? likesCount,
    int? dislikesCount,
    String? postedTime,
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
      videoUrl: videoUrl ?? this.videoUrl,
      difficulty: difficulty ?? this.difficulty,
      timeInMinutes: timeInMinutes ?? this.timeInMinutes,
      category: category ?? this.category,
      servings: servings ?? this.servings,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      viewsCount: viewsCount ?? this.viewsCount,
      likesCount: likesCount ?? this.likesCount,
      dislikesCount: dislikesCount ?? this.dislikesCount,
      postedTime: postedTime ?? this.postedTime,
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
  final String? icon;

  RecipeIngredient({required this.name, required this.amount, this.icon});

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      name: json['name'] ?? '',
      amount: json['amount'] ?? '',
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'amount': amount, 'icon': icon};
  }
}

/// Recipe step model
class RecipeStep {
  final int step;
  final String instruction;

  RecipeStep({required this.step, required this.instruction});

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      step: json['step'] ?? 0,
      instruction: json['instruction'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'step': step, 'instruction': instruction};
  }
}
