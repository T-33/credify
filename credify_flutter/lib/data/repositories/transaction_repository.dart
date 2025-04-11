// lib/data/repositories/transaction_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class TransactionRepository {
  final String baseUrl;
  final String apiKey;

  TransactionRepository({
    required this.baseUrl,
    required this.apiKey,
  });

  Future<List<Transaction>> getTransactions(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/transactions/$userId'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> transactionsJson = jsonDecode(response.body);
        return transactionsJson
            .map((json) => Transaction.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting transactions: $e');
    }
  }

  Future<Transaction> addTransaction({
    required String userId,
    required String title,
    required double amount,
    required DateTime date,
    required String categoryId,
    required bool isExpense,
    String? note,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/transactions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'userId': userId,
          'title': title,
          'amount': amount,
          'date': date.toIso8601String(),
          'categoryId': categoryId,
          'isExpense': isExpense,
          'note': note,
        }),
      );

      if (response.statusCode == 201) {
        return Transaction.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding transaction: $e');
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/transactions/$transactionId'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting transaction: $e');
    }
  }
}