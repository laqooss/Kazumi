﻿import 'dart:io';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:laqoo/utils/storage.dart';
import 'package:logger/logger.dart';
import 'package:laqoo/utils/logger.dart';

class WebDav {
  late String webDavURL;
  late String webDavUsername;
  late String webDavPassword;
  late Directory webDavLocalTempDirectory;
  late webdav.Client client;

  WebDav._internal();
  static final WebDav _instance = WebDav._internal();
  factory WebDav() => _instance;

  Future init() async {
    var directory = await getApplicationSupportDirectory();
    webDavLocalTempDirectory = Directory('${directory.path}/webdavTemp'); 
    Box setting = GStorage.setting;
    webDavURL = setting.get(SettingBoxKey.webDavURL, defaultValue: '');
    webDavUsername =
        setting.get(SettingBoxKey.webDavUsername, defaultValue: '');
    webDavPassword =
        setting.get(SettingBoxKey.webDavPassword, defaultValue: '');
    client = webdav.newClient(
      webDavURL,
      user: webDavUsername,
      password: webDavPassword,
      debug: false,
    );
    client.setHeaders({'accept-charset': 'utf-8'});
    try {
      // LaQooLogger().log(Level.warning, 'webDav backup diretory not exists, creating');
      await client.mkdir('/laqooSync');
      LaQooLogger().log(Level.info, 'webDav backup diretory create success');
    } catch (_) {
      LaQooLogger().log(Level.error, 'webDav backup diretory create failed');
    }
  }

  Future update(String boxName) async {
    var directory = await getApplicationSupportDirectory();
    try {
      await client.remove('/laqooSync/$boxName.tmp.cache');
    } catch (_) {}
    await client.writeFromFile('${directory.path}/hive/$boxName.hive', '/laqooSync/$boxName.tmp.cache',
        onProgress: (c, t) {
      // print(c / t);
    });
    try {
      await client.remove('/laqooSync/$boxName.tmp');
    } catch (_) {
      LaQooLogger().log(Level.warning, 'webDav former backup file not exist');
    }
    await client.rename(
        '/laqooSync/$boxName.tmp.cache', '/laqooSync/$boxName.tmp', true);
  }

  Future updateHistory() async {
    await update('histories');
  }

  Future updateFavorite() async {
    await update('favorites');
  }

  Future downloadHistory() async {
    String fileName = 'histories.tmp';
    if (!await webDavLocalTempDirectory.exists()) {
      await webDavLocalTempDirectory.create(recursive: true);
    }
    final existingFile = File('${webDavLocalTempDirectory.path}/$fileName');
    if (await existingFile.exists()) {
      await existingFile.delete();
    }
    await client.read2File('/laqooSync/$fileName', existingFile.path,
        onProgress: (c, t) {
      // print(c / t);
    });
    await GStorage.patchHistory(existingFile.path); 
  }
  
  Future downloadFavorite() async {
    String fileName = 'favorites.tmp';
    if (!await webDavLocalTempDirectory.exists()) {
      await webDavLocalTempDirectory.create(recursive: true);
    }
    final existingFile = File('${webDavLocalTempDirectory.path}/$fileName');
    if (await existingFile.exists()) {
      await existingFile.delete();
    }
    await client.read2File('/laqooSync/$fileName', existingFile.path,
        onProgress: (c, t) {
      // print(c / t);
    });
    await GStorage.patchFavorites(existingFile.path); 
  }

  Future ping() async {
    await client.ping();
  }
}

);
  }
}
