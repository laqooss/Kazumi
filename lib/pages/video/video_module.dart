import 'package:laqoo/pages/video/video_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:laqoo/pages/webview/webview_controller.dart';
import 'package:laqoo/pages/player/player_controller.dart';

class VideoModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const VideoPage());
  }

  @override
  void binds(i) {
    i.addSingleton(PlayerController.new);
    i.addSingleton(WebviewItemControllerFactory.getController);
  }
}
