import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

// 本项目通用的布局（SingleChildScrollView）
// 1.底部存在按钮
// 2.底部没有按钮

class BaseScrollView extends StatelessWidget {
  const BaseScrollView({
    super.key,
    required this.children,
    this.padding, // 内边距
    this.physics = const BouncingScrollPhysics(), // 弹性滚动
    this.crossAxisAlignment = CrossAxisAlignment.start, // 默认左对齐
    this.bottomButton, // 底部按钮
    this.keyboardConfig, // 键盘处理
    this.tapOutsideToDismiss = false, // 键盘外部按下将其关闭
    this.overScroll = 16.0,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics physics;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? bottomButton;
  final KeyboardActionsConfig? keyboardConfig;
  // 键盘外部按下将其关闭
  final bool tapOutsideToDismiss;
  // 默认弹起位置在TextField的文字下面，可以添加此属性继续向上滑动一段距离。用来露出完整的TextField。
  final double overScroll;

  @override
  Widget build(BuildContext context) {
    Widget contents = Column(crossAxisAlignment: crossAxisAlignment, children: children);

    if (defaultTargetPlatform == TargetPlatform.iOS && keyboardConfig != null) {
      // ios键盘处理
      if (padding != null) {
        contents = Padding(padding: padding!, child: contents);
      }

      contents = KeyboardActions(
        isDialog: bottomButton != null, // 判断是否在dialog中使用
        overscroll: overScroll, // 额外滚动距离,如果文本框还有其他内容需要显示
        config: keyboardConfig!,
        tapOutsideBehavior: tapOutsideToDismiss ? TapOutsideBehavior.opaqueDismiss : TapOutsideBehavior.none, // 外部点击行为
        child: contents,
      );
    } else {
      contents = SingleChildScrollView(
        padding: padding,
        physics: physics,
        child: contents,
      );
    }

    if (bottomButton != null) {
      contents = Column(
        children: <Widget>[
          Expanded(
            child: contents,
          ),
          SafeArea(child: bottomButton!)
        ],
      );
    }
    return contents;
  }
}
