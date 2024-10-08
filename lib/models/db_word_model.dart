class DbWordModel {
  DbWordModel({
    required this.id,
    required this.position,
    // required this.textIndopak,
    required this.verseKey,
    required this.line,
    required this.page,
    required this.code,
    required this.codeV3,
    required this.className,
    required this.wordAr,
    required this.charType,
    required this.wordEn,
    required this.wordFr,
    required this.wordSp,
    required this.audio,
    required this.ayatId,
    required this.suraId,
    required this.juz,
    required this.hezb,
    required this.rub,
    required this.simple,
    required this.vedio,
    required this.createdAt,
    required this.updatedAt,
    required this.translation,
  });
  late final int? id;
  late final int? position;
  // late final String? textIndopak;
  late final String? verseKey;
  late final int? line;
  late final int? page;
  late final String? code;
  late final String? codeV3;
  late final String? className;
  late final String? wordAr;
  late final String? charType;
  late final String? wordEn;
  late final String? wordFr;
  late final String? wordSp;
  late final String? audio;
  late final int? ayatId;
  late final int? suraId;
  late final int? juz;
  late final int? hezb;
  late final int? rub;
  late final String? simple;
  late final String? vedio;
  late final String? createdAt;
  late final String? updatedAt;
  late final String? translation;

  DbWordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
    // textIndopak = json['text_indopak'];
    verseKey = json['verse_key'];
    line = json['line'];
    page = json['page'];
    code = json['code'];
    codeV3 = json['code_v3'];
    className = json['class_name'];
    wordAr = json['word_ar'];
    charType = json['char_type'];
    wordEn = json['word_en'];
    wordFr = json['word_fr'];
    wordSp = json['word_sp'];
    audio = json['audio'];
    ayatId = json['ayat_id'];
    suraId = json['sura_id'];
    juz = json['juz'];
    hezb = json['hezb'];
    rub = json['rub'];
    simple = json['simple'];
    vedio = json['vedio'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    translation = json['translation'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['position'] = position;
    // _data['text_indopak'] = textIndopak;
    _data['verse_key'] = verseKey;
    _data['line'] = line;
    _data['page'] = page;
    _data['code'] = code;
    _data['code_v3'] = codeV3;
    _data['class_name'] = className;
    _data['word_ar'] = wordAr;
    _data['char_type'] = charType;
    _data['word_en'] = wordEn;
    _data['word_fr'] = wordFr;
    _data['word_sp'] = wordSp;
    _data['audio'] = audio;
    _data['ayat_id'] = ayatId;
    _data['sura_id'] = suraId;
    _data['juz'] = juz;
    _data['hezb'] = hezb;
    _data['rub'] = rub;
    _data['simple'] = simple;
    _data['vedio'] = vedio;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['translation'] = translation;
    return _data;
  }
}
