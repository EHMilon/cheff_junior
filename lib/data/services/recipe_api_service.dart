import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/explore_recipe_model.dart';
import '../models/recipe_detail_model.dart';
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

  /// Initialize the service
  Future<RecipeApiService> init() async {
    // Token will be fetched fresh before each request
    return this;
  }

  /// Update access token (called when user logs in/out)
  void updateAccessToken(String? token) {
    _accessToken = token;
  }

  /// Get current access token from AuthService
  String? _getCurrentToken() {
    try {
      final authService = Get.find<AuthService>();
      return authService.getToken();
    } catch (e) {
      // AuthService not available
      return _accessToken;
    }
  }

  /// Common headers for authenticated API requests
  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    // Always fetch fresh token before request
    final token = _getCurrentToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
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

  /// Get a single recipe by ID (Legacy - returns Recipe model)
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

  /// Get recipe detail by ID
  ///
  /// [id] - The recipe ID
  /// Returns the detailed recipe on success
  /// Endpoint: GET $baseUrl/recipes/{id}
  Future<RecipeApiResult<RecipeDetail>> getRecipeDetail(int id) async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.recipeById(id.toString())),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final recipeDetail = RecipeDetail.fromJson(json);
        return RecipeApiResult.success(recipeDetail);
      } else {
        final error = _parseError(response);
        return RecipeApiResult.failure(error);
      }
    } catch (e) {
      return RecipeApiResult.failure('Failed to fetch recipe detail: ${e.toString()}');
    }
  }

  /// Get explore recipes from the API
  ///
  /// Returns a list of recipes for the explore/home screen
  /// Endpoint: GET $baseUrl/recipes/explore
  Future<RecipeApiResult<List<ExploreRecipe>>> getExploreRecipes() async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.recipeExplore),
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
            .map((item) => ExploreRecipe.fromJson(item as Map<String, dynamic>))
            .toList();

        return RecipeApiResult.success(recipes);
      } else {
        final error = _parseError(response);
        return RecipeApiResult.failure(error);
      }
    } catch (e) {
      return RecipeApiResult.failure('Failed to fetch explore recipes: ${e.toString()}');
    }
  }

  /// Search recipes by query string
  ///
  /// [query] - The search query string
  /// Returns a list of matching recipes on success
  Future<RecipeApiResult<List<ExploreRecipe>>> searchRecipes(String query) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.search}?q=${Uri.encodeComponent(query)}'),
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
            .map((item) => ExploreRecipe.fromJson(item as Map<String, dynamic>))
            .toList();

        return RecipeApiResult.success(recipes);
      } else {
        final error = _parseError(response);
        return RecipeApiResult.failure(error);
      }
    } catch (e) {
      return RecipeApiResult.failure('Failed to search recipes: ${e.toString()}');
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
