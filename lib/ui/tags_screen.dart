import 'package:dlalat_quaran_new/controllers/tags_screen_controller.dart';
import 'package:dlalat_quaran_new/ui/tag_details_screen.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:dlalat_quaran_new/widgets/tag_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagsScreen extends StatelessWidget {
  TagsScreen({super.key});

  static String id = '/TagsScreen';
  final TagsScreenController _tasController = Get.put(TagsScreenController()..getTags());
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _textEditingController.addListener(() {
      _tasController.search(_textEditingController.text.toString().toLowerCase());
    });
    return Scaffold(
      appBar: QuranBar('semantics'.tr),
      body: Column(
        children: [
          SearchWidget(_textEditingController, null, () {
            _tasController.search(_textEditingController.text.toString().toLowerCase());
          }),
          Obx(() => Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return TagItemWidget(_tasController.filteredList[index], TagDetailsScreen());
                },
                itemCount: _tasController.filteredList.length,
              )))
        ],
      ),
    );
  }
}
