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
  });

  // TODO: Add fromJson and toJson methods for backend integration
}
