import 'dart:convert';

import 'package:dlalat_quaran_new/models/tag_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';

abstract class TagsScreenData {
  static List tagsList = [];
  static List filteredList = [];
}

class TagsScreenController extends GetxController {
  var isLoading = true.obs;
  ResponseState responseState = ResponseState.initial;
  final getTagsEndpoint = "tags";
  void getTags() async {
    // var list = await DataBaseHelper.dataBaseInstance().tagsIndex();
    var list = await getTagsApi();

    TagsScreenData.tagsList = list;
    TagsScreenData.filteredList = list;
    // for (var i = 0; i < TagsScreenData.tagsList.length; i++) {
    //   pr(TagsScreenData.tagsList[i], 'getTags');
    // }

    isLoading.value = false;
    update();
  }

  Future<List<TagModel>> getTagsApi() async {
    const t = 'getTagsApi - TagsScreenController ';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl + getTagsEndpoint;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    responseState = ResponseState.loading;
    try {
      // if (!(await isInternetAvailable())) {
      //   update();
      //   return await getCachedExplanation(id: id);
      // }
      final response = await dioConsumer.get(path);
      List data = jsonDecode(response);
      pr(data, '$t - raw response');
      if (data.isEmpty) {
        responseState = ResponseState.success;
        pr('No tags found', t);
        return [];
      }
      // await cacheExplanation(id: id, explanation: explanation);
      List<TagModel> tags = data.map<TagModel>((json) => TagModel.fromJson(json)).toList();
      pr(tags, '$t - parsed response');
      responseState = ResponseState.success;
      return tags;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseState.failed;
      // update();
      return [];
    }
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
