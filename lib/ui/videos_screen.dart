import 'package:dlalat_quaran_new/controllers/video_controller.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideosScreen extends StatelessWidget {
  VideosScreen({super.key});

  static String id = '/VideosScreen';
  final VideoController _videoController = Get.find<VideoController>()..getAllVideos();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _textEditingController.addListener(() {
      _videoController.search(_textEditingController.text.toString().toLowerCase());
    });
    return Scaffold(
      appBar: QuranBar('الفيديوهات'.tr),
      body: Column(
        children: [
          SearchWidget(_textEditingController, null, () {
            _videoController.search(_textEditingController.text.toString().toLowerCase());
          }),
          GetBuilder<VideoController>(builder: (_) {
            return Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    child: Text(VideoControllerData.filteredVideosList[index].name ?? 'unkwnown'),
                  );
                  // return TagItemWidget(TagsScreenData.filteredList[index], TagDetailsScreen());
                },
                itemCount: VideoControllerData.filteredVideosList.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  const VideoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
