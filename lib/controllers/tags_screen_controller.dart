import 'dart:developer';

import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/tag_model.dart';
import 'package:get/get.dart';

List<TagModel> _tagsList = [];

class TagsScreenController extends GetxController {
  RxList<TagModel> tagsList = <TagModel>[].obs;
  RxList<TagModel> filteredList = <TagModel>[].obs;
  var isLoading = true.obs;

  void getTags() async {
    // pr('getTags is called');
    var list = await DataBaseHelper.dataBaseInstance().tagsIndex();
    for (int i = 0; i < list.length; i++) {
      var tagModel = list[i];
      if (tagModel.name_ar == 'مركب') {
        // pr(tagModel.name_ar, 'arabic name in getTags');
        // pr(i, 'index');
      }
    }
    tagsList.removeWhere((_) => true);
    tagsList.addAll(list);
    _tagsList = list;
    filteredList.removeWhere((_) => true);
    filteredList.addAll(list);
    tagsList.refresh();
    filteredList.refresh();
    isLoading.value = false;
    // isLoading.
    // pr(finalTagsList[94]);
    // pr(tagsList[117]);
    // pr(finalTagsList[96]);
    log('tagsLength ${list.length}');
    update();
  }

  void search(String key) {
    // pr(key, 'key');
    // tagsList.refresh();
    // filteredList.refresh();
    // pr(key, 'Key');
    // pr(finalTagsList[94]);
    // pr(_tagsList[117]);
    // pr(finalTagsList[96]);
    filteredList.value = _tagsList.where(((x) {
      // pr(x, 'value');
      // pr(x.name_ar, 'value - name ar');
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
