import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:laqoo/request/api.dart';
import 'package:laqoo/request/request.dart';
import 'package:laqoo/plugins/plugins.dart';
import 'package:laqoo/modules/plugin/plugin_http_module.dart';

class PluginHTTP {
  static Future getPluginList() async {
    List<PluginHTTPItem> pluginHTTPItemList = [];
    try {
      var res = await Request().get('${Api.pluginShop}index.json');
      final jsonData = json.decode(res.data);
      // debugPrint('${jsonData.toString()}');
      for (dynamic pluginJsonItem in jsonData) {
        try {
          PluginHTTPItem pluginHTTPItem = PluginHTTPItem.fromJson(pluginJsonItem);
          pluginHTTPItemList.add(pluginHTTPItem);
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('获取插件仓库错误${e.toString()}');
    }
    return pluginHTTPItemList;
  }

  static Future<Plugin?> getPlugin(String name) async {
    Plugin? plugin;
    try {
      var res = await Request().get('${Api.pluginShop}$name.json');
      final jsonData = json.decode(res.data);
      plugin = Plugin.fromJson(jsonData);
    } catch(e) {
      debugPrint('获取插件 $name 错误 ${e.toString()}');
    }
    return plugin;
  }
}