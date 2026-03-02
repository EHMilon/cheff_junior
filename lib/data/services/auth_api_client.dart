import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'api_constant.dart';

/// Result class for API responses
class ApiResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResult.success(this.data) : error = null, isSuccess = true;

  ApiResult.failure(this.error) : data = null, isSuccess = false;
}

/// Auth API Client - handles all authentication-related API calls
class AuthApiClient {
  final http.Client _client;
  String? _accessToken;

  AuthApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Set access token for authenticated requests
  void setAccessToken(String? token) {
    _accessToken = token;
  }

  /// Get current access token
  String? get accessToken => _accessToken;

  /// Common headers for API requests
  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  /// Sign up a new user
  ///
  /// [email] - User's email address
  /// [password] - User's password
  /// [fullName] - User's full name
  Future<ApiResult<UserModel>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.signup),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
          'full_name': fullName,
          'is_superuser': false,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return ApiResult.success(UserModel.fromJson(json));
      } else {
        final error = _parseError(response);
        return ApiResult.failure(error);
      }
    } catch (e) {
      return ApiResult.failure('Signup failed: ${e.toString()}');
    }
  }

  /// Login with email and password
  ///
  /// [email] - User's email address
  /// [password] - User's password
  /// Returns the access token on success
  Future<ApiResult<String>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Use JSON format
      final response = await _client.post(
        Uri.parse(ApiConstants.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['access_token'] as String?;
        if (token != null) {
          _accessToken = token;
          return ApiResult.success(token);
        }
        return ApiResult.failure('Access token not found in response');
      } else {
        final error = _parseError(response);
        return ApiResult.failure(error);
      }
    } catch (e) {
      return ApiResult.failure('Login failed: ${e.toString()}');
    }
  }

  /// Request password reset OTP
  ///
  /// [email] - User's email address
  Future<ApiResult<String>> forgotPassword({required String email}) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.forgotPassword),
        headers: _headers,
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResult.success(json['message'] ?? 'OTP sent successfully');
      } else {
        final error = _parseError(response);
        return ApiResult.failure(error);
      }
    } catch (e) {
      return ApiResult.failure('Forgot password failed: ${e.toString()}');
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
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.verifyOtp),
        headers: _headers,
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResult.success(
          json['message'] ?? 'OTP verified successfully',
        );
      } else {
        final error = _parseError(response);
        return ApiResult.failure(error);
      }
    } catch (e) {
      return ApiResult.failure('OTP verification failed: ${e.toString()}');
    }
  }

  /// Reset password with OTP
  ///
  /// [email] - User's email address
  /// [otp] - One-time password received
  /// [newPassword] - New password to set
  /// [confirmPassword] - Confirmation of new password
  Future<ApiResult<String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.resetPassword),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResult.success(
          json['message'] ?? 'Password reset successfully',
        );
      } else {
        final error = _parseError(response);
        return ApiResult.failure(error);
      }
    } catch (e) {
      return ApiResult.failure('Password reset failed: ${e.toString()}');
    }
  }

  /// Resend OTP to user's email
  ///
  /// [email] - User's email address
  Future<ApiResult<String>> resendOtp({required String email}) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.resendOtp),
        headers: _headers,
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResult.success(json['message'] ?? 'OTP resent successfully');
      } else {
        final error = _parseError(response);
        return ApiResult.failure(error);
      }
    } catch (e) {
      return ApiResult.failure('Resend OTP failed: ${e.toString()}');
    }
  }

  /// Logout the current user
  Future<ApiResult<String>> logout() async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.logout),
        headers: _headers,
      );

      // Clear token regardless of response status
      _accessToken = null;

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResult.success(json['message'] ?? 'Logged out successfully');
      } else {
        final error = _parseError(response);
        return ApiResult.failure(error);
      }
    } catch (e) {
      // Clear token on error
      _accessToken = null;
      return ApiResult.failure('Logout failed: ${e.toString()}');
    }
  }

  /// Get current user profile from /users/me endpoint
  Future<ApiResult<UserModel>> getCurrentUser() async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.me),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResult.success(UserModel.fromJson(json));
      } else {
        final error = _parseError(response);
        return ApiResult.failure(error);
      }
    } catch (e) {
      return ApiResult.failure('Failed to get current user: ${e.toString()}');
    }
  }

  /// Update user profile (full_name, phone_number, address)
  /// Uses PATCH method for partial updates
  Future<ApiResult<UserModel>> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (fullName != null) body['full_name'] = fullName;
      if (phoneNumber != null) body['phone_number'] = phoneNumber;
      if (address != null) body['address'] = address;

      final response = await _client.patch(
        Uri.parse(ApiConstants.updateProfile),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResult.success(UserModel.fromJson(json));
      } else {
        final error = _parseError(response);
        return ApiResult.failure(error);
      }
    } catch (e) {
      return ApiResult.failure('Failed to update profile: ${e.toString()}');
    }
  }

  /// Upload user avatar
  /// Uses POST method with multipart/form-data
  Future<ApiResult<UserModel>> uploadAvatar(String filePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.uploadAvatar),
      );

      // Add authorization header
      if (_accessToken != null && _accessToken!.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $_accessToken';
      }

      // Add file to request
      request.files.add(await http.MultipartFile.fromPath('avatar', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResult.success(UserModel.fromJson(json));
      } else {
        final error = _parseError(response);
        return ApiResult.failure(error);
      }
    } catch (e) {
      return ApiResult.failure('Failed to upload avatar: ${e.toString()}');
    }
  }

  /// Change user password
  /// Uses POST method
  Future<ApiResult<String>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.changePassword),
        headers: _headers,
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResult.success(
          json['message'] ?? 'Password changed successfully',
        );
      } else {
        final error = _parseError(response);
        return ApiResult.failure(error);
      }
    } catch (e) {
      return ApiResult.failure('Failed to change password: ${e.toString()}');
    }
  }

  /// Parse error response from API
  String _parseError(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      return json['detail'] ??
          json['message'] ??
          'Request failed with status ${response.statusCode}';
    } catch (_) {
      return 'Request failed with status ${response.statusCode}';
    }
  }

  /// Dispose the HTTP client
  void dispose() {
    _client.close();
  }
}
