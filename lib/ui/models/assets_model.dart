import 'package:acfashion_store/ui/models/categories_model.dart';
import 'package:acfashion_store/ui/models/mcommerce_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';

class AssetsModel {
  static List<MCommerceModel> generateMCommerces() {
    return [
      MCommerceModel(
        "1",
        "assets/icons/mcommerce/ic_bancolombia.png",
        "Ahorro a la mano",
        MyColors.myBlack,
      ),
      MCommerceModel(
        "2",
        "assets/icons/mcommerce/ic_nequi.png",
        "Nequi",
        MyColors.myPurple,
      ),
      MCommerceModel(
        "3",
        "assets/icons/mcommerce/ic_daviplata.png",
        "Davidplata",
        MyColors.myRed,
      ),
      MCommerceModel(
        "2",
        "assets/icons/mcommerce/ic_paypal.png",
        "Paypal",
        MyColors.myBlue,
      ),
      MCommerceModel(
        "3",
        "assets/icons/mcommerce/ic_pse.png",
        "PSE",
        MyColors.myBlueDark,
      ),
    ];
  }

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
