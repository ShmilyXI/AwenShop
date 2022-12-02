import 'package:awenshop/util/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:keyboard_actions/keyboard_actions_item.dart';

class Utils {
  static KeyboardActionsConfig getKeyboardActionsConfig(BuildContext context, List<FocusNode> list) {
    return KeyboardActionsConfig(
      keyboardBarColor: ThemeUtils.getKeyboardActionsColor(context),
      actions: List.generate(
          list.length,
          (i) => KeyboardActionsItem(
                focusNode: list[i],
                toolbarButtons: [
                  (node) {
                    return GestureDetector(
                      onTap: () => node.unfocus(),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Text('关闭'),
                      ),
                    );
                  },
                ],
              )),
    );
  }
}

/// String 空安全处理
extension StringExtension on String? {
  String get nullSafe => this ?? '';
}
