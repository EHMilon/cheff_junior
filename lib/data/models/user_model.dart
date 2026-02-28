class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePhoto;
  final String joinedDate;
  final int gamesPlayed;
  final int recipesCompleted;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePhoto,
    required this.joinedDate,
    required this.gamesPlayed,
    required this.recipesCompleted,
  });

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
    );
  }
}
