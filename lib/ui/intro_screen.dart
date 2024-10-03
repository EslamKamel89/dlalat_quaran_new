import 'package:dlalat_quaran_new/ui/add_research.dart';
import 'package:dlalat_quaran_new/ui/articles_screen.dart';
import 'package:dlalat_quaran_new/ui/audio_recitations_screen.dart';
import 'package:dlalat_quaran_new/ui/home_sura_screen.dart';
import 'package:dlalat_quaran_new/ui/setting_screen.dart';
import 'package:dlalat_quaran_new/ui/tags_screen.dart';
import 'package:dlalat_quaran_new/ui/video_categories_screen.dart';
import 'package:dlalat_quaran_new/utils/colors.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/widgets/splash_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class IntroScreen extends StatelessWidget {
  static var id = '/IntroScreen';

  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // deleteDatabase('dlalat_qurann.db');
    var itemSize = (MediaQuery.of(context).size.width - 80) / 3;
    var scHeight = Get.height;
    return Stack(
      children: [
        SplashBackground(
            childWidget: Container(
          padding: EdgeInsets.only(top: itemSize / 1.3),
          child: Column(
            children: [
              Image.asset(
                logoSmall,
                width: scHeight / 8,
                height: scHeight / 8,
              ),
              Text(
                'app_name'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: scHeight / 40, fontFamily: 'Almarai'),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'introText'.tr,
                style: TextStyle(
                  color: const Color(0xFFF5B45E),
                  fontSize: scHeight / 50,
                  fontFamily: 'Almarai',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: scHeight / 20,
              ),
              Stack(
                children: [
                  Image.asset(
                    _centerView(),
                    width: scHeight / 2.8,
                    height: scHeight / 2.3,
                  ),
                  Positioned(
                    left: itemSize,
                    top: 20,
                    child: SizedBox(
                      width: itemSize,
                      height: itemSize - 20,
                      child: GestureDetector(
                        onTap: () {
                          int page =
                              GetStorage().read(savedPage).toString() == 'null' ? 0 : GetStorage().read(savedPage);
                          Locale loca = Get.locale!;
                          Widget destination;
                          if (loca.languageCode == 'ar') {
                            destination = const HomeSuraScreen();
                          } else {
                            destination = const HomeSuraScreen();
                          }
                          // ShortExplanationIndex();
                          Get.to(() => destination);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: itemSize - 30,
                    child: SizedBox(
                      width: itemSize - 20,
                      height: itemSize - 20,
                      child: GestureDetector(onTap: () => Get.to(ArticlesScreen())),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: itemSize - 40,
                    child: SizedBox(
                      width: itemSize - 20,
                      height: itemSize - 20,
                      child: GestureDetector(
                        onTap: () => Get.to(TagsScreen()),
                      ),
                    ),
                  ),
                  Positioned(
                    left: itemSize,
                    bottom: 10,
                    child: SizedBox(
                      width: itemSize,
                      height: itemSize - 20,
                      child: GestureDetector(
                        onTap: () => Get.to(SettingScreen()),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: itemSize - 30,
                    child: SizedBox(
                      width: itemSize - 20,
                      height: itemSize - 20,
                      child: GestureDetector(
                        onTap: () => Get.to(AudioRecitationsScreen(), transition: Transition.fade),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: itemSize - 40,
                    child: SizedBox(
                      width: itemSize - 20,
                      height: itemSize - 20,
                      child: GestureDetector(
                        onTap: () => Get.to(VideoCategoriesScreen(), transition: Transition.fade),
                      ),
                    ),
                  ),
                  Positioned(
                    top: itemSize,
                    bottom: itemSize,
                    left: itemSize,
                    child: SizedBox(
                      width: itemSize - 20,
                      height: itemSize - 20,
                      child: GestureDetector(
                        onTap: () => print('Quraaan'),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )),
        Positioned(
            // bottom: itemSize / 3,
            // bottom: itemSize * 4.5,
            right: itemSize / 3,
            // right: itemSize / 1.4,
            bottom: itemSize / 1.5,
            // right: (MediaQuery.of(context).size.width / 2) - ((itemSize / 1.8) / 2),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AddResearchView.id);
              },
              child: Container(
                height: itemSize / 1.8,
                width: itemSize / 1.8,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.4),
                  boxShadow: [
                    BoxShadow(offset: const Offset(3, 3), color: primaryColor.withOpacity(0.2)),
                  ],
                ),
                child: Image.asset(
                  "assets/images/quran.png",
                  // fit: BoxFit.cover,
                  height: itemSize / 2.5,
                  width: itemSize / 2.5,
                ),
              ),
            ))
      ],
    );
  }

  String _centerView() {
    String path = '';
    switch (GetStorage().read(language)) {
      case 'ar':
        path = 'assets/images/center_view.png';
        break;
      case 'en':
        path = 'assets/images/center_view_en.png';
        break;
      case 'fr':
        path = 'assets/images/center_view.png';
        break;
      case 'es':
        path = 'assets/images/center_view.png';
        break;
      default:
        path = 'assets/images/center_view.png';
    }
    return path;
  }
}
