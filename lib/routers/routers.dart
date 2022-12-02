import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:AwenShop/login/login_router.dart';
import 'package:AwenShop/home/home_page.dart';
import 'package:AwenShop/routers/base_router.dart';
import 'package:AwenShop/routers/not_found_page.dart';
import 'package:AwenShop/home/webview_page.dart';

class Routes {
  static String home = "/home"; // 首页
  static String webViewPage = '/webView';

  static final List<BaseRouterProvider> _listRouter = [];
  static final FluroRouter router = FluroRouter();

  static void initRoutes() {
    // 指定路由跳转错误返回页
    router.notFoundHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      debugPrint("未找到目标页");
      return const NotFoundPage();
    });

    router.define(home, handler: Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) => const HomePage()));

    router.define(webViewPage, handler: Handler(handlerFunc: (_, params) {
      final String title = params['title']?.first ?? '';
      final String url = params['url']?.first ?? '';
      return WebViewPage(title: title, url: url);
    }));

    _listRouter.clear();

    /// 各自路由由各自模块管理，统一在此添加初始化
    _listRouter.add(LoginRouter());

    // 初始化路由
    void initRouter(BaseRouterProvider routerProvider) {
      routerProvider.initRouter(router);
    }

    _listRouter.forEach(initRouter);
  }
}
