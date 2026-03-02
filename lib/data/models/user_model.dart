/// User model representing user data from the API
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? address;
  final String joinedDate;
  final int gamesPlayed;
  final int recipesCompleted;
  final int gamesWonCount;
  final int recipesCompletedCount;
  final bool isActive;
  final bool isSuperuser;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phoneNumber,
    this.address,
    this.joinedDate = '',
    this.gamesPlayed = 0,
    this.recipesCompleted = 0,
    this.gamesWonCount = 0,
    this.recipesCompletedCount = 0,
    this.isActive = true,
    this.isSuperuser = false,
  });

  /// Factory constructor to create UserModel from API JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['full_name'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      joinedDate:
          json['joined_at'] ?? json['joined_date'] ?? json['joinedDate'] ?? '',
      gamesPlayed: json['games_played'] ?? json['gamesPlayed'] ?? 0,
      recipesCompleted:
          json['recipes_tried'] ??
          json['recipes_completed'] ??
          json['recipesCompleted'] ??
          0,
      gamesWonCount: json['games_won_count'] ?? json['gamesWonCount'] ?? 0,
      recipesCompletedCount:
          json['recipes_completed_count'] ?? json['recipesCompletedCount'] ?? 0,
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
      'avatar_url': avatarUrl,
      'phone_number': phoneNumber,
      'address': address,
      'joined_at': joinedDate,
      'games_played': gamesPlayed,
      'recipes_tried': recipesCompleted,
      'games_won_count': gamesWonCount,
      'recipes_completed_count': recipesCompletedCount,
      'is_active': isActive,
      'is_superuser': isSuperuser,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? phoneNumber,
    String? address,
    int? gamesPlayed,
    int? recipesCompleted,
    int? gamesWonCount,
    int? recipesCompletedCount,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      joinedDate: joinedDate,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      recipesCompleted: recipesCompleted ?? this.recipesCompleted,
      gamesWonCount: gamesWonCount ?? this.gamesWonCount,
      recipesCompletedCount:
          recipesCompletedCount ?? this.recipesCompletedCount,
      isActive: isActive,
      isSuperuser: isSuperuser,
    );
  }
}
