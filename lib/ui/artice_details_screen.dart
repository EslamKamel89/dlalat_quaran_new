import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/article_model.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

//ignore: must_be_immutable
class ArticleDetailsScreen extends StatelessWidget {
  static String id = '/ArticleDetailsScreen';
  late ArticleModel model;
  final ArticlesDetailsController _detailsController = Get.put(ArticlesDetailsController());

  ArticleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    model = ArticleModel.fromJson(Get.arguments);
    _detailsController.articleId = model.id!;
    _detailsController.updateArticleModel(model);
    _detailsController.getRelatedArticles();
    return Obx(() => Scaffold(
          appBar: QuranBar(_detailsController.selectedArticleModel.value.name!),
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.8),
                  child: Obx(() => Text(
                        _detailsController.selectedArticleModel.value.name!,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: primaryColor, fontSize: 18, fontFamily: 'Almarai'),
                      )),
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: lightGray2, width: 1)),
                  margin: const EdgeInsets.only(top: 20, bottom: 20, right: 10, left: 10),
                  child: Scrollbar(
                    trackVisibility: true,
                    scrollbarOrientation: ScrollbarOrientation.right,
                    radius: const Radius.circular(10),
                    thumbVisibility: true,
                    thickness: 3,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      child: Obx(() => Html(
                                data: _detailsController.selectedArticleModel.value.description!,
                                style: {
                                  '#': Style(
                                      // fontFamily: "Almarai",
                                      //   color: primaryColor,
                                      lineHeight: LineHeight.number(1.2)),
                                },
                              )

                          // Text(parseHtmlString(_detailsController.selectedArticleModel.value.description!),textAlign: TextAlign.justify,)
                          ),
                    ),
                  ),
                )),
                Obx(() => Visibility(
                      // To Be Continue
                      visible: _detailsController.relatedArticles.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'read_also'.tr,
                              style: const TextStyle(color: primaryColor, fontFamily: "Almarai"),
                            ),
                          ),
                          Container(
                            height: 40,
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _detailsController.relatedArticles.length,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  onPressed: () =>
                                      _detailsController.updateArticleModel(_detailsController.relatedArticles[index]),
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.blueGrey,
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.zero,
                                      elevation: 2),
                                  child: Text(
                                    _detailsController.relatedArticles[index].name,
                                    style: const TextStyle(fontFamily: 'Almarai'),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}

class ArticlesDetailsController extends GetxController {
  int articleId = 0;
  var relatedArticles = [].obs;
  var selectedArticleModel = ArticleModel().obs;

  void getRelatedArticles() async {
    relatedArticles.value = await DataBaseHelper.dataBaseInstance().relatedArticles(articleId);
    update();
  }

  void updateArticleModel(ArticleModel model) {
    selectedArticleModel.value = model;
    articleId = model.id!;

    update();
    getRelatedArticles();
  }
}
