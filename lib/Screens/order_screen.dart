import 'package:flutter/material.dart';
import 'package:smart_ahwa_manager/Screens/order_details_screen.dart';
import 'package:smart_ahwa_manager/Screens/report_screen.dart';
import 'package:smart_ahwa_manager/core/local.dart';
import 'package:smart_ahwa_manager/core/model/drink.dart';
import 'package:smart_ahwa_manager/core/model/order_model.dart';
import 'package:smart_ahwa_manager/core/model/order_state.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ValueNotifier<Drink?> selectedDrinkNotifier = ValueNotifier(null);
  final nameController = TextEditingController();
  final instructionsController = TextEditingController();
  final drinks = DrinkFactory.getDrinks();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    instructionsController.dispose();
    selectedDrinkNotifier.dispose();

    super.dispose();
  }

  void clear() {
    nameController.clear();
    instructionsController.clear();
    selectedDrinkNotifier.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ahwa App ☕'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TopSellingDrinksScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,

          child: Column(
            children: [
              formField(
                nameController,
                "Customer Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }

                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Please enter a valid name (letters and spaces only)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              ValueListenableBuilder<Drink?>(
                valueListenable: selectedDrinkNotifier,
                builder: (context, value, child) {
                  return DropdownButtonFormField<Drink>(
                    value: value,
                    hint: const Text("Choose a drink"),
                    validator: (value) =>
                        value == null ? 'Please select a drink' : null,
                    items: drinks.map((drink) {
                      return DropdownMenuItem(
                        value: drink,
                        child: Text("${drink.name} - ${drink.price} EGP"),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      selectedDrinkNotifier.value = newValue;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              formField(instructionsController, "Special Instructions"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final order = Order(
                    customerName: nameController.text,
                    drink: selectedDrinkNotifier.value!,
                    specialInstructions: instructionsController.text,
                    status: PendingState(),
                  );
                  final ordersList =
                      SharedPrefHelper.instance.getStringList("order") ??
                      <String>[];
                  ordersList.add(Order.toJsonStr(order));

                  SharedPrefHelper.instance.setStringList("order", ordersList);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Order placed successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );

                  clear();
                },
                child: const Text("Add Order"),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrderDetailsScreen()),
                  );

                  // sentOrder(context);
                },
                child: const Text("OrderDetails"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField formField(
    TextEditingController? controller,
    String? labelText, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
    );
  }

  void addOrder(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final order = Order(
      customerName: nameController.text,
      drink: selectedDrinkNotifier.value!,
      specialInstructions: instructionsController.text,
      status: PendingState(),
    );
    final ordersList =
        SharedPrefHelper.instance.getStringList("order") ?? <String>[];
    ordersList.add(Order.toJsonStr(order));

    SharedPrefHelper.instance.setStringList("order", ordersList);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Order placed successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    clear();
  }
}
