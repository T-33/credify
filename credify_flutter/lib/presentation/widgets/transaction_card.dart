// lib/presentation/widgets/transaction_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../themes/app_colors.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final bool isExpense;
  final IconData icon;

  const TransactionCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isExpense,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'ru_RU', symbol: '₽');
    final dateFormat = DateFormat('dd MMM', 'ru_RU');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isExpense
                ? AppColors.expense.withOpacity(0.1)
                : AppColors.income.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isExpense ? AppColors.expense : AppColors.income,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '$category • ${dateFormat.format(date)}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: Text(
          '${isExpense ? '-' : '+'} ${currencyFormat.format(amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isExpense ? AppColors.expense : AppColors.income,
          ),
        ),
      ),
    );
  }
}