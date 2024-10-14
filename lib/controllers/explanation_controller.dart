// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:dlalat_quaran_new/utils/print_helper.dart';
import 'package:dlalat_quaran_new/utils/response_state_enum.dart';
import 'package:get/get.dart';

class ExplanationController extends GetxController {
  static const String _domainLink = "https://ioqs.org/control-panel/api/v1/";
  static const String _ayah = "ayah";
  String? explanation;
  ResponseState responseState = ResponseState.initial;
  final DioConsumer dioConsumer;
  ExplanationController({
    this.explanation,
    required this.dioConsumer,
  });
  Future<String?> getExplanation({
    required String id,
  }) async {
    const t = 'getExplanation - ExplanationController ';
    String path = _domainLink;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    path += "$_ayah/$id/$deviceLocale";
    responseState = ResponseState.loading;
    try {
      final response = await dioConsumer.get(path);
      String? explanation = jsonDecode(response)['explanation'];
      if (explanation != null) {
        pr(response, t);
        responseState = ResponseState.success;
        update();
        return explanation;
      }
      pr('No explanation for this ayah: $id', t);
      responseState = ResponseState.success;
      update();
      return null;
    } on Exception catch (e) {
      pr('Exeption occured: $e', t);
      responseState = ResponseState.failed;
      update();
      return null;
    }
  }
}
