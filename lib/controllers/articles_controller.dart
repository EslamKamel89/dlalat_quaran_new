import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:get/get.dart';

class ArticlesController extends GetxController {
  var articlesList = [].obs;
  var filteredList = [].obs;

  void allArticles() async {
    var list = await DataBaseHelper.dataBaseInstance().allArticles();
    articlesList.value = list;
    filteredList.value = list;
    update();
  }

  void search(String key) {
    filteredList.value = articlesList.where(((x) => x.toString().contains(key))).toList();
    update();
  }

  @override
  void onClose() {
    filteredList.clear();
    articlesList.clear();
    update();
    super.onClose();
  }
}
