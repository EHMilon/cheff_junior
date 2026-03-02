/// API Constants for the application
/// Base URL for all API requests
class ApiConstants {
  ApiConstants._();

  /// Base URL for the API v1
  static const String baseUrl = 'https://327f-103-159-73-161.ngrok-free.app/api/v1';

  /// API Endpoints
  static const String auth = '/auth';

  /// Full URLs
  static const String login = '$baseUrl$auth/login';
  static const String signup = '$baseUrl$auth/signup';
  static const String forgotPassword = '$baseUrl$auth/forgot-password';
  static const String resetPassword = '$baseUrl$auth/reset-password';
  static const String verifyOtp = '$baseUrl$auth/verify-otp';
  static const String resendOtp = '$baseUrl$auth/resend-otp';
  static const String logout = '$baseUrl$auth/logout';

  /// Recipe API Endpoints
  static const String recipes = '$baseUrl/recipes';
  static String recipeById(String id) => '$baseUrl/recipes/$id';
  

  static const String me = '$baseUrl/users/me';
  static const String recipeExplore = '$baseUrl/recipes/explore';
  static const String search = '$baseUrl/recipes/search';
  
}
