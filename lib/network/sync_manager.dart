import 'dart:developer';
import 'dart:io';

// import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:dlalat_quran/db/database_helper.dart';
import 'package:dlalat_quran/models/RelatedArticlesModel.dart';
import 'package:dlalat_quran/models/RelatedTagModel.dart';
import 'package:dlalat_quran/models/TagWordModel.dart';
import 'package:dlalat_quran/models/article_model.dart';
import 'package:dlalat_quran/models/aya_model.dart';
import 'package:dlalat_quran/models/db_word_model.dart';
import 'package:dlalat_quran/models/reciters_model.dart';
import 'package:dlalat_quran/models/sura_model.dart';
import 'package:dlalat_quran/models/tag_model.dart';
import 'package:dlalat_quran/models/video_category.dart';
import 'package:dlalat_quran/models/video_model.dart';
import 'package:dlalat_quran/utils/audio_download.dart';
import 'package:dlalat_quran/utils/audio_folders.dart';
import 'package:dlalat_quran/utils/print_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SyncManager extends GetxController {
  static const String _domainLink = "https://ioqs.org/control-panel/api/v1/";
  static const String _deviceKey = 'device_key';
  // Insert
  static const String _getInsert = "get-public-created";

  // Updated
  static const String _getUpdates = "get-public-updates";

  // Deleted
  static const String _getDeletes = "get-public-deleted";

  //
  static const String _confirmSync = "confirm-sync";

  static const String _dateFormat = 'yyyy-MM-dd HH:mm:ss';

  final Dio _dio = Dio();

  var deviceId = '';

  var syncStarted = false;

  var isLoading = false.obs;

  var dbInstance = DataBaseHelper.database;

  String? lastSync;

  void setLoading(bool value) {
    isLoading.value = value;
    update();
  }

  static Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor.toString(); // Unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      log('Device Key ${androidDeviceInfo.id.toString()}');
      return androidDeviceInfo.id.toString(); // Unique ID on Android
    }
  }

  Future<void> updateSyncDate() async {
    log('current Date  update Start ');
    final now = DateTime.now();
    String formatter = DateFormat(_dateFormat).format(now); // 28/03/2020
    log('current Date  update date $formatter');
    String query = " UPDATE saved_values SET value = '$formatter' WHERE key = 1";
    await dbInstance.rawUpdate(query);
  }

  // Inserted
  void insertedData({bool forceUpdate = false}) async {
    // getLastSyncDate();
    // updateSyncDate();

    final now = DateTime.now();
    String currentDate = DateFormat(_dateFormat).format(now); // 28/03/2020

    lastSync = await DataBaseHelper.dataBaseInstance().getLastSyncDate();
    if (forceUpdate) {
      pr(lastSync, 'lastSync');
      lastSync = DateTime.parse(lastSync ?? '').subtract(const Duration(days: 1)).toString();
      pr(lastSync, 'lastSync');
    }

    log('lastSync Date = $lastSync Current $currentDate status => ${lastSync == currentDate}');
    var lastSyncDate = DateFormat(_dateFormat).parse(lastSync!);

    var timeNow = DateTime.now();
    if (lastSync == currentDate && !forceUpdate) {
      return;
    }
    if (lastSyncDate.isAfter(timeNow) && !forceUpdate) {
      return;
    }

    if (!await isInternetAvailable()) {
      return;
    }
    print("syncStarted====================");
    if (!syncStarted) {
      syncStarted = true;

      setLoading(true);
      deviceId = await _getId();
      log('$tag insertedData $deviceId');
      _dio.interceptors.add(
        DioLoggingInterceptor(
          level: Level.body,
          compact: false,
        ),
      );
      var response =
          await _dio.get(_domainLink + _getInsert, queryParameters: {_deviceKey: deviceId, 'date': lastSync});
      log('Insert Data sdasdasd $response');
      print('Insert Data --------------${_domainLink + _getInsert}------------------ $response');
      print('Insert Data --------------$lastSync------------------ $deviceId');
      print('Insert Data -------------------------------- $response');
      bool hasUpdates = response.data['status'];
      log('Insert Data $hasUpdates $lastSync');
      if (hasUpdates) {
        // List suras = response.data['sura'];
        // List ayats = response.data['ayats'];
        // List word = response.data['word'];
        List articles = response.data['articles'];
        List tags = response.data['tags'];
        List reciters = response.data['reciters'];
        List languages = response.data['languages'];
        List videos = response.data['videos'];
        List videoCats = response.data['video_categories'];
        List relatedArticles = response.data['related_articles'];
        List tagWords = response.data['tag_words'];
        List relatedTags = response.data['related_tags'];
        // Suras
        // if (suras.isNotEmpty) {
        //   for (var x = 0; x < suras.length; x++) {
        //     SuraModel suraModel = SuraModel.fromJson(suras[x]);
        //     await DataBaseHelper.dataBaseInstance().insertSura(suraModel);
        //   }
        // }
        //
        // if (ayats.isNotEmpty) {
        //   for (var x = 0; x < ayats.length; x++) {
        //     AyaModel ayaModel = AyaModel.fromJson(ayats[x]);
        //     await DataBaseHelper.dataBaseInstance().insertAya(ayaModel);
        //   }
        // }
        // if (word.isNotEmpty) {
        //   for (var x = 0; x < word.length; x++) {
        //     DbWordModel wordModel = DbWordModel.fromJson(ayats[x]);
        //     await DataBaseHelper.dataBaseInstance().insertWord(wordModel);
        //   }
        // }
        print("syncStarted====================");

        // Articles
        if (articles.isNotEmpty) {
          for (var x = 0; x < articles.length; x++) {
            ArticleModel articleModel = ArticleModel.fromJson(articles[x]);
            await DataBaseHelper.dataBaseInstance().insertArticles(articleModel);
          }
        }
        print("syncStarted====================1");

        // Tags
        if (tags.isNotEmpty) {
          print("syncStarted====================1");

          for (var x = 0; x < tags.length; x++) {
            TagModel tagModel = TagModel.fromJson(tags[x]);
            await DataBaseHelper.dataBaseInstance().insertTags(tagModel);
          }
        }
        print("syncStarted====================2");

        // Reciters
        if (reciters.isNotEmpty) {
          for (var x = 0; x < reciters.length; x++) {
            ReciterModel reciterModel = ReciterModel.fromJson(reciters[x]);
            await DataBaseHelper.dataBaseInstance().insertReciters(reciterModel);
          }
        }
        print("syncStarted====================3");

        // Languages
        if (languages.isNotEmpty) {
          // for (var x = 0; x < languages.length; x++) {
          //   LanguageModel languageModel = LanguageModel.fromJson(languages[x]);
          //   var result =
          //   await DataBaseHelper.dataBaseInstance().updateSura(languageModel);
          //   print('updating Sura ${languageModel.id} $result}');
          // }
        }
        print("syncStarted====================4");

        //Videos Categories
        if (videoCats.isNotEmpty) {
          for (var x = 0; x < videoCats.length; x++) {
            VideoCategory videoCat = VideoCategory.fromJson(videoCats[x]);
            await DataBaseHelper.dataBaseInstance().insertVideoCats(videoCat);

            await AudioFolders().downloadIcon(videoCat.iconUrl!);
            // print('updating Videos ${videoModel.id} $حresult}');
          }
        }
        print("syncStarted====================5");

        //Videos
        if (videos.isNotEmpty) {
          for (var x = 0; x < videos.length; x++) {
            VideoModel videoModel = VideoModel.fromJson(videos[x]);
            await DataBaseHelper.dataBaseInstance().insertVideos(videoModel);
            // print('updating Videos ${videoModel.id} $result}');
          }
        }
        print("syncStarted====================6");

        // TODO
        // RelatedArticles
        if (relatedArticles.isNotEmpty) {
          for (var x = 0; x < relatedArticles.length; x++) {
            RelatedArticlesModel relatedArticlesModel = RelatedArticlesModel.fromJson(relatedArticles[x]);
            await DataBaseHelper.dataBaseInstance().insertRelatedArticles(relatedArticlesModel);
          }
        }
        print("syncStarted====================7");

        // tagWords
        if (tagWords.isNotEmpty) {
          for (var x = 0; x < tagWords.length; x++) {
            TagWordModel tagWordModel = TagWordModel.fromJson(tagWords[x]);
            await DataBaseHelper.dataBaseInstance().insertTagWords(tagWordModel);
          }
        }
        print("syncStarted====================8");

        // relatedTags
        if (relatedTags.isNotEmpty) {
          for (var x = 0; x < relatedTags.length; x++) {
            RelatedTagModel tagModel = RelatedTagModel.fromJson(relatedTags[x]);
            await DataBaseHelper.dataBaseInstance().insertRelatedTags(tagModel);
          }
        }
      }
      print("syncStarted====================9");

      _getUpdated();
      // _getDeleted();
    } else {
      print("syncStarted====================1111");
      await DataBaseHelper().videosCategories();
    }
  }

  static const String tag = 'SyncManager';

  // Updates
  void _getUpdated() async {
    print('$tag _getUpdated  $deviceId');

    if (!await AudioDownload().isInternetAvailable()) {
      return;
    }

    log('$tag _getUpdated $deviceId');
    // String deviceId = await _getId();
    var response = await _dio.get(_domainLink + _getUpdates, queryParameters: {_deviceKey: deviceId, 'date': lastSync});
    bool hasUpdates = response.data['status'];
    if (!hasUpdates) {
      return;
    }

    List suras = response.data['sura'];
    List ayats = response.data['ayats'];
    List word = response.data['word'];
    List articles = response.data['articles'];
    List tags = response.data['tags'];
    List reciters = response.data['reciters'];
    List languages = response.data['languages'];
    List videos = response.data['videos'];
    List? relatedArticles = response.data['related_articles'];
    List? tagWords = response.data['tag_words'];
    List? relatedTags = response.data['related_tags'];
    List? videoCats = response.data['video_categories'];

    // Suras
    if (suras.isNotEmpty) {
      for (var x = 0; x < suras.length; x++) {
        SuraModel suraModel = SuraModel.fromJson(suras[x]);
        await DataBaseHelper.dataBaseInstance().updateSura(suraModel);
      }
    }

    if (ayats.isNotEmpty) {
      for (var x = 0; x < ayats.length; x++) {
        AyaModel ayaModel = AyaModel.fromJson(ayats[x]);
        await DataBaseHelper.dataBaseInstance().updateAya(ayaModel);
      }
    }

    if (word.isNotEmpty) {
      log('Words length ${word.length}');
      for (var x = 0; x < word.length; x++) {
        log('currenty ${word[x]}');
        DbWordModel wordModel = DbWordModel.fromJson(word[x]);
        await DataBaseHelper.dataBaseInstance().updateWord(wordModel);
      }
    }

    // Articles
    if (articles.isNotEmpty) {
      for (var x = 0; x < articles.length; x++) {
        ArticleModel articleModel = ArticleModel.fromJson(articles[x]);
        await DataBaseHelper.dataBaseInstance().updateArticles(articleModel);
      }
    }
    // Tags
    if (tags.isNotEmpty) {
      for (var x = 0; x < tags.length; x++) {
        TagModel tagModel = TagModel.fromJson(tags[x]);
        await DataBaseHelper.dataBaseInstance().updateTags(tagModel);
      }
    }
    // Reciters
    if (reciters.isNotEmpty) {
      for (var x = 0; x < reciters.length; x++) {
        ReciterModel reciterModel = ReciterModel.fromJson(reciters[x]);
        await DataBaseHelper.dataBaseInstance().updateReciters(reciterModel);
      }
    }
    // Languages
    if (languages.isNotEmpty) {
      // for (var x = 0; x < languages.length; x++) {
      //   LanguageModel languageModel = LanguageModel.fromJson(languages[x]);
      //   var result =
      //   await DataBaseHelper.dataBaseInstance().updateSura(languageModel);
      //   print('updating Sura ${languageModel.id} $result}');
      // }
    }
    //Videos Cats
    if (videos.isNotEmpty) {
      for (var x = 0; x < videos.length; x++) {
        VideoModel videoModel = VideoModel.fromJson(videos[x]);
        await DataBaseHelper.dataBaseInstance().updateVideos(videoModel);
      }
    }

    if (videoCats!.isNotEmpty) {
      for (var x = 0; x < videoCats.length; x++) {
        VideoCategory videoCat = VideoCategory.fromJson(videoCats[x]);
        await DataBaseHelper.dataBaseInstance().updateVideoCats(videoCat);
        await AudioFolders().downloadIcon(videoCat.iconUrl!);
        // print('updating Videos ${videoModel.id} $result}');
      }
    }

    //Videos
    if (videos.isNotEmpty) {
      for (var x = 0; x < videos.length; x++) {
        VideoModel videoModel = VideoModel.fromJson(videos[x]);
        await DataBaseHelper.dataBaseInstance().updateVideos(videoModel);
      }
    }

    // TODO
    // RelatedArticles
    if (relatedTags != null) {
      if (relatedArticles!.isNotEmpty) {
        for (var x = 0; x < relatedArticles.length; x++) {
          RelatedArticlesModel relatedArticlesModel = RelatedArticlesModel.fromJson(relatedArticles[x]);
          DataBaseHelper.dataBaseInstance().updateRelatedArticles(relatedArticlesModel);
        }
      }

      // tagWords
      if (tagWords!.isNotEmpty) {
        for (var x = 0; x < tagWords.length; x++) {
          TagWordModel tagWordModel = TagWordModel.fromJson(tagWords[x]);
          await DataBaseHelper.dataBaseInstance().updateTagWords(tagWordModel);
        }
      }
      // relatedTags
      if (relatedTags.isNotEmpty) {
        for (var x = 0; x < relatedTags.length; x++) {
          RelatedTagModel tagModel = RelatedTagModel.fromJson(relatedTags[x]);
          await DataBaseHelper.dataBaseInstance().updateRelatedTags(tagModel);
        }
      }
    }
    _getDeleted();
  }

  // Deleted
  void _getDeleted() async {
    log('$tag _getDeleted  $deviceId');
    print('$tag _getDeleted  $deviceId');
    if (!await AudioDownload().isInternetAvailable()) {
      return;
    }
    var response = await _dio.get(_domainLink + _getDeletes, queryParameters: {_deviceKey: deviceId, 'date': lastSync});
    bool hasUpdates = response.data['status'];
    if (!hasUpdates) {
      return;
    }

    // List suras = response.data['sura'];
    // List ayats = response.data['ayats'];
    // List word = response.data['word'];
    List articles = response.data['articles'];
    List tags = response.data['tags'];
    List reciters = response.data['reciters'];
    List languages = response.data['languages'];
    List videos = response.data['videos'];
    List relatedArticles = response.data['related_articles'];
    List tagWords = response.data['tag_words'];
    List relatedTags = response.data['related_tags'];
    List videoCats = response.data['video_categories'];

    // Suras
    // if (suras.isNotEmpty) {
    //   for (var x = 0; x < suras.length; x++) {
    //     int suraModel = suras[x];
    //     var result =
    //         await DataBaseHelper.dataBaseInstance().deleteSura(suraModel);
    //     print('delete Sura $suraModel $result}');
    //   }
    // }

    // if (ayats.isNotEmpty) {
    //   for (var x = 0; x < ayats.length; x++) {
    //     int ayaId = ayats[x];
    //     var result =
    //         await DataBaseHelper.dataBaseInstance().deleteAya(ayaId);
    //     print('delete Aya $ayaId $result}');
    //   }
    // }
    // if (word.isNotEmpty) {
    //   for (var x = 0; x < word.length; x++) {
    //     int wordModel = word[x];
    //     var result =
    //         await DataBaseHelper.dataBaseInstance().deleteWord(wordModel);
    //     print('Delete Word $wordModel $result}');
    //   }
    // }

    // Articles
    if (articles.isNotEmpty) {
      for (var x = 0; x < articles.length; x++) {
        int articleModel = articles[x];
        await DataBaseHelper.dataBaseInstance().deleteArticles(articleModel);
      }
    }
    // Tags
    if (tags.isNotEmpty) {
      for (var x = 0; x < tags.length; x++) {
        int tagModel = tags[x];
        await DataBaseHelper.dataBaseInstance().deleteTags(tagModel);
      }
    }
    // Reciters
    if (reciters.isNotEmpty) {
      for (var x = 0; x < reciters.length; x++) {
        int reciterModel = reciters[x];
        await DataBaseHelper.dataBaseInstance().deleteReciters(reciterModel);
      }
    }
    // Languages
    if (languages.isNotEmpty) {
      // for (var x = 0; x < languages.length; x++) {
      //   LanguageModel languageModel = LanguageModel.fromJson(languages[x]);
      //   var result =
      //   await DataBaseHelper.dataBaseInstance().updateSura(languageModel);
      //   print('updating Sura ${languageModel.id} $result}');
      // }
    }

    if (videoCats.isNotEmpty) {
      for (var x = 0; x < videoCats.length; x++) {
        VideoCategory videoCat = VideoCategory.fromJson(videoCats[x]);
        await DataBaseHelper.dataBaseInstance().deleteVideoCats(videoCat.id!);
        // print('updating Videos ${videoModel.id} $result}');
      }
    }

    //Videos
    if (videos.isNotEmpty) {
      for (var x = 0; x < videos.length; x++) {
        int videoModel = videos[x];
        await DataBaseHelper.dataBaseInstance().deleteVideos(videoModel);
      }
    }

    // TODO
    // RelatedArticles
    if (relatedArticles.isNotEmpty) {
      for (var x = 0; x < relatedArticles.length; x++) {
        int relatedArticlesModel = relatedArticles[x];
        await DataBaseHelper.dataBaseInstance().deleteRelatedArticles(relatedArticlesModel);
      }
    }

    // tagWords
    if (tagWords.isNotEmpty) {
      for (var x = 0; x < tagWords.length; x++) {
        int tagWordModel = tagWords[x];
        await DataBaseHelper.dataBaseInstance().deleteTagWords(tagWordModel);
      }
    }
    // relatedTags
    if (relatedTags.isNotEmpty) {
      for (var x = 0; x < relatedTags.length; x++) {
        int tagModel = relatedTags[x];
        await DataBaseHelper.dataBaseInstance().deleteRelatedTags(tagModel);
      }
    }

    _endSync();
  }

  void _endSync() async {
    var response =
        await _dio.post(_domainLink + _confirmSync, queryParameters: {_deviceKey: deviceId, 'date': lastSync});
    bool hasUpdates = response.data['status'];
    log('End Sync Status $hasUpdates');
    print('End Sync Status $hasUpdates');
    updateSyncDate();
    syncStarted = false;
    setLoading(false);
  }

  Future<bool> isInternetAvailable() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   return true;
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   return true;
    // }
    // return false;
    return true;
  }
}
