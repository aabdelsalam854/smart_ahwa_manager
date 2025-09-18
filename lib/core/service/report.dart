import 'package:smart_ahwa_manager/core/model/order_model.dart';
import 'package:smart_ahwa_manager/core/model/order_state.dart';

abstract class OrderAnalytics {
  /// Returns the total number of completed orders (DoneState).
  int getTotalOrders(List<Order> orders);

  /// Returns a map of drink names to their order counts for completed orders, sorted by count descending.
  Map<String, int> getTopSellingDrinks(List<Order> orders);

  /// Returns the total price of completed orders (DoneState).
  double getTotalPrice(List<Order> orders);
}

class OrderReport implements OrderAnalytics {
  @override
  int getTotalOrders(List<Order> orders) {
    return orders.where((order) => order.status is DoneState).length;
  }

  @override
  Map<String, int> getTopSellingDrinks(List<Order> orders) {
    Map<String, int> drinkCount = {};
    for (var order in orders.where((order) => order.status is DoneState)) {
      final drinkName = order.drink.name;
      drinkCount[drinkName] = (drinkCount[drinkName] ?? 0) + 1;
    }
    return Map.fromEntries(
      drinkCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  @override
  double getTotalPrice(List<Order> orders) {
    return orders.fold(0.0, (total, order) {
      if (order.status is DoneState) {
        return total + order.drink.price;
      }
      return total;
    });
  }
}
