import 'package:dlalat_quran/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class WordModel {
  String? word_id;
  String? word_ar;
  String? word_en;
  Color? color;
  int? ayaNo;
  int? page;
  String? sura;
  String? suraName;
  String? text_indopak;
  String? ayaId;
  String? juz;
  String? char_type;
  String? verse_key;
  Color? selectedAyaColor;
  int? line;
  int? position;
  String? tagId;
  String? videoId;
  String? wordVideo;

  bool lastAya() {
    var split = verse_key!.split(':');
    return int.parse(split[split.length]) == ayaNo!;
  }

  bool firstAya() {
    return ayaNo == 1 && position == 1;
  }

  @override
  String toString() {
    return '${GetStorage().read(language) == 'ar' ? word_ar : word_en}';
  }
}
