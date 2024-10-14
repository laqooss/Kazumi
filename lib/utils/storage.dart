import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:laqoo/modules/bangumi/bangumi_item.dart';
import 'package:laqoo/modules/history/history_module.dart';

class GStorage {
  static late Box<BangumiItem> favorites;
  static late Box<History> histories;
  static late final Box<dynamic> setting;

  static Future init() async {
    Hive.registerAdapter(BangumiItemAdapter());
    Hive.registerAdapter(ProgressAdapter());
    Hive.registerAdapter(HistoryAdapter());
    favorites = await Hive.openBox('favorites');
    histories = await Hive.openBox('histories');
    setting = await Hive.openBox('setting');
  }

  static Future<void> backupBox(String boxName, String backupFilePath) async {
    final appDocumentDir = await getApplicationSupportDirectory();
    final hiveBoxFile = File('${appDocumentDir.path}/hive/$boxName.hive');
    if (await hiveBoxFile.exists()) {
      await hiveBoxFile.copy(backupFilePath);
      print('Backup success: $backupFilePath');
    } else {
      print('Hive box not exists');
    }
  }

  /// 弃用
  static Future<void> restoreHistory(String backupFilePath) async {
    final appDocumentDir = await getApplicationSupportDirectory();
    final backupFile = File(backupFilePath);
    final hiveBoxFile = File('${appDocumentDir.path}/hive/histories.hive');
    final hiveBoxLockFile = File('${appDocumentDir.path}/hive/histories.lock');
    await histories.close();
    try {
      await hiveBoxFile.delete();
      try {
        await hiveBoxLockFile.delete();
      } catch (_) {}
      await backupFile.copy(hiveBoxFile.path);
    } catch (e) {
      print('Hive box restore error: $e');
    }
    histories = await Hive.openBox('histories');
  }

  static Future<void> patchHistory(String backupFilePath) async {
    final backupFile = File(backupFilePath);
    final backupContent = await backupFile.readAsBytes();
    final tempBox = await Hive.openBox('tempHistoryBox', bytes: backupContent);
    final tempBoxItems = tempBox.toMap().entries;

    for (var tempBoxItem in tempBoxItems) {
      if (histories.get(tempBoxItem.key) != null) {
        if (histories
            .get(tempBoxItem.key)!
            .lastWatchTime
            .isBefore(tempBoxItem.value.lastWatchTime)) {
          await histories.delete(tempBoxItem.key);
          await histories.put(tempBoxItem.key, tempBoxItem.value);
        }
      } else {
        await histories.put(tempBoxItem.key, tempBoxItem.value);
      }
    }
    await tempBox.close();
  }

  static Future<void> patchFavorites(String backupFilePath) async {
    final backupFile = File(backupFilePath);
    final backupContent = await backupFile.readAsBytes();
    final tempBox = await Hive.openBox('tempFavoritesBox', bytes: backupContent);
    final tempBoxItems = tempBox.toMap().entries;
    debugPrint('webDav追番列表长度 ${tempBoxItems.length}');

    await favorites.clear();
    for (var tempBoxItem in tempBoxItems) {
      await favorites.put(tempBoxItem.key, tempBoxItem.value);
    }
    await tempBox.close();
  }

  // 阻止实例化
  GStorage._();
}

class SettingBoxKey {
  static const String hAenable = 'hAenable',
      searchEnhanceEnable = 'searchEnhanceEnable',
      autoUpdate = 'autoUpdate',
      alwaysOntop = 'alwaysOntop',
      defaultPlaySpeed = 'defaultPlaySpeed',
      danmakuEnhance = 'danmakuEnhance',
      danmakuBorder = 'danmakuBorder',
      danmakuOpacity = 'danmakuOpacity',
      danmakuFontSize = 'danmakuFontSize',
      danmakuTop = 'danmakuTop',
      danmakuScroll = 'danmakuScroll',
      danmakuBottom = 'danmakuBottom',
      danmakuMassive = 'danmakuMassive',
      danmakuArea = 'danmakuArea',
      danmakuColor = 'danmakuColor',
      danmakuEnabledByDefault = 'danmakuEnabledByDefault',
      danmakuBiliBiliSource = 'danmakuBiliBiliSource',
      danmakuGamerSource = 'danmakuGamerSource',
      danmakuDanDanSource = 'danmakuDanDanSource',
      themeMode = 'themeMode',
      themeColor = 'themeColor',
      privateMode = 'privateMode',
      autoPlay = 'autoPlay',
      playResume = 'playResume',
      oledEnhance = 'oledEnhance',
      displayMode = 'displayMode',
      enableGitProxy = 'enableGitProxy',
      enableSystemProxy = 'enableSystemProxy',
      isWideScreen = 'isWideScreen',
      webDavEnable = 'webDavEnable',
      webDavEnableFavorite = 'webDavEnableFavorite',
      webDavURL = 'webDavURL',
      webDavUsername = 'webDavUsername',
      webDavPassword = 'webDavPasswd',
      lowMemoryMode = 'lowMemoryMode';
}
