import 'dart:developer';
import 'dart:ui';

import 'package:dlalat_quaran_new/controllers/download_link_controller.dart';
import 'package:dlalat_quaran_new/controllers/expain_dialog_controller.dart';
import 'package:dlalat_quaran_new/controllers/explanation_controller.dart';
import 'package:dlalat_quaran_new/ui/add_comment.dart';
import 'package:dlalat_quaran_new/ui/video_player_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:dlalat_quaran_new/widgets/custom_buttons.dart';
import 'package:dlalat_quaran_new/widgets/font_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ExplainDialog extends StatefulWidget {
  final String ayaKey, videoId;
  VoidCallback? playerFunction;

  ExplainDialog({super.key, this.playerFunction, required this.ayaKey, required this.videoId});

  @override
  State<ExplainDialog> createState() => _ExplainDialogState();
}

class _ExplainDialogState extends State<ExplainDialog> {
  final ExplainDialogController _dialogController = Get.put(ExplainDialogController());

  final GetDownloadLinkController _downloadLinkController = Get.put(
    GetDownloadLinkController(dioConsumer: serviceLocator()),
  );
  final ExplanationController explanationController = Get.find<ExplanationController>();
  String? downloadLink;
  String? explanation;
  @override
  void initState() {
    _downloadLinkController.getDownloadlink(downloadLinkType: DownloadLinkType.ayah, id: widget.ayaKey).then(
          (value) => downloadLink = value,
        );
    explanationController.getExplanation(id: widget.ayaKey).then(
          (value) => explanation = value,
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // pr('Ayah id: $ayaKey', 'Explain Dialog widget');

    log('Video Id => ${_dialogController.videoUrl.value} }');
    _dialogController.getAyaExplain(widget.ayaKey);
    return WillPopScope(
      onWillPop: () async {
        await Get.delete<ExplainDialogController>();
        return true;
      },
      child: BackdropFilter(
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
                      onTap: () => Get.back(),
                    ),
                    Expanded(
                        child: Text(
                      'aya_explanation'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'Almarai', color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                    const Icon(null),
                  ],
                ),
                Container(
                  color: Colors.grey,
                  height: .7,
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                ),
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: Text(
                        _dialogController.ayaText.value.toLowerCase() != 'null' ? _dialogController.ayaText.value : '',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontFamily: "me_quran", color: primaryColor, fontSize: 15),
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Scrollbar(
                    trackVisibility: true,
                    // hoverThickness: 50,
                    scrollbarOrientation: ScrollbarOrientation.right,
                    radius: const Radius.circular(10),
                    thumbVisibility: true,
                    thickness: 10,
                    child: SingleChildScrollView(
                      child: GetBuilder<ExplanationController>(
                        builder: (_) {
                          // return Container(
                          //   margin: const EdgeInsets.only(top: 10),
                          //   child: Text(
                          //     staticData,
                          //     // style: GoogleFonts.cairo().copyWith(fontSize: 16),
                          //     // style: GoogleFonts.amiri().copyWith(fontSize: 16),
                          //     // style: GoogleFonts.scheherazadeNew().copyWith(fontSize: 16),
                          //     // style: GoogleFonts.changa().copyWith(fontSize: 16),
                          //     // style: GoogleFonts.notoNaskhArabic().copyWith(fontSize: 16),
                          //     // style: GoogleFonts.elMessiri().copyWith(fontSize: 16),
                          //     // style: GoogleFonts.mada().copyWith(fontSize: 16),
                          //     // style: GoogleFonts.reemKufi().copyWith(fontSize: 16),
                          //     style: GoogleFonts.lateef().copyWith(fontSize: 16),
                          //   ),
                          // );
                          return SizedBox(
                            // color: Colors.red,
                            width: double.infinity,
                            child: Html(
                              data: explanation ?? '',
                              style: mainHtmlStyle,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: false,
                      child: Expanded(
                          child: SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                          onPressed: widget.playerFunction,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                soundIcon,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              AlMaraiText(10, 'start_recitation'.tr)
                            ],
                          ),
                        ),
                      )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: SizedBox(
                      height: 55,
                      child: Obx(() => Visibility(
                            visible: _dialogController.videoUrl.value.toLowerCase() != 'null',
                            child: PrimaryButton(
                                onPressed: () =>
                                    Get.to(() => VideoPlayerScreen(videoId: _dialogController.videoUrl.value)),
                                borderRadius: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.play_circle_fill),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    AlMaraiText(0, 'video'.tr)
                                  ],
                                )),
                          )),
                    )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    PrimaryButton(
                      onPressed: () {
                        Get.toNamed(AddCommentView.id, arguments: {"id": widget.ayaKey, 'commentType': 'ayah'});
                      },
                      borderRadius: 5,
                      child: Text(
                        'addComment'.tr,
                        // 'Hello world',
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
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}
