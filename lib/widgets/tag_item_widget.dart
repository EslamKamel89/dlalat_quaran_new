import 'package:dlalat_quran/models/tag_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagItemWidget extends StatelessWidget {
  final TagModel tagModel;
  final Widget destination;

  const TagItemWidget(this.tagModel, this.destination, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey, backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        onPressed: () => Get.to(destination,
            transition: Transition.fade, arguments: tagModel.toJson()),
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 50,
          child: Row(
            children: [
              Expanded(
                  child: Text(
                tagModel.name(),
                style: const TextStyle(fontFamily: "Almarai", fontSize: 15,color: Colors.black),
              )),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}
