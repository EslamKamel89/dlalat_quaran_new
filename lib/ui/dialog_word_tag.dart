import 'dart:ui';

import 'package:dlalat_quaran_new/controllers/dialog_word_tag_controller.dart';
import 'package:dlalat_quaran_new/controllers/download_link_controller.dart';
import 'package:dlalat_quaran_new/ui/add_comment.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:dlalat_quaran_new/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/video_item_dialog.dart';

class DialogWordTag extends StatefulWidget {
  final String tagId;
  final String wordId;

  const DialogWordTag({super.key, required this.tagId, required this.wordId});

  @override
  State<DialogWordTag> createState() => _DialogWordTagState();
}

class _DialogWordTagState extends State<DialogWordTag> {
  final DialogWordTagController _dialogController = Get.put(DialogWordTagController());

  final GetDownloadLinkController _downloadLinkController = Get.put(
    GetDownloadLinkController(dioConsumer: serviceLocator()),
  );
  String? downloadLink;
  @override
  void initState() {
    _downloadLinkController.getDownloadlink(downloadLinkType: DownloadLinkType.tag, id: widget.tagId).then(
          (value) => downloadLink = value,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dialogController.getTagVideo(widget.tagId, int.parse(widget.wordId));
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Material(
        elevation: 1,
        color: const Color(0x5dffffff),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Container(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
          margin: const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: const Icon(Icons.arrow_back_outlined),
                    onTap: () {
                      Get.back();
                      Get.delete<DialogWordTagController>();
                    },
                  ),
                  Expanded(
                      child: Obx(() => Text(
                            _dialogController.wordName.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'Almarai', color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),
                          ))),
                  const Icon(null),
                ],
              ),
              Container(
                color: Colors.grey,
                height: .5,
                margin: const EdgeInsets.only(top: 15, bottom: 15),
              ),
              Html(
                data: '',
                style: {
                  '#': Style(
                      // fontFamily: "kitab",
                      color: primaryColor,
                      fontSize: FontSize.large,
                      fontWeight: FontWeight.bold),
                },
              ),
              Obx(() => _dialogController.description.value != 'null' && _dialogController.description.value != ''
                  ? Expanded(
                      flex: 1,
                      child: Scrollbar(
                        trackVisibility: true,
                        scrollbarOrientation: ScrollbarOrientation.right,
                        radius: const Radius.circular(10),
                        thumbVisibility: true,
                        thickness: 10,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12, left: 12),
                            child: Obx(() => Html(
                                  data: _dialogController.description.value,
                                  style: {
                                    '#': Style(
                                        // fontFamily: "Almarai",
                                        color: Colors.blueGrey,
                                        lineHeight: LineHeight.number(1.2)),
                                  },
                                )),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: _dialogController.videoModels.map((e) {
                          // e.name = _dialogController.wordName.value;
                          return VideoItemDialog(
                            videoModel: e,
                          );
                        }).toList(),
                      ),
                    )),
              Obx(() => _dialogController.videoModels.isNotEmpty &&
                      _dialogController.description.value != 'null' &&
                      _dialogController.description.value != ''
                  ? SizedBox(
                      height: 170,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          _dialogController.videoModels[index].name = _dialogController.wordName.value;
                          return VideoItemDialog(
                            videoModel: _dialogController.videoModels[index],
                          );
                        },
                        itemCount: _dialogController.videoModels.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    )
                  : const SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  PrimaryButton(
                    onPressed: () {
                      Get.toNamed(AddCommentView.id, arguments: {"id": widget.tagId, 'commentType': 'tag'});
                    },
                    borderRadius: 5,
                    child: Text(
                      'addComment'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  GetBuilder<GetDownloadLinkController>(
                    builder: (_) {
                      if (downloadLink != null) {
                        return PrimaryButton(
                          onPressed: () {
                            launchUrl(Uri.parse(downloadLink!));
                          },
                          borderRadius: 5,
                          child: Text(
                            'تحميل'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
