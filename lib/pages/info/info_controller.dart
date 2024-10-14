import 'package:laqoo/modules/bangumi/bangumi_item.dart';
import 'package:laqoo/plugins/plugins_controller.dart';
import 'package:laqoo/pages/video/video_controller.dart';
import 'package:laqoo/plugins/plugins.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:laqoo/modules/search/plugin_search_module.dart';
import 'package:laqoo/request/bangumi.dart';
import 'package:mobx/mobx.dart';
import 'package:logger/logger.dart';
import 'package:laqoo/utils/logger.dart';

part 'info_controller.g.dart';

class InfoController = _InfoController with _$InfoController;

abstract class _InfoController with Store {
  late BangumiItem bangumiItem;

  @observable
  var pluginSearchResponseList = ObservableList<PluginSearchResponse>();

  @observable
  var pluginSearchStatus = ObservableMap<String, String>();

  /// 移动到 query_manager.dart 以解决可能的内存泄漏
  // querySource(String keyword) async {
  //   final PluginsController pluginsController =
  //       Modular.get<PluginsController>();
  //   pluginSearchResponseList.clear();

  //   for (Plugin plugin in pluginsController.pluginList) {
  //     pluginSearchStatus[plugin.name] = 'pending';
  //   }

  //   var controller = StreamController();
  //   for (Plugin plugin in pluginsController.pluginList) {
  //     plugin.queryBangumi(keyword).then((result) {
  //       pluginSearchStatus[plugin.name] = 'success';
  //       controller.add(result);
  //     }).catchError((error) {
  //       pluginSearchStatus[plugin.name] = 'error';
  //     });
  //   }
  //   await for (var result in controller.stream) {
  //     pluginSearchResponseList.add(result);
  //   }
  // }

  queryBangumiSummaryByID(int id) async {
    await BangumiHTTP.getBangumiSummaryByID(id).then((value) {
      bangumiItem.summary = value;
    });
  }

  queryRoads(String url, String pluginName) async {
    final PluginsController pluginsController =
        Modular.get<PluginsController>();
    final VideoPageController videoPageController =
        Modular.get<VideoPageController>();
    videoPageController.roadList.clear();
    for (Plugin plugin in pluginsController.pluginList) {
      if (plugin.name == pluginName) {
        videoPageController.roadList
            .addAll(await plugin.querychapterRoads(url));
      }
    }
    LaQooLogger()
        .log(Level.info, '播放列表长度 ${videoPageController.roadList.length}');
    LaQooLogger().log(
        Level.info, '第一播放列表选集数 ${videoPageController.roadList[0].data.length}');
  }
}

}
}
