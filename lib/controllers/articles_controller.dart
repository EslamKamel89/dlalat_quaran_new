import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:get/get.dart';

abstract class ArticlesData {
  static List articlesList = [];
  static List filteredList = [];
}

class ArticlesController extends GetxController {
  // var articlesList = [].obs;
  // var filteredList = [].obs;

  void allArticles() async {
    var list = await DataBaseHelper.dataBaseInstance().allArticles();
    // articlesList.value = list;
    // filteredList.value = list;
    ArticlesData.articlesList = list;
    ArticlesData.filteredList = list;
    update();
  }

  void search(String key) {
    // filteredList.value = articlesList.where(((x) => x.toString().contains(key))).toList();
    ArticlesData.filteredList = ArticlesData.articlesList.where(((x) => x.toString().contains(key))).toList();
    update();
  }

  @override
  void onClose() {
    // filteredList.clear();
    // articlesList.clear();
    ArticlesData.filteredList.clear();
    ArticlesData.articlesList.clear();
    update();
    super.onClose();
  }
}
