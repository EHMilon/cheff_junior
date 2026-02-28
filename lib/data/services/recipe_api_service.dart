import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';
import 'api_constant.dart';
import 'auth_service.dart';

/// Result class for API responses
class RecipeApiResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  RecipeApiResult.success(this.data) : error = null, isSuccess = true;

  RecipeApiResult.failure(this.error) : data = null, isSuccess = false;
}

/// Recipe API Service - handles all recipe-related API calls with authentication
///
/// This service uses the access token from AuthService for authenticated requests
class RecipeApiService extends GetxService {
  final http.Client _client;
  String? _accessToken;

  RecipeApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Initialize the service and get access token from AuthService
  Future<RecipeApiService> init() async {
    final authService = Get.find<AuthService>();
    _accessToken = authService.getToken();
    return this;
  }

  /// Update access token (called when user logs in/out)
  void updateAccessToken(String? token) {
    _accessToken = token;
  }

  /// Common headers for authenticated API requests
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

  /// Get all recipes from the API
  ///
  /// Returns a list of recipes on success
  Future<RecipeApiResult<List<Recipe>>> getRecipes() async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.recipes),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        
        // Handle different response formats
        List<dynamic> recipesList;
        if (json is List) {
          recipesList = json;
        } else if (json is Map && json.containsKey('data') && json['data'] is List) {
          recipesList = json['data'] as List;
        } else {
          return RecipeApiResult.failure('Invalid response format');
        }

        final recipes = recipesList
            .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
            .toList();
        
        return RecipeApiResult.success(recipes);
      } else {
        final error = _parseError(response);
        return RecipeApiResult.failure(error);
      }
    } catch (e) {
      return RecipeApiResult.failure('Failed to fetch recipes: ${e.toString()}');
    }
  }

  /// Get a single recipe by ID
  ///
  /// [id] - The recipe ID
  /// Returns the recipe on success
  Future<RecipeApiResult<Recipe>> getRecipeById(String id) async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.recipeById(id)),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final recipe = Recipe.fromJson(json);
        return RecipeApiResult.success(recipe);
      } else {
        final error = _parseError(response);
        return RecipeApiResult.failure(error);
      }
    } catch (e) {
      return RecipeApiResult.failure('Failed to fetch recipe: ${e.toString()}');
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

  @override
  void onClose() {
    dispose();
    super.onClose();
  }
}
