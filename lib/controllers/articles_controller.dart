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
    await allArticlesApi();
    // articlesList.value = list;
    // filteredList.value = list;

    update();
  }

  void search(String key) {
    ArticlesData.filteredList = ArticlesData.articlesList;
    // filteredList.value = articlesList.where(((x) => x.toString().contains(key))).toList();
    ArticlesData.filteredList = ArticlesData.articlesList.where(((x) => x.toString().contains(key))).toList();
    update();
  }

  Future allArticlesApi() async {
    const t = 'allArticlesApi - ArticlesController ';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl + articlesIndexEndpoint;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    ArticlesData.articlesList = [];
    ArticlesData.filteredList = [];
    List tempArticleList = [];
    bool continueLoop = true;
    int page = 0;
    int limit = 20;
    responseState = ResponseState.loading;
    try {
      do {
        final response = await dioConsumer.get("$path/${page * limit}/$limit/$deviceLocale");
        List data = jsonDecode(response);
        pr(data, '$t - raw response');
        if (data.isEmpty) {
          responseState = ResponseState.success;
          tempArticleList = [];
        } else {
          List<ArticleModel> articles = data.map<ArticleModel>((json) => ArticleModel.fromJson(json)).toList();
          pr(articles, '$t - parsed response');
          responseState = ResponseState.success;
          tempArticleList = articles;
          ArticlesData.articlesList.addAll(articles);
          ArticlesData.filteredList = ArticlesData.articlesList;
        }

        if (tempArticleList.isEmpty) {
          continueLoop = false;
        } else {
          continueLoop = true;
          page++;
          pr('continue loop', t);
          pr('continueLoop : $continueLoop', t);
          pr('page : $page', t);
        }
        update();
      } while (continueLoop);
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseState.failed;
      update();
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
