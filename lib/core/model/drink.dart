abstract class Drink {
  final String _name;
  final double _price;

  Drink({required String name, required double price})
    : _name = name,
      _price = price;

  String get name => _name;
  double get price => _price;

  Map<String, dynamic> toJson() => {'name': name, 'price': price};

  static Drink fromJson(Map<String, dynamic> json) =>
      DrinkFactory.fromJson(json);
}

class Shai extends Drink {
  Shai() : super(name: 'Shai', price: 10.0);
}

class TeeOnFifty extends Drink {
  TeeOnFifty() : super(name: 'Tee On Fifty', price: 8.0);
}

class TurkishCoffee extends Drink {
  TurkishCoffee() : super(name: 'Turkish Coffee', price: 15.0);
}

class HibiscusTea extends Drink {
  HibiscusTea() : super(name: 'Hibiscus Tea', price: 12.0);
}

class DrinkFactory {
  static final Map<String, Drink Function()> _registry = {
    'Shai': () => Shai(),
    'Tee On Fifty': () => TeeOnFifty(),
    'Turkish Coffee': () => TurkishCoffee(),
    'Hibiscus Tea': () => HibiscusTea(),
  };

  static List<Drink> getDrinks() => _registry.values.map((e) => e()).toList();

  static Drink fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;

    final drinkCreator = _registry[name];
    if (drinkCreator != null) {
      return drinkCreator();
    }
    throw Exception('Unknown drink name: $name');
  }

  static void registerDrink(String name, Drink Function() creator) {
    _registry[name] = creator;
  }
}
