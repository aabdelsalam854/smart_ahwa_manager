import 'package:smart_ahwa_manager/core/enum/order_status.dart';

abstract class OrderState {
  String get name;

  Map<String, dynamic> toJson() => {'State': name};

  static OrderState fromJson(Map<String, dynamic> json) {
    switch (json['State']) {
      case 'Pending':
        return PendingState();
      case 'Done':
        return DoneState();
      case 'Canceled':
        return CanceledState();
      case 'Refunded':
        return RefundedState();
      default:
        throw Exception('Unknown order state: ${json['State']}');
    }
  }
}

class PendingState implements OrderState {
  @override
  String get name => "Pending";

  @override
  Map<String, dynamic> toJson() => {'State': name};
}

class DoneState implements OrderState {
  @override
  String get name => "Done";

  @override
  Map<String, dynamic> toJson() => {'State': name};
}

class CanceledState implements OrderState {
  @override
  String get name => "Canceled";

  @override
  Map<String, dynamic> toJson() => {'State': name};
}

class RefundedState implements OrderState {
  @override
  String get name => "Refunded";
  @override
  Map<String, dynamic> toJson() => {'State': name};
}

final Map<OrderStatusEnum, OrderState> orderStateMap = {
  OrderStatusEnum.pending: PendingState(),
  OrderStatusEnum.done: DoneState(),
  OrderStatusEnum.canceled: CanceledState(),
};
