﻿import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:laqoo/utils/utils.dart';
import 'package:laqoo/bean/settings/settings.dart';
import 'package:laqoo/utils/storage.dart';
import 'package:laqoo/utils/webdav.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:laqoo/pages/menu/menu.dart';
import 'package:laqoo/pages/menu/side_menu.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:laqoo/bean/appbar/sys_app_bar.dart';

class WebDavSettingsPage extends StatefulWidget {
  const WebDavSettingsPage({super.key});

  @override
  State<WebDavSettingsPage> createState() => _PlayerSettingsPageState();
}

class _PlayerSettingsPageState extends State<WebDavSettingsPage> {
  dynamic navigationBarState;
  Box setting = GStorage.setting;

  @override
  void initState() {
    super.initState();
    if (Utils.isCompact()) {
      navigationBarState =
          Provider.of<NavigationBarState>(context, listen: false);
    } else {
      navigationBarState =
          Provider.of<SideNavigationBarState>(context, listen: false);
    }
  }

  void onBackPressed(BuildContext context) {
    navigationBarState.showNavigate();
  }

  checkWebDav() async {
    var webDavURL =
        await setting.get(SettingBoxKey.webDavURL, defaultValue: '');
    if (webDavURL == '') {
      await setting.put(SettingBoxKey.webDavEnable, false);
      SmartDialog.showToast('未找到有效的webdav配置');
      return;
    }
    try {
      SmartDialog.showToast('尝试从WebDav同步');
      var webDav = WebDav();
      await webDav.downloadHistory();
      SmartDialog.showToast('同步成功');
    } catch (e) {
      if (e.toString().contains('Error: Not Found')) {
        SmartDialog.showToast('配置成功, 这是一个不存在已有同步文件的全新WebDav');
      } else {
        SmartDialog.showToast('同步失败 ${e.toString()}');
      }
    }
  }

  updateWebdav() async {
    var webDavEnable =
        await setting.get(SettingBoxKey.webDavEnable, defaultValue: false);
    if (webDavEnable) {
      try {
        SmartDialog.showToast('尝试上传到WebDav');
        var webDav = WebDav();
        await webDav.updateHistory();
        SmartDialog.showToast('同步成功');
      } catch (e) {
        SmartDialog.showToast('同步失败 ${e.toString()}');
      }
    } else {
      SmartDialog.showToast('未开启WebDav同步或配置无效');
    }
  }

  downloadWebdav() async {
    var webDavEnable =
        await setting.get(SettingBoxKey.webDavEnable, defaultValue: false);
    if (webDavEnable) {
      try {
        SmartDialog.showToast('尝试从WebDav同步');
        var webDav = WebDav();
        await webDav.downloadHistory();
        SmartDialog.showToast('同步成功');
      } catch (e) {
        SmartDialog.showToast('同步失败 ${e.toString()}');
      }
    } else {
      SmartDialog.showToast('未开启WebDav同步或配置无效');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationBarState.hideNavigate();
    });
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        onBackPressed(context);
      },
      child: Scaffold(
        appBar: const SysAppBar(title: Text('同步设置')),
        body: Column(
          children: [
            InkWell(
              child: SetSwitchItem(
                title: 'WEBDAV同步',
                subTitle: '使用WEBDAV自动同步观看记录',
                setKey: SettingBoxKey.webDavEnable,
                callFn: (val) {
                  if (val) {
                    checkWebDav();
                  }
                },
                defaultVal: false,
              ),
            ),
            ListTile(
              onTap: () async {
                Modular.to.pushNamed('/tab/my/webdav/editor');
              },
              dense: false,
              title: Text(
                'WEBDAV配置',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
            ),
            ListTile(
              onTap: () {
                updateWebdav();
              },
              dense: false,
              title: const Text('手动上传'),
              subtitle: Text('立即上传观看记录到WEBDAV',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              onTap: () {
                downloadWebdav();
              },
              dense: false,
              title: const Text('手动下载'),
              subtitle: Text('立即下载观看记录到本地',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
          ],
        ),
      ),
    );
  }
}

}
