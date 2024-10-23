import 'package:dlalat_quaran_new/controllers/articles_controller.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/widgets/articles_widgets.dart';
import 'package:dlalat_quaran_new/widgets/articles_widgets_loading.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticlesScreen extends StatefulWidget {
  static String id = '/ArticlesScreen';
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final ArticlesController _articlesController = Get.put(ArticlesController());

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData().then((_) => _fetchData());
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >= 0.9 * _scrollController.position.maxScrollExtent) {
        await _fetchData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (!_isLoading && _articlesController.hasNextPage) {
      _isLoading = true;
      await _articlesController.allArticles();
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index < ArticlesData.filteredList.length) {
                      return ArticlesWidget(ArticlesData.filteredList[index]);
                    }
                    return _articlesController.responseState == ResponseState.loading
                        ? const ArticlesWidgetLodingColumn()
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
