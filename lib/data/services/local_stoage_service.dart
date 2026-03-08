import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // 1. Private Constructor
  LocalStorageService._internal();

  // 2. The single instance
  static final LocalStorageService instance = LocalStorageService._internal();

  // 3. Cached SharedPreferences instance
  SharedPreferences? _prefs;

  // Check if initialized
  bool get isInitialized => _prefs != null;

  // 4. Initialization - Call this in your main.dart:
  // await LocalStorageService.instance.init();
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 5. Constants for Keys (Prevents "fat-finger" typos)
  static const _kRole = 'selected_role';
  static const _kAuthRole = 'role';
  static const _kEmail = 'email';
  static const _kName = 'name';
  static const _kUserId = 'user_id';
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kSecretKey = 'secret_key';
  static const _kTokenValidity = 'access_token_valid_till';

  // Game progress keys
  static const _kCrosswordProgress = 'crossword_progress'; // 0-3 completed games
  static const _kWordSearchProgress = 'word_search_progress'; // 0-1 completed games
  static const _kGamesPlayed = 'games_played'; // Total games played count

  // --- GETTERS (Synchronous now because _prefs is pre-loaded!) ---

  String? getRole() => _prefs?.getString(_kRole);
  String? getAuthRole() => _prefs?.getString(_kAuthRole);
  String getEmail() => _prefs?.getString(_kEmail) ?? '';
  String getName() => _prefs?.getString(_kName) ?? '';
  int? getUserId() => _prefs?.getInt(_kUserId);
  String? getAccessToken() => _prefs?.getString(_kAccessToken);
  String? getRefToken() => _prefs?.getString(_kRefreshToken);
  String? getSecretKey() => _prefs?.getString(_kSecretKey);
  int? getTokenValidity() => _prefs?.getInt(_kTokenValidity);

  // --- SETTERS ---

  Future<bool> setRole(String role) async => _prefs?.setString(_kRole, role) ?? false;
  Future<bool> setAuthRole(String role) async => _prefs?.setString(_kAuthRole, role) ?? false;
  Future<bool> setUserId(int id) async => _prefs?.setInt(_kUserId, id) ?? false;
  Future<bool> setAccessToken(String token) async => _prefs?.setString(_kAccessToken, token) ?? false;
  Future<bool> setRefToken(String token) async => _prefs?.setString(_kRefreshToken, token) ?? false;
  Future<bool> setSecretKey(String key) async => _prefs?.setString(_kSecretKey, key) ?? false;
  Future<bool> setTokenValidity(int timestamp) async => _prefs?.setInt(_kTokenValidity, timestamp) ?? false;

  // --- ACTIONS ---

  /// Clears only the Auth-related data (Useful for soft logouts)
  Future<void> clearAuthData() async {
    await _prefs?.remove(_kAccessToken);
    await _prefs?.remove(_kRefreshToken);
    await _prefs?.remove(_kTokenValidity);
  }

  /// Completely wipes the local storage
  Future<bool> clearAll() async {
    try {
      return await _prefs?.clear() ?? false;
    } catch (e) {
      return false;
    }
  }

  // --- GAME PROGRESS METHODS ---

  /// Get crossword progress (0-3 completed games)
  int getCrosswordProgress() => _prefs?.getInt(_kCrosswordProgress) ?? 0;

  /// Set crossword progress (0-3 completed games)
  Future<bool> setCrosswordProgress(int progress) async => _prefs?.setInt(_kCrosswordProgress, progress) ?? false;

  /// Get word search progress (0-1 completed games)
  int getWordSearchProgress() => _prefs?.getInt(_kWordSearchProgress) ?? 0;

  /// Set word search progress (0-1 completed games)
  Future<bool> setWordSearchProgress(int progress) async => _prefs?.setInt(_kWordSearchProgress, progress) ?? false;

  /// Reset all game progress
  Future<void> resetGameProgress() async {
    await _prefs?.remove(_kCrosswordProgress);
    await _prefs?.remove(_kWordSearchProgress);
    await _prefs?.remove(_kGamesPlayed);
  }

  // --- GAMES PLAYED STATS ---

  /// Get total games played count
  int getGamesPlayed() => _prefs?.getInt(_kGamesPlayed) ?? 0;

  /// Increment games played count by 1 (called when a game is completed)
  Future<bool> incrementGamesPlayed() async {
    final currentCount = getGamesPlayed();
    return _prefs?.setInt(_kGamesPlayed, currentCount + 1) ?? false;
  }

  /// Set games played count (for resetting if needed)
  Future<bool> setGamesPlayed(int count) async => _prefs?.setInt(_kGamesPlayed, count) ?? false;
}
