import 'package:dlalat_quaran_new/controllers/add_reserch_controller.dart';
import 'package:dlalat_quaran_new/controllers/comment_controller.dart';
import 'package:dlalat_quaran_new/controllers/explanation_controller.dart';
import 'package:dlalat_quaran_new/network/sync_manager.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:get/get.dart';

void initializeGetController() {
  Get.put(SyncManager()..syncData(), permanent: true);
  Get.put(CommentController(dioConsumer: serviceLocator()), permanent: true);
  Get.put(ExplanationController(dioConsumer: serviceLocator()), permanent: true);
  Get.put(AddResearchController(dioConsumer: serviceLocator()), permanent: true);
}
