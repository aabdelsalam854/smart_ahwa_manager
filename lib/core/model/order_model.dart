import 'dart:convert';

import 'package:smart_ahwa_manager/core/model/drink.dart';
import 'package:smart_ahwa_manager/core/model/order_state.dart';

class Order {
  final String customerName;
  final Drink drink;
  final String? specialInstructions;
  final OrderState status;

  const Order({
    required this.customerName,
    required this.drink,
    required this.specialInstructions,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    customerName: json['customerName'],

    drink: Drink.fromJson(json['drink']),
    specialInstructions: json['specialInstructions'] ?? "",
    status: OrderState.fromJson(json['status']),
  );

  Order copyWith({
    String? customerName,
    Drink? drink,
    String? specialInstructions,
    OrderState? status,
  }) {
    return Order(
      customerName: customerName ?? this.customerName,
      drink: drink ?? this.drink,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'customerName': customerName,
    'drink': drink.toJson(),
    'specialInstructions': specialInstructions,
    'status': status.toJson(),
  };

  static String toJsonStr(Order data) => jsonEncode(data.toJson());
}
