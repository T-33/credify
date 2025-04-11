// lib/presentation/screens/add_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../themes/app_colors.dart';
import '../../data/models/category.dart';
import '../../state/providers/transaction_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isExpense = true;
  String? _selectedCategoryId;

  // Тестовые категории (в реальном приложении берутся из провайдера)
  final List<Category> _categories = [
    Category(
      id: '1',
      name: 'Продукты',
      iconName: 'shopping_basket',
      colorHex: '#FF9800', // Оранжевый
      isExpense: true,
    ),
    Category(
      id: '2',
      name: 'Рестораны',
      iconName: 'restaurant',
      colorHex: '#E91E63', // Розовый
      isExpense: true,
    ),
    Category(
      id: '3',
      name: 'Транспорт',
      iconName: 'directions_car',
      colorHex: '#2196F3', // Синий
      isExpense: true,
    ),
    Category(
      id: '4',
      name: 'Развлечения',
      iconName: 'local_movies',
      colorHex: '#9C27B0', // Пурпурный
      isExpense: true,
    ),
    Category(
      id: '5',
      name: 'Доход',
      iconName: 'account_balance_wallet',
      colorHex: '#4CAF50', // Зеленый
      isExpense: false,
    ),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      // В реальном приложении используем провайдер для добавления транзакции
      final repository = ref.read(transactionRepositoryProvider);
      repository.addTransaction(
        userId: 'user123', // В реальном приложении берем из провайдера аутентификации
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        categoryId: _selectedCategoryId!,
        isExpense: _isExpense,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      ).then((_) {
        // Обновляем список транзакций в провайдере
        ref.refresh(transactionsProvider);
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(_isExpense ? 'Добавить расход' : 'Добавить доход'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Переключатель типа транзакции
              Center(
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('Расход'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('Доход'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                  ],
                  selected: {_isExpense},
                  onSelectionChanged: (Set<bool> selected) {
                    setState(() {
                      _isExpense = selected.first;
                      // Сбрасываем категорию при смене типа
                      _selectedCategoryId = null;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Поле суммы
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Сумма',
                  prefixIcon: Icon(Icons.money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите сумму';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите корректное число';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Поле названия транзакции
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Выбор даты
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Дата',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(dateFormat.format(_selectedDate)),
                ),
              ),
              const SizedBox(height: 16),

              // Выбор категории
              const Text(
                'Категория',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories
                    .where((c) => c.isExpense == _isExpense)
                    .map((category) {
                  final isSelected = _selectedCategoryId == category.id;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategoryId = category.id;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? category.color.withOpacity(0.2)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? category.color
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category.icon,
                            color: category.color,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category.name,
                            style: TextStyle(
                              color: isSelected
                                  ? category.color
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Поле для заметки
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Заметка (необязательно)',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Кнопка отправки
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Сохранить',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}