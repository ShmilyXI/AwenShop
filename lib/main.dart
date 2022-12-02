import 'package:awenshop/routers/not_found_page.dart';
import 'package:awenshop/util/handle_error_utils.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:awenshop/setting/provider/theme_provider.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:awenshop/routers/routers.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
//  debugProfileBuildsEnabled = true;
//  debugPaintLayerBordersEnabled = true;
//  debugProfilePaintsEnabled = true;
//  debugRepaintRainbowEnabled = true;

  /// 确保初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  /// 去除URL中的“#”(hash)，仅针对Web。默认为setHashUrlStrategy
  /// 注意本地部署和远程部署时`web/index.html`中的base标签，https://github.com/flutter/flutter/issues/69760
  setPathUrlStrategy();

  /// sp初始化
  await SpUtil.getInstance();

  /// 1.22 预览功能: 在输入频率与显示刷新率不匹配情况下提供平滑的滚动效果
  // GestureBinding.instance?.resamplingEnabled = true;
  /// 异常处理
  handleError(() => runApp(MyApp()));

  /// 隐藏状态栏。为启动页、引导页设置。完成后修改回显示状态栏。
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  // TODO(weilu): 启动体验不佳。状态栏、导航栏在冷启动开始的一瞬间为黑色，且无法通过隐藏、修改颜色等方式进行处理。。。
  // 相关问题跟踪：https://github.com/flutter/flutter/issues/73351
}

class MyApp extends StatelessWidget {
  MyApp({super.key, this.home, this.theme}) {
    Routes.initRoutes();
  }
  final Widget? home;
  final ThemeData? theme;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Widget app = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, ThemeProvider provider, __) {
          return _buildMaterialApp(provider);
        },
      ),
    );

    /// Toast 配置
    return OKToast(
        backgroundColor: Colors.black54, textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), radius: 20.0, position: ToastPosition.bottom, child: app);
  }

  @override
  Widget _buildMaterialApp(
    ThemeProvider provider,
  ) {
    return MaterialApp(
      title: 'test title',
      theme: theme ?? provider.getTheme(),
      darkTheme: provider.getTheme(isDarkMode: true),
      themeMode: provider.getThemeMode(),
      initialRoute: '/login',
      home: home,
      navigatorKey: navigatorKey,
      // 注册路由表
      onGenerateRoute: Routes.router.generator,
      // 因为使用了fluro，这里设置主要针对Web
      onUnknownRoute: (_) {
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => const NotFoundPage(),
        );
      },
      builder: (BuildContext context, Widget? child) {
        // 保证文字大小不受手机系统设置影响 https://www.kikt.top/posts/flutter/layout/dynamic-text/
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      restorationScopeId: 'app',
    );
  }
}
