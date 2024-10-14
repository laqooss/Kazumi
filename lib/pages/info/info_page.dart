import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:laqoo/pages/info/info_controller.dart';
import 'package:laqoo/bean/card/bangumi_info_card.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:laqoo/plugins/plugins_controller.dart';
import 'package:laqoo/pages/video/video_controller.dart';
import 'package:laqoo/pages/popular/popular_controller.dart';
import 'package:laqoo/bean/card/network_img_layer.dart';
import 'package:laqoo/bean/appbar/sys_app_bar.dart';
import 'package:laqoo/request/query_manager.dart';
import 'package:logger/logger.dart';
import 'package:laqoo/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>
    with SingleTickerProviderStateMixin {
  final InfoController infoController = Modular.get<InfoController>();
  final VideoPageController videoPageController =
      Modular.get<VideoPageController>();
  final PluginsController pluginsController = Modular.get<PluginsController>();
  final PopularController popularController = Modular.get<PopularController>();
  late TabController tabController;

  /// Concurrent query manager
  late QueryManager queryManager;

  @override
  void initState() {
    super.initState();
    if (infoController.bangumiItem.summary == '') {
      queryBangumiSummaryByID(infoController.bangumiItem.id);
    }
    queryManager = QueryManager();
    queryManager.querySource(popularController.keyword);
    tabController =
        TabController(length: pluginsController.pluginList.length, vsync: this);
  }

  @override
  void dispose() {
    queryManager.cancel();
    videoPageController.currentEspisode = 1;
    super.dispose();
  }

  /// workaround for bangumi calendar api
  /// bangumi calendar api always return empty summary
  queryBangumiSummaryByID(int id) async {
    try {
      await infoController.queryBangumiSummaryByID(id);
      setState(() {});
    } catch (e) {
      LaQooLogger().log(Level.error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationBarState.hideNavigate();
    });
    debugPrint('status 数组长度为 ${infoController.pluginSearchStatus.length}');
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        onBackPressed(context);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: const SysAppBar(),
          body: Column(
            children: [
              BangumiInfoCardV(bangumiItem: infoController.bangumiItem),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                controller: tabController,
                tabs: pluginsController.pluginList
                    .map((plugin) => Observer(
                          builder: (context) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                plugin.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 5.0),
                              Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: infoController.pluginSearchStatus[
                                              plugin.name] ==
                                          'success'
                                      ? Colors.green
                                      : (infoController.pluginSearchStatus[
                                                  plugin.name] ==
                                              'pending')
                                          ? Colors.grey
                                          : Colors.red,
                                  // color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
                  Expanded(
                    child: Observer(
                      builder: (context) => TabBarView(
                        controller: tabController,
                        children: List.generate(
                            pluginsController.pluginList.length, (pluginIndex) {
                          var plugin =
                              pluginsController.pluginList[pluginIndex];
                          var cardList = <Widget>[];
                          for (var searchResponse
                              in infoController.pluginSearchResponseList) {
                            if (searchResponse.pluginName == plugin.name) {
                              for (var searchItem in searchResponse.data) {
                                cardList.add(Card(
                                  color: Colors.transparent,
                                  child: ListTile(
                                    tileColor: Colors.transparent,
                                    title: Text(searchItem.name),
                                    onTap: () async {
                                      SmartDialog.showLoading(msg: '获取中');
                                      videoPageController.currentPlugin =
                                          plugin;
                                      videoPageController.title =
                                          searchItem.name;
                                      videoPageController.src = searchItem.src;
                                      try {
                                        await infoController.queryRoads(
                                            searchItem.src, plugin.name);
                                        SmartDialog.dismiss();
                                        Modular.to.pushNamed('/video/');
                                      } catch (e) {
                                        LaQooLogger()
                                            .log(Level.error, e.toString());
                                        SmartDialog.dismiss();
                                  }
                                },
                              ),
                            ));
                          }
                        }
                      }
                      return ListView(children: cardList);
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
