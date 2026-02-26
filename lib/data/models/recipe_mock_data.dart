import 'recipe_model.dart';

/// Mock data provider for recipe API responses.
/// This data mimics the backend API structure for easy integration.
/// TODO: Replace with actual API calls when backend is ready
class RecipeMockData {
  /// Get all recipes (simulates GET /api/recipes)
  static List<Recipe> getRecipes() {
    return [
      Recipe.fromJson(_recipeJson(1)),
      Recipe.fromJson(_recipeJson(2)),
      Recipe.fromJson(_recipeJson(3)),
    ];
  }

  /// Get favorite recipes (simulates GET /api/recipes/favorites)
  static List<Recipe> getFavoriteRecipes() {
    return [
      Recipe.fromJson(_recipeJson(1, isFavorite: true)),
      Recipe.fromJson(_recipeJson(2, isFavorite: true)),
    ];
  }

  /// Get recipe by ID (simulates GET /api/recipes/{id})
  static Recipe? getRecipeById(String id) {
    final index = int.tryParse(id);
    if (index != null && index >= 1 && index <= 3) {
      return Recipe.fromJson(_recipeJson(index));
    }
    return null;
  }

  /// Search recipes by query (simulates GET /api/recipes?q=...)
  static List<Recipe> searchRecipes(String query) {
    return getRecipes()
        .where(
          (recipe) =>
              recipe.title.toLowerCase().contains(query.toLowerCase()) ||
              recipe.category.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Get recipes by category (simulates GET /api/recipes?category=...)
  static List<Recipe> getRecipesByCategory(String category) {
    return getRecipes()
        .where(
          (recipe) => recipe.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }

  /// Simulated API response format - this is how backend data should look
  static Map<String, dynamic> _recipeJson(int id, {bool isFavorite = false}) {
    return {
      'id': id.toString(),
      'title': id == 1 ? 'Italian Chicken Pizza' : 'Chicken Pizza',
      'description': id == 1
          ? 'Traditional Italian pizza did not originally include chicken. Classic Italian pizzas focused on simple ingredients like dough, tomato, olive oil, and cheese.'
          : 'Traditional Italian pizza made by native Italians and with some delicious toppings that will make you want more.',
      'image_url': _getImageUrl(id),
      'video_url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'difficulty': _getDifficulty(id),
      'time_in_minutes': 30,
      'category': 'Fast food',
      'servings': 2,
      'is_favorite': isFavorite,
      'created_at': '2024-01-15T10:30:00Z',
      'updated_at': '2024-01-20T14:45:00Z',
      'rating': 5.0,
      'reviews_count': 5,
      'views_count': 78000,
      'likes_count': 4500,
      'dislikes_count': 30000,
      'posted_time': '3months ago',
      'ingredients': [
        {'name': 'Pizza dough', 'amount': '200gm', 'icon': '🍞'},
        {'name': 'Tomato sauce', 'amount': '200gm', 'icon': '🥫'},
        {'name': 'Mozzarella cheese', 'amount': '200gm', 'icon': '🧀'},
        {'name': 'Grilled or roasted chicken', 'amount': '200gm', 'icon': '🍗'},
        {'name': 'Bell peppers', 'amount': '200gm', 'icon': '🫑'},
        {'name': 'Onions', 'amount': '200gm', 'icon': '🧅'},
        {'name': 'Mushrooms', 'amount': '50gm', 'icon': '🍄'},
        {'name': 'Olives', 'amount': '200gm', 'icon': '🫒'},
        {'name': 'Italian herbs', 'amount': '200gm', 'icon': '🌿'},
        {'name': 'Garlic', 'amount': '200gm', 'icon': '🧄'},
      ],
      'steps': [
        {'step': 1, 'instruction': 'Preheat oven to 200°C'},
        {'step': 2, 'instruction': 'Spread tomato sauce on pizza base'},
        {'step': 3, 'instruction': 'Add chicken and cheese'},
        {'step': 4, 'instruction': 'Bake for 15-20 minutes'},
      ],
    };
  }

  static String _getImageUrl(int id) {
    switch (id) {
      case 1:
        return 'assets/images/recipe-k_IgsitMBS0.jpg';
      case 2:
        return 'assets/images/recipe-w1RkpMjM5Fc.jpg';
      case 3:
        return 'assets/images/recipe-drd0LG_kYE8.jpg';
      default:
        return 'assets/images/recipe-k_IgsitMBS0.jpg';
    }
  }

  static String _getDifficulty(int id) {
    switch (id) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      default:
        return 'Medium';
    }
  }
}

/// API Response wrapper for backend compatibility
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? totalCount;
  final int? page;
  final int? pageSize;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.totalCount,
    this.page,
    this.pageSize,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'],
      totalCount: json['total_count'],
      page: json['page'],
      pageSize: json['page_size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'total_count': totalCount,
      'page': page,
      'page_size': pageSize,
    };
  }
}

/// Example API response structure for reference:
/*
{
  "success": true,
  "message": "Recipes fetched successfully",
  "data": [
    {
      "id": "1",
      "title": "Chicken Pizza",
      "description": "...",
      "image_url": "assets/images/recipe-k_IgsitMBS0.jpg",
      "difficulty": "Easy",
      "time_in_minutes": 30,
      "category": "Fast food",
      "servings": 2,
      "is_favorite": false,
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-20T14:45:00Z",
      "rating": 4.5,
      "reviews_count": 120,
      "ingredients": [
        {"name": "Chicken", "amount": "200g"}
      ],
      "steps": [
        {"step": 1, "instruction": "Preheat oven to 200°C"}
      ]
    }
  ],
  "total_count": 10,
  "page": 1,
  "page_size": 10
}
*/
