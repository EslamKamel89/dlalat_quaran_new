import 'package:dlalat_quaran_new/models/article_model.dart';
import 'package:dlalat_quaran_new/ui/artice_details_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

class ArticlesWidget extends StatelessWidget {
  final ArticleModel articleModel;

  const ArticlesWidget(this.articleModel, {super.key});

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey, backgroundColor: Colors.white, padding: EdgeInsets.zero, elevation: 2),
        onPressed: () =>
            Get.to(const ArticleDetailsScreen(), transition: Transition.fadeIn, arguments: articleModel.toJson()),
        child: Center(
          child: Container(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    articleModel.name!,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: primaryColor, fontSize: 18, fontFamily: 'Almarai'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _parseHtmlString(articleModel.description!),
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: "Almarai",
                        ),
                        maxLines: 1,
                      ))
                  // Html(
                  //
                  //   data: '${articleModel.description!}',
                  //   style: {
                  //
                  //     '#': Style(
                  //       maxLines: 1,
                  //       fontFamily: "Almarai",
                  //       padding: EdgeInsets.all(0),
                  //       backgroundColor: Colors.red,
                  //       textOverflow: TextOverflow.ellipsis,
                  //     ),
                  //   },
                  // ),
                ],
              )),
        ),
      ),
    );
  }
}
