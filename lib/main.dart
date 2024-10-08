import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dlalat_quaran_new/controllers/comment_controller.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:dlalat_quaran_new/db/database_helper.dart';
import 'package:dlalat_quaran_new/network/sync_manager.dart';
import 'package:dlalat_quaran_new/ui/about_app_screen.dart';
import 'package:dlalat_quaran_new/ui/add_comment.dart';
import 'package:dlalat_quaran_new/ui/add_research.dart';
import 'package:dlalat_quaran_new/ui/artice_details_screen.dart';
import 'package:dlalat_quaran_new/ui/articles_screen.dart';
import 'package:dlalat_quaran_new/ui/audio_recitations_screen.dart';
import 'package:dlalat_quaran_new/ui/competition_screen.dart';
import 'package:dlalat_quaran_new/ui/home_sura_screen.dart';
import 'package:dlalat_quaran_new/ui/intro_screen.dart';
import 'package:dlalat_quaran_new/ui/join_competition_screen.dart';
import 'package:dlalat_quaran_new/ui/search_result_screen.dart';
import 'package:dlalat_quaran_new/ui/select_language_screen.dart';
import 'package:dlalat_quaran_new/ui/setting_screen.dart';
import 'package:dlalat_quaran_new/ui/splash_screen.dart';
import 'package:dlalat_quaran_new/ui/tag_details_screen.dart';
import 'package:dlalat_quaran_new/ui/tags_screen.dart';
import 'package:dlalat_quaran_new/ui/video_categories_screen.dart';
import 'package:dlalat_quaran_new/ui/video_player_screen.dart';
import 'package:dlalat_quaran_new/utils/audio_folders.dart';
import 'package:dlalat_quaran_new/utils/constants.dart';
import 'package:dlalat_quaran_new/utils/current_locales.dart';
import 'package:dlalat_quaran_new/utils/servicle_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'ui/video_library_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
  await GetStorage.init();
  DataBaseHelper.dataBaseInstance();
  GetStorage().read(KpageBg);
  GetStorage().read(KnormalFontColor);
  GetStorage().read(KtagWordsColor);
  log('Strorageeg ${GetStorage().read(KreadWordsColor)}');
  await DataBaseHelper().initDb(); // Init DataBase
  await DataBaseHelper.dataBaseInstance().suraIndex();
  runApp(const DlalatQuran());
}

class DlalatQuran extends StatefulWidget {
  static final AudioPlayer mainAudioPlayer = AudioPlayer();

  const DlalatQuran({super.key});

  @override
  State<DlalatQuran> createState() => _DlalatQuranState();
}

class _DlalatQuranState extends State<DlalatQuran> {
  @override
  void initState() {
    Get.put(SyncManager()..syncData(), permanent: true);
    Get.put(CommentController(dioConsumer: serviceLocator()), permanent: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('main App Build ');
    print('main App Build ');
    AudioFolders().checkStoragePermission();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Update

    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme:
            const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light, foregroundColor: Colors.white // 2
                ),
      ),
      locale: GetStorage().read(language) != null ? Locale(GetStorage().read(language)) : Get.deviceLocale,
      translations: CurrentLocales(),
      debugShowCheckedModeBanner: false,
      title: 'دلالات القرآن',
      home: const SplashScreen(),
      getPages: [
        GetPage(
          name: SelectLanguageScreen.id,
          page: () => SelectLanguageScreen(),
        ),
        GetPage(
          name: SplashScreen.id,
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: IntroScreen.id,
          page: () => const IntroScreen(),
        ),
        GetPage(
          name: ArticlesScreen.id,
          page: () => ArticlesScreen(),
        ),
        GetPage(
          name: ArticleDetailsScreen.id,
          page: () => ArticleDetailsScreen(),
        ),
        GetPage(
          name: VideoCategoriesScreen.id,
          page: () => VideoCategoriesScreen(),
        ),
        GetPage(
          name: TagsScreen.id,
          page: () => TagsScreen(),
        ),
        GetPage(
          name: TagDetailsScreen.id,
          page: () => TagDetailsScreen(),
        ),
        GetPage(
          name: SettingScreen.id,
          page: () => SettingScreen(),
        ),
        GetPage(
          name: AboutAppScreen.id,
          page: () => const AboutAppScreen(),
        ),
        GetPage(
          name: VideoLibraryScreen.id,
          page: () => VideoLibraryScreen(),
        ),
        GetPage(
          name: AudioRecitationsScreen.id,
          page: () => AudioRecitationsScreen(),
        ),
        GetPage(
          name: VideoPlayerScreen.id,
          page: () => const VideoPlayerScreen(
            videoId: "",
          ),
        ),
        GetPage(
          name: HomeSuraScreen.id,
          page: () => const HomeSuraScreen(),
        ),
        GetPage(
          name: SearchResultScreen.id,
          page: () => SearchResultScreen(),
        ),
        GetPage(
          name: AddCommentView.id,
          page: () => const AddCommentView(),
        ),
        GetPage(
          name: AddResearchView.id,
          page: () => const AddResearchView(),
        ),
        GetPage(
          name: CompetitionsScreen.id,
          page: () => const CompetitionsScreen(),
        ),
        GetPage(
          name: JoinCompetitonView.id,
          page: () => JoinCompetitonView(),
        ),
      ],
    );
  }
}
