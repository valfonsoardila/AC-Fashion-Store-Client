import 'package:acfashion_store/ui/models/product_model.dart';

class Data {
  static List<ProductModel> generateCategories() {
    return [
      ProductModel("1", "assets/images/categories/woman/1.png", "Azul", "M",
          "Damas", "Damas", "blusas", 28.000),
      ProductModel("2", "assets/images/categories/man/2.png", "Negra", "L",
          "Caballeros", "Caballeros", "", 28.000),
      ProductModel("3", "assets/images/categories/boy/3.png", "Roja", "S",
          "Niños", "Niños", "men shoes", 28.000),
      ProductModel("4", "assets/images/categories/woman/1.png", "Amarilla",
          "Unica", "Niñas", "Niñas", "men shoes", 28.000),
    ];
  }
}
