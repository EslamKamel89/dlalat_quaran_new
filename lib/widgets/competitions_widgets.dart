import 'package:dlalat_quaran_new/models/competition_model.dart';
import 'package:dlalat_quaran_new/ui/join_competition_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompetitionsWidget extends StatefulWidget {
  final CompetitionModel competitionModel;

  const CompetitionsWidget(this.competitionModel, {super.key});

  @override
  State<CompetitionsWidget> createState() => _CompetitionsWidgetState();
}

class _CompetitionsWidgetState extends State<CompetitionsWidget> {
  // String _parseHtmlString(String htmlString) {
  int? maxLines = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        shadowColor: Colors.grey,
        elevation: 10,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.competitionModel.nameAr ?? '',
                  overflow: maxLines == null ? null : TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontFamily: 'Almarai',
                  ),
                  maxLines: maxLines,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    maxLines != null
                        ? const SizedBox()
                        : TextButton(
                            onPressed: () {
                              Get.toNamed(
                                JoinCompetitonView.id,
                                arguments: {'competitionModel': widget.competitionModel},
                              );
                            },
                            child: const Text('أجب علي هذا السؤال')),
                    TextButton(
                      onPressed: () {
                        if (maxLines == 1) {
                          maxLines = null;
                          setState(() {});
                          return;
                        }
                        if (maxLines == null) {
                          maxLines = 1;
                          setState(() {});
                          return;
                        }
                      },
                      child: Text(
                        maxLines == null ? 'أخفاء' : 'قراءة المزيد',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
