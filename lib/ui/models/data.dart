import 'package:acfashion_store/ui/models/product_model.dart';

class Data {
  static List<ProductModel> generateCategories() {
    return [
      ProductModel(
          "1",
          6,
          "assets/images/categories/woman/1.png",
          "assets/images/categories/woman/1.png",
          "Azul",
          "M",
          "Damas",
          "Damas",
          "blusas",
          "5.0",
          28.000),
      ProductModel(
          "2",
          5,
          "assets/images/categories/man/2.png",
          "assets/images/categories/woman/1.png",
          "Negra",
          "L",
          "Caballeros",
          "Caballeros",
          "",
          "4.0",
          28.000),
      ProductModel(
          "3",
          2,
          "assets/images/categories/boy/3.png",
          "assets/images/categories/woman/1.png",
          "Roja",
          "S",
          "Niños",
          "Niños",
          "men shoes",
          "4.5",
          28.000),
      ProductModel(
          "4",
          12,
          "assets/images/categories/woman/1.png",
          "assets/images/categories/woman/1.png",
          "Amarilla",
          "Unica",
          "Niñas",
          "Niñas",
          "men shoes",
          "3.0",
          28.000),
    ];
  }
}
