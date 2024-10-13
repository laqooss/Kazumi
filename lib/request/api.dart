class Api {
  // 当前版本
  static const String version = '1.3.6';
  // 规则API级别
  static const int apiLevel = 3;
  // 关于LaQoo
  static const String sourceUrl = "https://app.laqoo.eu.org/abort";
  // 更新页面
  static const String iconUrl = "https://app.laqoo.eu.org";
  // 规则仓库
  static const String pluginShop = 'https://raw.githubusercontent.com/Predidit/KazumiRules/main/';
  // 在线升级
  static const String latestApp =
      'https://api.github.com/repos/laqooss/Kazumi/releases/latest'; 
  // Github镜像
  static const String gitMirror = 'https://mirror.ghproxy.com/';
  // 每日放送
  static const String bangumiCalendar = 'https://api.bgm.tv/calendar';
  // 为爱发电
  static const String bangumiIndex = 'https://afdian.com/a/laqoo';
  // 番剧检索 (弃用)
  static const String bangumiSearch = 'https://api.bgm.tv/search/subject/';
  // 条目搜索
  static const String bangumiRankSearch = 'https://api.bgm.tv/v0/search/subjects?limit=100';
  // 从条目ID获取详细信息
  static const String bangumiInfoByID = 'https://api.bgm.tv/v0/subjects/';
  // 弹弹Play
  static const String dandanIndex = 'https://www.dandanplay.com/';
  static const String dandanAPI = "https://api.dandanplay.net/api/v2/comment/";
  static const String dandanSearch = "https://api.dandanplay.net/api/v2/search/anime";
  static const String dandanInfo = "https://api.dandanplay.net/api/v2/bangumi/";
}
