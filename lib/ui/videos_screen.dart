import 'dart:async';

import 'package:dlalat_quaran_new/controllers/video_controller.dart';
import 'package:dlalat_quaran_new/models/video_model.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/widgets/quran_toolbar.dart';
import 'package:dlalat_quaran_new/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: QuranBar('الفيديوهات'.tr),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SearchWidget(_textEditingController, null, () {
                _videoController.search(_textEditingController.text.toString().toLowerCase());
              }),
              GetBuilder<VideoController>(builder: (_) {
                return Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        VideoModel videoModel = VideoControllerData.filteredVideosList[index];
                        return VideoCard(videoModel: videoModel);
                      },
                      itemCount: VideoControllerData.filteredVideosList.length
                      //  > 1
                      //     ? 1
                      //     : VideoControllerData.filteredVideosList.length,
                      ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  const VideoCard({super.key, required this.videoModel});
  final VideoModel videoModel;
  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  YoutubePlayerController? _controller;
  bool _isPlaying = false;
  final t = 'videos screen';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _controller == null
              ? const SizedBox()
              : Center(
                  child: YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                    onReady: () {
                      // pr('Player is ready', t);
                    },
                  ),
                ),
          const SizedBox(),
          InkWell(
            onTap: () {
              if (_controller == null) {
                _controller = YoutubePlayerController(
                  initialVideoId: widget.videoModel.url?.split('=').last ?? '',
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                );
                setState(() {});
                _controller!.addListener(() {
                  _isPlaying = _controller!.value.isPlaying;
                });
                Future.delayed(const Duration(seconds: 10)).then((_) {
                  // pr(_controller, '$t -  controller');
                  // pr(_isPlaying, '$t -  isPlaying');
                  if (_controller != null) {
                    if (!_isPlaying) {
                      _controller!.dispose();
                      _controller = null;
                      setState(() {});
                    }
                  }
                });
                return;
              }
              if (_controller != null) {
                _controller!.dispose();
                _controller = null;
                setState(() {});
                return;
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 100,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Spacer(),
                  Text(
                    widget.videoModel.name ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                      color: primaryColor,
                      fontFamily: 'Almarai',
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Text(widget.videoModel.ayat_id.toString()),
                  const Spacer(),
                  Text(_controller == null ? 'مشاهدة الفيديو' : 'أخفاء الفيديو'),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
