import 'package:flutter/material.dart';
import 'package:smart_ahwa_manager/Screens/order_screen.dart';
import 'package:smart_ahwa_manager/core/local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.instance.init();
  runApp(const SmartAhwaManager());
}

class SmartAhwaManager extends StatelessWidget {
  const SmartAhwaManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: OrderScreen(),
      theme: ThemeData(
        
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
