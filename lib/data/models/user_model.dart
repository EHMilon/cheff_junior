/// User model representing user data from the API
class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePhoto;
  final String joinedDate;
  final int gamesPlayed;
  final int recipesCompleted;
  final bool isActive;
  final bool isSuperuser;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePhoto = '',
    this.joinedDate = '',
    this.gamesPlayed = 0,
    this.recipesCompleted = 0,
    this.isActive = true,
    this.isSuperuser = false,
  });

  /// Factory constructor to create UserModel from API JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['full_name'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      profilePhoto: json['profile_photo'] ?? json['profilePhoto'] ?? '',
      joinedDate: json['joined_date'] ?? json['joinedDate'] ?? '',
      gamesPlayed: json['games_played'] ?? json['gamesPlayed'] ?? 0,
      recipesCompleted: json['recipes_tried'] ?? json['recipes_completed'] ?? 0,
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      isSuperuser: json['is_superuser'] ?? json['isSuperuser'] ?? false,
    );
  }

  /// Convert UserModel to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'email': email,
      'profile_photo': profilePhoto,
      'joined_date': joinedDate,
      'games_played': gamesPlayed,
      'recipes_tried': recipesCompleted,
      'is_active': isActive,
      'is_superuser': isSuperuser,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? profilePhoto,
    int? gamesPlayed,
    int? recipesCompleted,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      joinedDate: joinedDate,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      recipesCompleted: recipesCompleted ?? this.recipesCompleted,
      isActive: isActive,
      isSuperuser: isSuperuser,
    );
  }
}
