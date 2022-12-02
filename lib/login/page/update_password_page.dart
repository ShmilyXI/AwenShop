import 'package:flutter/material.dart';
import 'package:awenshop/login/widgets/base_text_field.dart';
import 'package:awenshop/res/resources.dart';
import 'package:awenshop/routers/fluro_navigator.dart';
import 'package:awenshop/util/change_notifier_manage.dart';
import 'package:awenshop/util/other_utils.dart';
import 'package:awenshop/util/toast_utils.dart';
import 'package:awenshop/widgets/base_app_bar.dart';
import 'package:awenshop/widgets/base_button.dart';
import 'package:awenshop/widgets/base_scroll_view.dart';

/// design/1注册登录/index.html#artboard13
class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> with ChangeNotifierMixin<UpdatePasswordPage> {
  //定义一个controller
  final TextEditingController _oldPwdController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _oldPwdController: callbacks,
      _newPwdController: callbacks,
      _nodeText1: null,
      _nodeText2: null,
    };
  }

  void _verify() {
    final String oldPwd = _oldPwdController.text;
    final String newPwd = _newPwdController.text;
    bool clickable = true;
    if (oldPwd.isEmpty || oldPwd.length < 6) {
      clickable = false;
    }
    if (newPwd.isEmpty || newPwd.length < 6) {
      clickable = false;
    }
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _confirm() {
    Toast.show('修改成功！');
    NavigatorUtils.goBack(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: '修改密码',
      ),
      body: BaseScrollView(
        keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1, _nodeText2]),
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: <Widget>[
          const Text(
            '重置登录密码',
            style: TextStyles.textBold26,
          ),
          Gaps.vGap8,
          Text(
            '设置账号 15000000000',
            style: Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: Dimens.font_sp12),
          ),
          Gaps.vGap32,
          BaseTextField(
            isInputPwd: true,
            focusNode: _nodeText1,
            controller: _oldPwdController,
            keyboardType: TextInputType.visiblePassword,
            hintText: '请确认旧密码',
          ),
          Gaps.vGap8,
          BaseTextField(
            isInputPwd: true,
            focusNode: _nodeText2,
            controller: _newPwdController,
            keyboardType: TextInputType.visiblePassword,
            hintText: '请输入新密码',
          ),
          Gaps.vGap24,
          BaseButton(
            onPressed: _clickable ? _confirm : null,
            text: '确认',
          )
        ],
      ),
    );
  }
}
