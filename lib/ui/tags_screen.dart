import 'package:dlalat_quaran_new/controllers/tags_screen_controller.dart';
import 'package:dlalat_quaran_new/ui/tag_details_screen.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:dlalat_quaran_new/widgets/tag_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  static String id = '/TagsScreen';

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  final TagsScreenController _tagsController = Get.put(TagsScreenController());

  late TextEditingController _textEditingController;
  @override
  void initState() {
    TagsScreenData.filteredList = [];
    TagsScreenData.tagsList = [];
    _tagsController.getTags();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.addListener(() {
      _tagsController.search(_textEditingController.text.toString().toLowerCase());
    });
    return Scaffold(
      appBar: QuranBar('semantics'.tr),
      body: Column(
        children: [
          SearchWidget(_textEditingController, null, () {
            _tagsController.search(_textEditingController.text.toString().toLowerCase());
          }),
          GetBuilder<TagsScreenController>(builder: (context) {
            return Expanded(
              child: _tagsController.responseState == ResponseState.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return TagItemWidget(TagsScreenData.filteredList[index], const TagDetailsScreen());
                      },
                      itemCount: TagsScreenData.filteredList.length,
                    ),
            );
          }),
          // Obx(
          //   () => Expanded(
          //     child: ListView.builder(
          //       itemBuilder: (context, index) {
          //         return TagItemWidget(_tasController.filteredList[index], TagDetailsScreen());
          //       },
          //       itemCount: _tasController.filteredList.length,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
