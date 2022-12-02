import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:AwenShop/login/widgets/base_text_field.dart';
import 'package:AwenShop/res/resources.dart';
import 'package:AwenShop/routers/fluro_navigator.dart';
import 'package:AwenShop/util/change_notifier_manage.dart';
import 'package:AwenShop/util/other_utils.dart';
import 'package:AwenShop/util/toast_utils.dart';
import 'package:AwenShop/widgets/base_app_bar.dart';
import 'package:AwenShop/widgets/base_button.dart';
import 'package:AwenShop/widgets/base_scroll_view.dart';

import '../login_router.dart';

/// design/1注册登录/index.html#artboard4
class SMSLoginPage extends StatefulWidget {
  const SMSLoginPage({super.key});

  @override
  _SMSLoginPageState createState() => _SMSLoginPageState();
}

class _SMSLoginPageState extends State<SMSLoginPage> with ChangeNotifierMixin<SMSLoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vCodeController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false;

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _phoneController: callbacks,
      _vCodeController: callbacks,
      _nodeText1: null,
      _nodeText2: null,
    };
  }

  void _verify() {
    final String phone = _phoneController.text;
    final String vCode = _vCodeController.text;
    bool clickable = true;
    if (phone.isEmpty || phone.length < 11) {
      clickable = false;
    }
    if (vCode.isEmpty || vCode.length < 6) {
      clickable = false;
    }
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _login() {
    Toast.show('去登录......');
  }

  Future<bool> _getVCode() {
    final String phone = _phoneController.text;
    if (phone.isEmpty || phone.length < 11) {
      Toast.show("请输入有效的手机号");
      return Future<bool>.value(false);
    }
    Toast.show('获取验证码......');
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(),
      body: BaseScrollView(
        keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1, _nodeText2]),
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: _buildBody(),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      const Text(
        '验证码登录',
        style: TextStyles.textBold26,
      ),
      Gaps.vGap16,
      BaseTextField(
        focusNode: _nodeText1,
        controller: _phoneController,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        hintText: '请输入手机号',
      ),
      Gaps.vGap8,
      BaseTextField(focusNode: _nodeText2, controller: _vCodeController, maxLength: 6, keyboardType: TextInputType.number, hintText: "请输入验证码", getVCode: _getVCode),
      Gaps.vGap8,
      Container(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text: "提示：未注册账号的手机号，请先",
            style: Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: Dimens.font_sp14),
            children: <TextSpan>[
              TextSpan(
                text: "注册",
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    NavigatorUtils.push(context, LoginRouter.registerPage);
                  },
              ),
            ],
          ),
        ),
      ),
      Gaps.vGap24,
      BaseButton(
        onPressed: _clickable ? _login : null,
        text: "登录",
      ),
      Container(
        height: 40.0,
        alignment: Alignment.centerRight,
        child: GestureDetector(
          child: Text(
            "忘记密码",
            style: Theme.of(context).textTheme.subtitle2,
          ),
          onTap: () => NavigatorUtils.push(context, LoginRouter.resetPasswordPage),
        ),
      )
    ];
  }
}
