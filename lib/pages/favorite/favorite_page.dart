import 'package:laqoo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:laqoo/utils/constans.dart';
import 'package:laqoo/pages/menu/menu.dart';
import 'package:laqoo/pages/menu/side_menu.dart';
import 'package:laqoo/bean/card/bangumi_card.dart';
import 'package:laqoo/pages/favorite/favorite_controller.dart';
import 'package:laqoo/bean/appbar/sys_app_bar.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FavoriteController favoriteController =
      Modular.get<FavoriteController>();
  dynamic navigationBarState;

  void onBackPressed(BuildContext context) {
    navigationBarState.updateSelectedIndex(0);
    Modular.to.navigate('/tab/popular/');
  }

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

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (didPop) {
              return;
            }
            onBackPressed(context);
          },
          child: Scaffold(
            appBar: const SysAppBar(title: Text('追番')),
            body: favoriteController.favorites.isEmpty
                ? const Center(
                    child: Text('呃（⊙.⊙） 你还没有追番呢'),
                  )
                : CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(StyleString.cardSpace),
                        sliver: contentGrid(favoriteController.favorites, orientation),
                      ),
                    ],
                  ),
          ),
        );
      }
    );
  }

  Widget contentGrid(List bangumiList, Orientation orientation) {
    int crossCount = orientation != Orientation.portrait ? 6 : 3;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: StyleString.cardSpace - 2,
        crossAxisSpacing: StyleString.cardSpace,
        crossAxisCount: crossCount,
        mainAxisExtent: MediaQuery.of(context).size.width / crossCount / 0.65 +
            MediaQuery.textScalerOf(context).scale(32.0),
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (bangumiList.isNotEmpty) {
            return BangumiCardV(bangumiItem: bangumiList[index]);
          } else {
            return Container(); // 返回一个空容器以避免返回 null
          }
        },
        childCount: bangumiList.isNotEmpty ? bangumiList.length : 10,
      ),
    );
  }
}
