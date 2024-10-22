import 'package:dlalat_quaran_new/controllers/articles_controller.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/widgets/articles_widgets.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticlesScreen extends StatelessWidget {
  static String id = '/ArticlesScreen';
  ArticlesScreen({super.key});
  final ArticlesController _articlesController = Get.put(ArticlesController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _articlesController.allArticles();
    // _articlesController.allArticles();
    _searchController.addListener(() {
      _articlesController.search(_searchController.text.toString().toLowerCase());
    });
    return Scaffold(
      appBar: QuranBar("articles".tr),
      body: Column(
        children: [
          SearchWidget(_searchController, null, () {
            _articlesController.search(_searchController.text.toString().toLowerCase());
          }),
          GetBuilder<ArticlesController>(
            builder: (context) {
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index < ArticlesData.filteredList.length) {
                      return ArticlesWidget(ArticlesData.filteredList[index]);
                    }
                    return _articlesController.responseState == ResponseState.loading
                        ? Container(
                            height: 500,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          )
                        : const SizedBox();
                  },
                  itemCount: ArticlesData.filteredList.length + 1,
                ),
              );
            },
          )

          // Obx(
          //   () => _articlesController.filteredList.isNotEmpty
          //       ? Expanded(
          //           child: ListView.builder(
          //             itemBuilder: (context, index) {
          //               return ArticlesWidget(_articlesController.filteredList[index]);
          //             },
          //             itemCount: _articlesController.filteredList.length,
          //           ),
          //         )
          //       : Expanded(
          //           child: Center(
          //             child: Text(
          //               'no_articles_found'.tr,
          //               textAlign: TextAlign.center,
          //             ),
          //           ),
          //         ),
          // )
        ],
      ),
    );
  }
}
