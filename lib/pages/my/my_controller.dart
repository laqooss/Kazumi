import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:laqoo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:laqoo/request/api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';
import 'package:laqoo/utils/logger.dart';

class MyController {
  Future<bool> checkUpdata({String type = 'manual'}) async {
    Utils.latest().then((value) {
      if (Api.version == value) {
        if (type == 'manual') {
          SmartDialog.showToast('当前已经是最新版本！');
        }
      } else {
        SmartDialog.show(
          animationType: SmartAnimationType.centerFade_otherSlide,
          builder: (context) {
            return AlertDialog(
              title: Text('发现新版本 $value'),
              actions: [
                TextButton(
                  onPressed: () => SmartDialog.dismiss(),
                  child: Text(
                    '稍后',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      launchUrl(Uri.parse("${Api.sourceUrl}/releases/latest")),
                  child: const Text('Github'),
                ),
              ],
            );
          },
        );
      }
    }).catchError((err) {
      LaQooLogger().log(Level.error, '检查更新失败 ${err.toString()}');
      if (type == 'manual') {
        SmartDialog.showToast('当前是最新版本！');
      }
    });
    return true;
  }
}
