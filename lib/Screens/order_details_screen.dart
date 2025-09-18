import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_ahwa_manager/core/enum/order_status.dart';
import 'package:smart_ahwa_manager/core/local.dart';
import 'package:smart_ahwa_manager/core/model/order_model.dart';
import 'package:smart_ahwa_manager/core/model/order_state.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late List<ValueNotifier<Order>> orderNotifiers;

  @override
  @override
  void initState() {
    super.initState();

    final ordersList = SharedPrefHelper.instance.getStringList("order") ?? [];

    orderNotifiers = ordersList
        .map((jsonStr) {
          return ValueNotifier(Order.fromJson(jsonDecode(jsonStr)));
        })
        .whereType<ValueNotifier<Order>>()
        .toList();
  }

  @override
  void dispose() {
    for (var notifier in orderNotifiers) {
      notifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details"), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orderNotifiers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final orderNotifier = orderNotifiers[index];
          return ValueListenableBuilder<Order>(
            valueListenable: orderNotifier,
            builder: (context, order, _) {
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Drink: ${order.drink.name}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Price: ${order.drink.price} EGP",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Instructions: ${order.specialInstructions}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status: ${order.status.name}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          DropdownButton<OrderStatusEnum>(
                            value: orderStateMap.entries
                                .firstWhere(
                                  (e) =>
                                      e.value.runtimeType ==
                                      order.status.runtimeType,
                                )
                                .key,
                            items: OrderStatusEnum.values.map((statusEnum) {
                              return DropdownMenuItem(
                                value: statusEnum,
                                child: Text(orderStateMap[statusEnum]!.name),
                              );
                            }).toList(),
                            onChanged: (newStatusEnum) {
                              if (newStatusEnum != null) {
                                orderNotifier.value = order.copyWith(
                                  status: orderStateMap[newStatusEnum],
                                );
                              }
                              final ordersList =
                                  SharedPrefHelper.instance.getStringList(
                                    "order",
                                  ) ??
                                  [];
                              ordersList[index] = Order.toJsonStr(
                                orderNotifier.value,
                              );
                              SharedPrefHelper.instance.setStringList(
                                "order",
                                ordersList,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
