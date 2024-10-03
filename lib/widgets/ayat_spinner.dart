import 'package:dlalat_quran/controllers/audio_recitation_controller.dart';
import 'package:dlalat_quran/widgets/font_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class AyatSpinner extends StatefulWidget {
  late AudioRecitationController controller;

  AyatSpinner(this.controller, {Key? key}) : super(key: key);

  @override
  _AyatSpinnerState createState() => _AyatSpinnerState();
}

class _AyatSpinnerState extends State<AyatSpinner> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      value: widget.controller.selectAya.value,
      items: widget.controller.ayatList
          .map<DropdownMenuItem<String?>>((String? value) {
        return DropdownMenuItem<String?>(
          value: value,
          child: Padding(
            child: AlMaraiText(0, 'aya'.tr + ' $value'),
            padding: const EdgeInsets.only(left: 5, right: 5),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          widget.controller.selectAya.value = value.toString();
          widget.controller.update();
        });
      },
      isExpanded: true,
      underline: const SizedBox(),
    );
  }
}
