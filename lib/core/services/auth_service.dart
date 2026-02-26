import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';

/// Service to handle authentication state persistence using SharedPreferences
///
/// This service manages:
/// - User login state
/// - User token storage
/// - User data persistence
class AuthService extends GetxService {
  static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  late SharedPreferences _prefs;
  final _isLoggedIn = false.obs;

  /// Observable to track login state
  bool get isLoggedIn => _isLoggedIn.value;

  /// Initialize the service and load stored auth state
  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn.value = _prefs.getBool(_isLoggedInKey) ?? false;
    return this;
  }

  /// Save authentication data after successful login
  ///
  /// [token] - Authentication token from backend
  /// [user] - User model containing user information
  Future<void> saveAuthData({
    required String token,
    required UserModel user,
  }) async {
    await Future.wait([
      _prefs.setString(_tokenKey, token),
      _prefs.setBool(_isLoggedInKey, true),
      _prefs.setString(_userIdKey, user.id),
      _prefs.setString(_userEmailKey, user.email),
      _prefs.setString(_userNameKey, user.name),
    ]);
    _isLoggedIn.value = true;
  }

  /// Get stored authentication token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Get stored user ID
  String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  /// Get stored user email
  String? getUserEmail() {
    return _prefs.getString(_userEmailKey);
  }

  /// Get stored user name
  String? getUserName() {
    return _prefs.getString(_userNameKey);
  }

  /// Clear all authentication data on logout
  Future<void> clearAuthData() async {
    await Future.wait([
      _prefs.remove(_tokenKey),
      _prefs.remove(_isLoggedInKey),
      _prefs.remove(_userIdKey),
      _prefs.remove(_userEmailKey),
      _prefs.remove(_userNameKey),
    ]);
    _isLoggedIn.value = false;
  }

  /// Check if user is currently logged in
  ///
  /// Returns true if auth token exists and login flag is set
  bool checkAuthStatus() {
    final token = _prefs.getString(_tokenKey);
    final isLoggedIn = _prefs.getBool(_isLoggedInKey) ?? false;
    _isLoggedIn.value = token != null && token.isNotEmpty && isLoggedIn;
    return _isLoggedIn.value;
  }
}
