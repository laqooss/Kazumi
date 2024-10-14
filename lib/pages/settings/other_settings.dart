﻿import 'package:laqoo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:laqoo/bean/settings/settings.dart';
import 'package:provider/provider.dart';
import 'package:laqoo/pages/menu/menu.dart';
import 'package:laqoo/pages/menu/side_menu.dart';
import 'package:laqoo/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:laqoo/bean/appbar/sys_app_bar.dart';

class OtherSettingsPage extends StatefulWidget {
  const OtherSettingsPage({super.key});

  @override
  State<OtherSettingsPage> createState() => _OtherSettingsPageState();
}

class _OtherSettingsPageState extends State<OtherSettingsPage> {
  dynamic navigationBarState;
  Box setting = GStorage.setting;
  late dynamic enableGitProxy;

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
    enableGitProxy =
        setting.get(SettingBoxKey.enableGitProxy, defaultValue: false);
  }

  void onBackPressed(BuildContext context) {
    navigationBarState.showNavigate();
    // Navigator.of(context).pop();
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
      child: const Scaffold(
        appBar: SysAppBar(title: Text('其他设置')),
        body: Column(
          children: [
            InkWell(
              child: SetSwitchItem(
                title: '隐身模式',
                subTitle: '不保留观看记录',
                setKey: SettingBoxKey.privateMode,
                defaultVal: false,
              ),
            ),
            InkWell(
              child: SetSwitchItem(
                title: '自动更新',
                setKey: SettingBoxKey.autoUpdate,
                defaultVal: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


