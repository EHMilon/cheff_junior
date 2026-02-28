import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import 'auth_api_client.dart';

/// Service to handle authentication state persistence and API calls
///
/// This service manages:
/// - User login state
/// - User token storage
/// - User data persistence
/// - API authentication calls
class AuthService extends GetxService {
  static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  late SharedPreferences _prefs;
  late AuthApiClient _apiClient;
  
  final _isLoggedIn = false.obs;
  final _isLoading = false.obs;
  final _currentUser = Rxn<UserModel>();

  /// Observable to track login state
  bool get isLoggedIn => _isLoggedIn.value;

  /// Observable to track loading state
  bool get isLoading => _isLoading.value;

  /// Get current user
  UserModel? get currentUser => _currentUser.value;

  /// Initialize the service and load stored auth state
  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _apiClient = AuthApiClient();
    _isLoggedIn.value = _prefs.getBool(_isLoggedInKey) ?? false;
    
    // Restore token to API client
    final token = _prefs.getString(_tokenKey);
    if (token != null && token.isNotEmpty) {
      _apiClient.setAccessToken(token);
    }
    
    return this;
  }

  /// Sign up a new user
  ///
  /// [email] - User's email address
  /// [password] - User's password
  /// [fullName] - User's full name
  /// Returns the result of the API call
  Future<ApiResult<UserModel>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading.value = true;
    try {
      final result = await _apiClient.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (result.isSuccess && result.data != null) {
        _currentUser.value = result.data;
      }
      
      return result;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Login with email and password
  ///
  /// [email] - User's email address
  /// [password] - User's password
  /// Returns the result of the API call
  Future<ApiResult<String>> login({
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    try {
      final result = await _apiClient.login(
        email: email,
        password: password,
      );

      if (result.isSuccess && result.data != null) {
        // Save auth data after successful login
        await saveAuthData(
          token: result.data!,
          user: UserModel(
            id: '', // Will be fetched from profile API
            name: email.split('@').first,
            email: email,
          ),
        );
      }
      
      return result;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Request password reset OTP
  ///
  /// [email] - User's email address
  Future<ApiResult<String>> forgotPassword({required String email}) async {
    _isLoading.value = true;
    try {
      return await _apiClient.forgotPassword(email: email);
    } finally {
      _isLoading.value = false;
    }
  }

  /// Verify OTP sent to user's email
  ///
  /// [email] - User's email address
  /// [otp] - One-time password received
  Future<ApiResult<String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    _isLoading.value = true;
    try {
      return await _apiClient.verifyOtp(email: email, otp: otp);
    } finally {
      _isLoading.value = false;
    }
  }

  /// Reset password with OTP
  ///
  /// [email] - User's email address
  /// [otp] - One-time password received
  /// [newPassword] - New password to set
  Future<ApiResult<String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    _isLoading.value = true;
    try {
      return await _apiClient.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
        confirmPassword: newPassword,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Resend OTP to user's email
  ///
  /// [email] - User's email address
  Future<ApiResult<String>> resendOtp({required String email}) async {
    _isLoading.value = true;
    try {
      return await _apiClient.resendOtp(email: email);
    } finally {
      _isLoading.value = false;
    }
  }

  /// Logout the current user
  Future<ApiResult<String>> logout() async {
    _isLoading.value = true;
    try {
      final result = await _apiClient.logout();
      
      // Clear local auth data regardless of API result
      await clearAuthData();
      
      return result;
    } finally {
      _isLoading.value = false;
    }
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
    _apiClient.setAccessToken(token);
    _isLoggedIn.value = true;
    _currentUser.value = user;
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

  /// Get API client instance
  AuthApiClient get apiClient => _apiClient;

  /// Clear all authentication data on logout
  Future<void> clearAuthData() async {
    await Future.wait([
      _prefs.remove(_tokenKey),
      _prefs.remove(_isLoggedInKey),
      _prefs.remove(_userIdKey),
      _prefs.remove(_userEmailKey),
      _prefs.remove(_userNameKey),
    ]);
    _apiClient.setAccessToken(null);
    _isLoggedIn.value = false;
    _currentUser.value = null;
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

  /// Update current user data
  void updateCurrentUser(UserModel user) {
    _currentUser.value = user;
    _prefs.setString(_userIdKey, user.id);
    _prefs.setString(_userEmailKey, user.email);
    _prefs.setString(_userNameKey, user.name);
  }

  @override
  void onClose() {
    _apiClient.dispose();
    super.onClose();
  }
}
