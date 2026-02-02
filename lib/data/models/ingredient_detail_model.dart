import 'package:flutter/material.dart';

/// Ingredient detail model for backend API integration
/// Used to display detailed ingredient information in the popup
class IngredientDetail {
  final String id;
  final String name;
  final String amount;
  final String? icon;
  final String? origin;
  final String? history;
  final List<Nutrient>? nutrients;
  final List<String>? funFacts;

  IngredientDetail({
    required this.id,
    required this.name,
    required this.amount,
    this.icon,
    this.origin,
    this.history,
    this.nutrients,
    this.funFacts,
  });

  /// Create IngredientDetail from JSON (backend API response)
  factory IngredientDetail.fromJson(Map<String, dynamic> json) {
    return IngredientDetail(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      amount: json['amount'] ?? '',
      icon: json['icon'],
      origin: json['origin'],
      history: json['history'],
      nutrients: json['nutrients'] != null
          ? (json['nutrients'] as List)
                .map((e) => Nutrient.fromJson(e))
                .toList()
          : null,
      funFacts: json['fun_facts'] != null
          ? List<String>.from(json['fun_facts'])
          : null,
    );
  }

  /// Convert IngredientDetail to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'icon': icon,
      'origin': origin,
      'history': history,
      'nutrients': nutrients?.map((e) => e.toJson()).toList(),
      'fun_facts': funFacts,
    };
  }

  /// Create a copy of this ingredient with updated fields
  IngredientDetail copyWith({
    String? id,
    String? name,
    String? amount,
    String? icon,
    String? origin,
    String? history,
    List<Nutrient>? nutrients,
    List<String>? funFacts,
  }) {
    return IngredientDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      icon: icon ?? this.icon,
      origin: origin ?? this.origin,
      history: history ?? this.history,
      nutrients: nutrients ?? this.nutrients,
      funFacts: funFacts ?? this.funFacts,
    );
  }

  @override
  String toString() {
    return 'IngredientDetail(id: $id, name: $name, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IngredientDetail && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Nutrient information for ingredients
class Nutrient {
  final String name;
  final String value;
  final Color? color;

  Nutrient({required this.name, required this.value, this.color});

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(name: json['name'] ?? '', value: json['value'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}
