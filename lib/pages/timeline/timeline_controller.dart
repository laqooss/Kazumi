﻿import 'package:laqoo/modules/bangumi/bangumi_item.dart';
import 'package:laqoo/request/bangumi.dart';
import 'package:laqoo/utils/anime_season.dart';
import 'package:mobx/mobx.dart';

part 'timeline_controller.g.dart';

class TimelineController = _TimelineController with _$TimelineController;

abstract class _TimelineController with Store {
  @observable
  List<List<BangumiItem>> bangumiCalendar = [];

  @observable
  String seasonString = '';

  DateTime selectedDate = DateTime.now();

  Future getSchedules() async {
    bangumiCalendar = await BangumiHTTP.getCalendar();
  }

  Future getSchedulesBySeason() async {
    bangumiCalendar = await BangumiHTTP.getCalendarBySearch(AnimeSeason(selectedDate).toSeasonStartAndEnd());
  }
}
