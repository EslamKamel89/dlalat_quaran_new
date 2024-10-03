import 'package:dlalat_quran/controllers/audio_recitation_controller.dart';
import 'package:dlalat_quran/models/reciters_model.dart';
import 'package:dlalat_quran/utils/constants.dart';
import 'package:dlalat_quran/widgets/font_text.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class RecitersSpinner extends StatefulWidget {
  late AudioRecitationController controller;

  RecitersSpinner(this.controller, {Key? key}) : super(key: key);

  @override
  _RecitersSpinnerState createState() => _RecitersSpinnerState();
}

class _RecitersSpinnerState extends State<RecitersSpinner> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<ReciterModel?>(
      value: widget.controller.selectedReciter.value,
      items: widget.controller.recitersList.map<DropdownMenuItem<ReciterModel?>>((ReciterModel? value) {
        return DropdownMenuItem<ReciterModel?>(
          value: value,
          child: Padding(
            child: AlMaraiText(0, value!.toString()),
            padding: const EdgeInsets.only(left: 5, right: 5),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          GetStorage().write(reciterKey, value!.id.toString());
          widget.controller.selectedReciter.value = value;
          widget.controller.update();
        });
      },
      isExpanded: true,
      underline: const SizedBox(),
    );
  }
}
