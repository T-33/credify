import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../themes/app_colors.dart';
import '../widgets/transaction_card.dart';
import '../widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currencyFormat = NumberFormat.currency(locale: 'ru_RU', symbol: '₽');

  // Данные будут приходить из репозитория/провайдера
  final double totalBalance = 124500.0;
  final double monthlyIncome = 75000.0;
  final double monthlyExpense = 45300.0;

  final List<TransactionData> recentTransactions = [
    TransactionData(
      title: 'Супермаркет Пятёрочка',
      amount: 1250.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Продукты',
      isExpense: true,
      icon: Icons.shopping_basket,
    ),
    TransactionData(
      title: 'Зарплата',
      amount: 75000.0,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Доход',
      isExpense: false,
      icon: Icons.account_balance_wallet,
    ),
    TransactionData(
      title: 'Кафе "Вкусно и точка"',
      amount: 750.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Рестораны',
      isExpense: true,
      icon: Icons.restaurant,
    ),
  ];

  final List<CategoryData> topCategories = [
    CategoryData(name: 'Продукты', amount: 12500.0, icon: Icons.shopping_basket, color: Colors.orange),
    CategoryData(name: 'Транспорт', amount: 5300.0, icon: Icons.directions_car, color: Colors.blue),
    CategoryData(name: 'Развлечения', amount: 7800.0, icon: Icons.movie, color: Colors.purple),
    CategoryData(name: 'Коммунальные', amount: 6500.0, icon: Icons.home, color: Colors.teal),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Мои финансы',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
              radius: 16,
            ),
            onPressed: () {
              // Открыть профиль
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(),
            _buildQuickActions(),
            _buildMonthlyOverview(),
            _buildTopCategories(),
            _buildRecentTransactions(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Открыть экран добавления транзакции
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Аналитика',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'AI-помощник',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF27AE60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Общий баланс',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(totalBalance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceItem(
                  Icons.arrow_upward,
                  'Доходы',
                  monthlyIncome,
                  Colors.white
              ),
              _buildBalanceItem(
                  Icons.arrow_downward,
                  'Расходы',
                  monthlyExpense,
                  Colors.white70
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(IconData icon, String title, double amount, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
            ),
            Text(
              currencyFormat.format(amount),
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(Icons.add, 'Добавить', AppColors.primary),
          _buildActionButton(Icons.compare_arrows, 'Перевод', AppColors.secondary),
          _buildActionButton(Icons.search, 'Поиск', AppColors.textSecondary),
          _buildActionButton(Icons.lightbulb_outline, 'Советы', AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyOverview() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Расходы по месяцам',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Подробнее',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100000,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            titles[value.toInt() % titles.length],
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeBarGroup(0, 35000),
                  _makeBarGroup(1, 42000),
                  _makeBarGroup(2, 38000),
                  _makeBarGroup(3, 52000),
                  _makeBarGroup(4, 45300),
                  _makeBarGroup(5, 0), // Текущий месяц (незавершенный)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: x == 4 ? AppColors.primary : AppColors.primary.withOpacity(0.5),
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildTopCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Топ категории расходов',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: topCategories.length,
            itemBuilder: (context, index) {
              final category = topCategories[index];
              return CategoryCard(
                name: category.name,
                amount: category.amount,
                icon: category.icon,
                color: category.color,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Последние операции',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Все операции',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentTransactions.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final transaction = recentTransactions[index];
            return TransactionCard(
              title: transaction.title,
              amount: transaction.amount,
              date: transaction.date,
              category: transaction.category,
              isExpense: transaction.isExpense,
              icon: transaction.icon,
            );
          },
        ),
      ],
    );
  }
}

// Дополнительные классы для виджетов
class TransactionData {
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final bool isExpense;
  final IconData icon;

  TransactionData({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isExpense,
    required this.icon,
  });
}

class CategoryData {
  final String name;
  final double amount;
  final IconData icon;
  final Color color;

  CategoryData({
    required this.name,
    required this.amount,
    required this.icon,
    required this.color,
  });
}