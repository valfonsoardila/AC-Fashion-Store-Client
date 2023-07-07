import 'package:acfashion_store/ui/models/product_model.dart';

class Data {
  static List<ProductModel> generateProducts() {
    return [
      ProductModel("1", "assets/images/shoes_1.png", "Creter Impact",
          "Men's Shoes", "men shoes", 99.56),
      ProductModel("2", "assets/images/shoes_2.png", "Air - Max Pre Day",
          "Men's Shoes", "men shoes", 137.56),
      ProductModel("3", "assets/images/shoes_3.png", "Air Max 51",
          "Men's Shoes", "men shoes", 99.56),
      ProductModel("4", "assets/images/shoes_4.png", "EM Shoes", "Men's Shoes",
          "men shoes", 212.56),
    ];
  }

  static List<ProductModel> generateCategories() {
    return [
      ProductModel("1", "assets/images/shoes_1.png", "Damas", "Men's Shoes",
          "men shoes", 99.56),
      ProductModel("2", "assets/images/shoes_2.png", "Caballeros",
          "Men's Shoes", "men shoes", 137.56),
      ProductModel("3", "assets/images/shoes_3.png", "Niños", "Men's Shoes",
          "men shoes", 99.56),
      ProductModel("4", "assets/images/shoes_4.png", "Niñas", "Men's Shoes",
          "men shoes", 212.56),
    ];
  }
}
