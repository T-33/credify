// lib/state/providers/transaction_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction.dart';
import '../../data/repositories/transaction_repository.dart';

// Провайдер для репозитория транзакций
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(
    baseUrl: 'https://your-backend-url.com',
    apiKey: 'your-api-key',
  );
});

// Провайдер для получения списка транзакций
final transactionsProvider = FutureProvider.autoDispose<List<Transaction>>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  // В реальном приложении userId нужно получать из сервиса аутентификации
  const userId = 'user123';
  return repository.getTransactions(userId);
});

// Провайдер для баланса
final balanceProvider = Provider<double>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  return transactionsAsync.when(
    data: (transactions) {
      double total = 0;
      for (final transaction in transactions) {
        if (transaction.isExpense) {
          total -= transaction.amount;
        } else {
          total += transaction.amount;
        }
      }
      return total;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// Провайдер для расходов текущего месяца
final monthlyExpensesProvider = Provider<double>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  return transactionsAsync.when(
    data: (transactions) {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      return transactions
          .where((t) => t.isExpense && t.date.isAfter(startOfMonth))
          .fold(0, (sum, t) => sum + t.amount);
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// Провайдер для доходов текущего месяца
final monthlyIncomeProvider = Provider<double>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  return transactionsAsync.when(
    data: (transactions) {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      return transactions
          .where((t) => !t.isExpense && t.date.isAfter(startOfMonth))
          .fold(0, (sum, t) => sum + t.amount);
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});