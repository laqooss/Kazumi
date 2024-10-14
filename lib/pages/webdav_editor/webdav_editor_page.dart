import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:laqoo/utils/storage.dart';
import 'package:laqoo/bean/appbar/sys_app_bar.dart';
import 'package:laqoo/utils/webdav.dart';

class WebDavEditorPage extends StatefulWidget {
  const WebDavEditorPage({
    super.key,
  });

  @override
  State<WebDavEditorPage> createState() => _WebDavEditorPageState();
}

class _WebDavEditorPageState extends State<WebDavEditorPage> {
  final TextEditingController webDavURLController = TextEditingController();
  final TextEditingController webDavUsernameController =
      TextEditingController();
  final TextEditingController webDavPasswordController =
      TextEditingController();
  Box setting = GStorage.setting;

  @override
  void initState() {
    super.initState();
    webDavURLController.text =
        setting.get(SettingBoxKey.webDavURL, defaultValue: '');
    webDavUsernameController.text =
        setting.get(SettingBoxKey.webDavUsername, defaultValue: '');
    webDavPasswordController.text =
        setting.get(SettingBoxKey.webDavPassword, defaultValue: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SysAppBar(
        title: Text('WEBDAV编辑'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: webDavURLController,
              decoration: const InputDecoration(labelText: 'URL'),
            ),
            TextField(
              controller: webDavUsernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: webDavPasswordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            // const SizedBox(height: 20),
            // ExpansionTile(
            //   title: const Text('高级选项'),
            //   children: [],
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          setting.put(SettingBoxKey.webDavURL, webDavURLController.text);
          setting.put(SettingBoxKey.webDavUsername, webDavUsernameController.text);
          setting.put(SettingBoxKey.webDavPassword, webDavPasswordController.text);
          var webDav = WebDav();
          try {
            await webDav.init();
          } catch (e) {
            SmartDialog.showToast('配置失败 ${e.toString()}');
            await setting.put(SettingBoxKey.webDavEnable, false);
            return;
          }
          SmartDialog.showToast('配置成功, 开始测试');
          try {
            await webDav.ping();
            SmartDialog.showToast('测试成功');
          } catch (e) {
            SmartDialog.showToast('测试失败 ${e.toString()}');
            await setting.put(SettingBoxKey.webDavEnable, false);
          }
        },
      ),
    );
  }
}
