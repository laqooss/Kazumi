﻿import 'package:flutter/material.dart';
import 'package:laqoo/request/api.dart';
import 'package:laqoo/pages/about/about_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:laqoo/pages/logs/logs_page.dart';

class AboutModule extends Module {
  @override
  void binds(i) {
    
  }

  @override
  void routes(r) {
    r.child("/", child: (_) => const AboutPage());
    r.child("/logs", child: (_) => const LogsPage());
    r.child("/license",
        child: (_) => const LicensePage(
              applicationName: 'LaQoo',
              applicationVersion: Api.version,
              applicationLegalese: '开源许可证',
            ),
        transition: TransitionType.noTransition);
  }
}

