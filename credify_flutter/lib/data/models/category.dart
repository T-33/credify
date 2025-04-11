// lib/data/models/category.dart
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String iconName;
  final String colorHex;
  final bool isExpense;

  Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.isExpense,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      iconName: json['iconName'],
      colorHex: json['colorHex'],
      isExpense: json['isExpense'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'colorHex': colorHex,
      'isExpense': isExpense,
    };
  }

  // Получить иконку из строкового имени
  IconData get icon {
    // Логика преобразования строки в IconData
    // Пример простой реализации:
    switch (iconName) {
      case 'shopping_basket':
        return Icons.shopping_basket;
      case 'restaurant':
        return Icons.restaurant;
      case 'home':
        return Icons.home;
      case 'directions_car':
        return Icons.directions_car;
      case 'local_movies':
        return Icons.local_movies;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.category;
    }
  }

  // Получить цвет из HEX строки
  Color get color {
    return Color(int.parse(colorHex.replaceAll('#', '0xff')));
  }
}