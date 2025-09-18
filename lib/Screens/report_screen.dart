import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_ahwa_manager/core/local.dart';
import 'package:smart_ahwa_manager/core/model/order_model.dart';
import 'package:smart_ahwa_manager/core/service/report.dart';

class TopSellingDrinksScreen extends StatefulWidget {
  const TopSellingDrinksScreen({super.key});

  @override
  State<TopSellingDrinksScreen> createState() => _TopSellingDrinksScreenState();
}

class _TopSellingDrinksScreenState extends State<TopSellingDrinksScreen> {
  late List<Order> doneOrders;
  late OrderAnalytics analytics;
  late int totalOrders;
  late Map<String, int> topSellingDrinks;

  @override
  void initState() {
    super.initState();
    analytics = OrderReport();
    doneOrders = [];
    _loadDoneOrders();
    totalOrders = analytics.getTotalOrders(doneOrders);
    topSellingDrinks = analytics.getTopSellingDrinks(doneOrders);
  }

  Future<void> _loadDoneOrders() async {
    final ordersList = SharedPrefHelper.instance.getStringList("order") ?? [];
    final orders = ordersList
        .map((jsonStr) {
          final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
          final order = Order.fromJson(jsonMap);

          return order;
        })
        .whereType<Order>()
        .toList();

    setState(() {
      doneOrders = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Selling Drinks Report'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Completed Orders: $totalOrders',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Total Price Orders: ${analytics.getTotalPrice(doneOrders)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Top Selling Drinks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: topSellingDrinks.isEmpty
                  ? const Center(
                      child: Text(
                        'No completed orders yet.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: topSellingDrinks.length,
                      itemBuilder: (context, index) {
                        final drinkName = topSellingDrinks.keys.elementAt(
                          index,
                        );
                        final count = topSellingDrinks[drinkName]!;
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(
                              drinkName,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Text(
                              '$count orders',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
