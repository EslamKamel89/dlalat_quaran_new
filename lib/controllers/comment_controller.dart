import 'package:dio/dio.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CommentController extends GetxController {
  static const String _domainLink = "https://ioqs.org/control-panel/api/v1/";
  static const String _addAyahComment = "addayahcomment";
  static const String _addArticleComment = "https://ioqs.org/control-panel/api/v1/";
  static const String _addTagComment = "https://ioqs.org/control-panel/api/v1/";

  final Dio _dio = Dio();
}
