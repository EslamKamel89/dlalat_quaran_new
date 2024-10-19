import 'dart:convert';

import 'package:dlalat_quaran_new/models/article_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';

abstract class ArticlesData {
  static List articlesList = [];
  static List filteredList = [];
}

class ArticlesController extends GetxController {
  // var articlesList = [].obs;
  // var filteredList = [].obs;
  ResponseState responseState = ResponseState.initial;
  final articlesIndexEndpoint = "articles";

  void allArticles() async {
    // var list = await DataBaseHelper.dataBaseInstance().allArticles();
    var list = await allArticlesApi();
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

  Future<List<ArticleModel>> allArticlesApi() async {
    const t = 'allArticlesApi - ArticlesController ';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl + articlesIndexEndpoint;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    responseState = ResponseState.loading;
    try {
      // if (!(await isInternetAvailable())) {
      //   update();
      //   return await getCachedExplanation(id: id);
      // }
      final response = await dioConsumer.get(path, queryParameter: {
        "lang_code": deviceLocale,
      });
      List data = jsonDecode(response);
      pr(data, '$t - raw response');
      if (data.isEmpty) {
        responseState = ResponseState.success;
        pr('No articles found', t);
        return [];
      }
      // await cacheExplanation(id: id, explanation: explanation);
      List<ArticleModel> articles = data.map<ArticleModel>((json) => ArticleModel.fromJson(json)).toList();
      pr(articles, '$t - parsed response');
      responseState = ResponseState.success;
      return articles;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseState.failed;
      // update();
      return [];
    }
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
