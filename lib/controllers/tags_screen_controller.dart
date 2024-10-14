import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:get/get.dart';

abstract class TagsScreenData {
  static List tagsList = [];
  static List filteredList = [];
}

class TagsScreenController extends GetxController {
  var isLoading = true.obs;

  void getTags() async {
    var list = await DataBaseHelper.dataBaseInstance().tagsIndex();

    TagsScreenData.tagsList = list;
    TagsScreenData.filteredList = list;
    // for (var i = 0; i < TagsScreenData.tagsList.length; i++) {
    //   pr(TagsScreenData.tagsList[i], 'getTags');
    // }

    isLoading.value = false;
    update();
  }

  void search(String key) {
    TagsScreenData.filteredList = TagsScreenData.tagsList.where(((x) {
      return x.toString().toLowerCase().contains(key.toLowerCase());
    })).toList();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getTags();
  }
}
