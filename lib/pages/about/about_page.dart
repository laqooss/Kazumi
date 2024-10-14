import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:laqoo/pages/my/my_controller.dart';
import 'package:laqoo/request/api.dart';
import 'package:laqoo/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:laqoo/bean/appbar/sys_app_bar.dart';
import 'package:laqoo/pages/menu/menu.dart';
import 'package:laqoo/pages/menu/side_menu.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  dynamic navigationBarState;
  late dynamic defaultDanmakuArea;
  late dynamic defaultThemeMode;
  late dynamic defaultThemeColor;
  double _cacheSizeMB = -1;
  final MyController myController = Modular.get<MyController>();

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
    _getCacheSize();
  }

  void onBackPressed(BuildContext context) {
    navigationBarState.showNavigate();
  }

  Future<void> _getCacheSize() async {
    Directory tempDir = await getTemporaryDirectory();
    Directory cacheDir = Directory('${tempDir.path}/libCachedImageData');

    if (await cacheDir.exists()) {
      int totalSizeBytes = await _getTotalSizeOfFilesInDir(cacheDir);
      double totalSizeMB = (totalSizeBytes / (1024 * 1024));

      if (mounted) {
        setState(() {
          _cacheSizeMB = totalSizeMB;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _cacheSizeMB = 0.0;
        });
      }
    }
  }

  Future<int> _getTotalSizeOfFilesInDir(final Directory directory) async {
    final List<FileSystemEntity> children = directory.listSync();
    int total = 0;

    try {
      for (final FileSystemEntity child in children) {
        if (child is File) {
          final int length = await child.length();
          total += length;
        } else if (child is Directory) {
          total += await _getTotalSizeOfFilesInDir(child);
        }
      }
    } catch (_) {}
    return total;
  }

  Future<void> _clearCache() async {
    final cacheManager = DefaultCacheManager();
    await cacheManager.emptyCache();
    _getCacheSize();
  }

  void _showCacheDialog() {
    SmartDialog.show(
      useAnimation: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('缓存管理'),
          content: const Text('缓存为番剧封面, 清除后加载时需要重新下载,确认要清除缓存吗?'),
          actions: [
            TextButton(
              onPressed: () {
                SmartDialog.dismiss();
              },
              child: Text(
                '取消',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  _clearCache();
                } catch (_) {}
                SmartDialog.dismiss();
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationBarState.hideNavigate();
    });
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        onBackPressed(context);
      },
      child: Scaffold(
        appBar: const SysAppBar(title: Text('关于')),
        // backgroundColor: Colors.transparent,
        body: Column(
          children: [
            ListTile(
              title: const Text('关于此应用'),
              subtitle: Text('查看个性化来源',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
              onTap: () {
                Modular.to.pushNamed('/tab/my/about/license');
              },
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse(Api.sourceUrl),
                    mode: LaunchMode.externalApplication);
              },
              dense: false,
              title: const Text('更新页面'),
              trailing: Text('Update',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse(Api.bangumiIndex),
                    mode: LaunchMode.externalApplication);
              },
              dense: false,
              title: const Text('为爱发电'),
              trailing: Text('LaQoo',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse(Api.dandanIndex),
                    mode: LaunchMode.externalApplication);
              },
              dense: false,
              title: const Text('弹幕来源'),
              trailing: Text('DanDanPlay',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              onTap: () {
                Modular.to.pushNamed('/tab/my/about/logs');
              },
              dense: false,
              title: const Text('错误日志'),
            ),
            ListTile(
              onTap: () {
                _showCacheDialog();
              },
              dense: false,
              title: const Text('清除缓存'),
              trailing: _cacheSizeMB == -1
                  ? const Text('统计中...')
                  : Text('${_cacheSizeMB.toStringAsFixed(2)}MB',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              onTap: () {
                myController.checkUpdata();
              },
              dense: false,
              title: const Text('检查更新'),
              trailing: Text('当前版本 ${Api.version}',
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
