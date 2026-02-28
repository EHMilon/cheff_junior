import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // 1. Private Constructor
  LocalStorageService._internal();

  // 2. The single instance
  static final LocalStorageService instance = LocalStorageService._internal();

  // 3. Cached SharedPreferences instance
  late SharedPreferences _prefs;

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

  // --- GETTERS (Synchronous now because _prefs is pre-loaded!) ---

  String? getRole() => _prefs.getString(_kRole);
  String? getAuthRole() => _prefs.getString(_kAuthRole);
  String getEmail() => _prefs.getString(_kEmail) ?? '';
  String getName() => _prefs.getString(_kName) ?? '';
  int? getUserId() => _prefs.getInt(_kUserId);
  String? getAccessToken() => _prefs.getString(_kAccessToken);
  String? getRefToken() => _prefs.getString(_kRefreshToken);
  String? getSecretKey() => _prefs.getString(_kSecretKey);
  int? getTokenValidity() => _prefs.getInt(_kTokenValidity);

  // --- SETTERS ---

  Future<bool> setRole(String role) => _prefs.setString(_kRole, role);
  Future<bool> setAuthRole(String role) => _prefs.setString(_kAuthRole, role);
  Future<bool> setUserId(int id) => _prefs.setInt(_kUserId, id);
  Future<bool> setAccessToken(String token) => _prefs.setString(_kAccessToken, token);
  Future<bool> setRefToken(String token) => _prefs.setString(_kRefreshToken, token);
  Future<bool> setSecretKey(String key) => _prefs.setString(_kSecretKey, key);
  Future<bool> setTokenValidity(int timestamp) => _prefs.setInt(_kTokenValidity, timestamp);

  // --- ACTIONS ---

  /// Clears only the Auth-related data (Useful for soft logouts)
  Future<void> clearAuthData() async {
    await _prefs.remove(_kAccessToken);
    await _prefs.remove(_kRefreshToken);
    await _prefs.remove(_kTokenValidity);
  }

  /// Completely wipes the local storage
  Future<bool> clearAll() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      return false;
    }
  }
}
