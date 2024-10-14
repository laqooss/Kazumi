import 'package:laqoo/pages/index_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:laqoo/pages/router.dart';
import 'package:laqoo/pages/init_page.dart';
import 'package:flutter/material.dart';
import 'package:laqoo/pages/popular/popular_controller.dart';
import 'package:laqoo/pages/info/info_controller.dart';
import 'package:laqoo/plugins/plugins_controller.dart';
import 'package:laqoo/pages/video/video_controller.dart';
import 'package:laqoo/pages/timeline/timeline_controller.dart';
import 'package:laqoo/pages/favorite/favorite_controller.dart';
import 'package:laqoo/pages/my/my_controller.dart';
import 'package:laqoo/pages/history/history_controller.dart';
import 'package:laqoo/pages/video/video_module.dart';
import 'package:laqoo/pages/info/info_module.dart';

class IndexModule extends Module {
  @override
  List<Module> get imports => menu.moduleList;

  @override
  void binds(i) {
    i.addSingleton(PopularController.new);
    i.addSingleton(InfoController.new);
    i.addSingleton(PluginsController.new);
    i.addSingleton(VideoPageController.new);
    i.addSingleton(TimelineController.new);
    i.addSingleton(FavoriteController.new);
    i.addSingleton(HistoryController.new);
    i.addSingleton(MyController.new);
  }

  @override
  void routes(r) {
    r.child("/",
        child: (_) => const InitPage(),
        children: [
          ChildRoute(
            "/error",
            child: (_) => Scaffold(
              appBar: AppBar (title: const Text("LaQoo")),
              body: const Center(child: Text("初始化失败")),
            ),
          ),
        ],
        transition: TransitionType.noTransition);
    r.child("/tab", child: (_) {
      return const IndexPage();
    }, children: menu.routes, transition: TransitionType.noTransition);
    r.module("/video", module: VideoModule());
    r.module("/info", module: InfoModule());
  }
}
