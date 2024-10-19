import 'dart:convert';

import 'package:dlalat_quaran_new/models/article_model.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';

abstract class ArticleDetailsData {
  static List relatedArticles = [];
}

class ArticlesDetailsController extends GetxController {
  int articleId = 0;
  // var relatedArticles = [].obs;
  var selectedArticleModel = ArticleModel().obs;
  ResponseState responseState = ResponseState.initial;
  final getRelatedArticlesEndpoint = "related-articles";

  void getRelatedArticles() async {
    // ArticleDetailsData.relatedArticles = await DataBaseHelper.dataBaseInstance().relatedArticles(articleId);
    ArticleDetailsData.relatedArticles = await getRelatedArticlesApi();
    update();
  }

  Future<List<ArticleModel>> getRelatedArticlesApi() async {
    const t = 'getRelatedArticlesApi - ArticlesDetailsController ';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl + getRelatedArticlesEndpoint;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    responseState = ResponseState.loading;
    try {
      // if (!(await isInternetAvailable())) {
      //   update();
      //   return await getCachedExplanation(id: id);
      // }
      final response = await dioConsumer.get(path, queryParameter: {
        "article-id": articleId,
      });
      List data = jsonDecode(response);
      pr(data, '$t - raw response');
      if (data.isEmpty) {
        responseState = ResponseState.success;
        pr('No related articles found', t);
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

  void updateArticleModel(ArticleModel model) {
    selectedArticleModel.value = model;
    articleId = model.id!;

    update();
    getRelatedArticles();
  }

  @override
  void onClose() {
    ArticleDetailsData.relatedArticles = [];
    super.onClose();
  }
}
