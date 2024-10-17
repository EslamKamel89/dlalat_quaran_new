import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/models/video_model.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class VideoControllerData {
  static List<VideoModel> allVideos = [];
  static List<VideoModel> filteredVideosList = [];
}

class VideoController extends GetxController {
  final DataBaseHelper databaseHelper = DataBaseHelper.dataBaseInstance();
  Future<void> getAllVideos() async {
    VideoControllerData.allVideos = await databaseHelper.getAllVideosRaw();
    VideoControllerData.filteredVideosList = VideoControllerData.allVideos;
    update();
  }

  void search(String key) {
    VideoControllerData.filteredVideosList = VideoControllerData.allVideos
        .where(
          (x) => x.toString().toLowerCase().trim().contains(key.toLowerCase()),
        )
        .toList();
    update();
  }
}
