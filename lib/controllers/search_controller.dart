import 'dart:developer';

import 'package:dlalat_quran/db/database_helper.dart';
import 'package:dlalat_quran/models/sura_search_model.dart';
import 'package:get/get.dart';

class WordSearchController extends GetxController {
  var resultList = <SuraSearchModel>[].obs;
  var loading = false.obs;
  var wordCount = '0'.obs;
  int sum = 0;
  var searchKey = '';

  void search(String key) async {
    log('Search Key $key');
    resultList.clear();
    sum = 0;
    searchKey = key;
    wordCount.value = sum.toString();
    loading.value = true;
    update();
    resultList.value =
        await DataBaseHelper.dataBaseInstance().searchByWord(key);
    for (var e in resultList) {
      sum += e.count!;
    }
    wordCount.value = sum.toString();
    loading.value = false;
    update();
  }
}
