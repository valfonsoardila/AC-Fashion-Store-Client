import 'package:acfashion_store/ui/models/categories_model.dart';

class AssetsModel {
  static List<CategoriesModel> generateCategories() {
    return [
      CategoriesModel(
        "0",
        "",
        "Todos",
      ),
      CategoriesModel(
        "1",
        "assets/images/categories/woman/1.png",
        "Damas",
      ),
      CategoriesModel(
        "2",
        "assets/images/categories/man/2.png",
        "Caballeros",
      ),
      CategoriesModel(
        "3",
        "assets/images/categories/boy/3.png",
        "Niños",
      ),
      CategoriesModel(
        "4",
        "assets/images/categories/woman/1.png",
        "Niñas",
      ),
    ];
  }
}
