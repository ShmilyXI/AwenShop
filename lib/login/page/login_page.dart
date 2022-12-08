import 'package:AwenShop/login/login_router.dart';
import 'package:AwenShop/login/widgets/base_text_field.dart';
import 'package:AwenShop/res/constant.dart';
import 'package:AwenShop/res/gaps.dart';
import 'package:AwenShop/routers/fluro_navigator.dart';
import 'package:AwenShop/store/store_router.dart';
import 'package:AwenShop/util/other_utils.dart';
import 'package:AwenShop/widgets/base_app_bar.dart';
import 'package:AwenShop/widgets/base_button.dart';
import 'package:AwenShop/widgets/base_scroll_view.dart';
import 'package:AwenShop/util/change_notifier_manage.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:sp_util/sp_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ChangeNotifierMixin<LoginPage> {
  // 定义输入值controller
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _clickable = false; // 是否可点击

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    print("changeNotifier");
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _phoneController: callbacks,
      _passwordController: callbacks,
      _nodeText1: null,
      _nodeText2: null,
    };
  }

  @override
  void initState() {
    print("initState");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 显示状态栏和导航栏
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
    _phoneController.text = SpUtil.getString(Constant.phone).nullSafe;
  }

  void _verify() {
    final String name = _phoneController.text;
    final String password = _passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }

    /// 状态不一样再刷新，避免不必要的setState
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _login() {
    SpUtil.putString(Constant.phone, _phoneController.text);
    NavigatorUtils.push(context, StoreRouter.auditPage);
    print("登陆...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        isBack: false,
        actionName: '短信登录',
        onPressed: () {
          NavigatorUtils.push(context, LoginRouter.smsLoginPage);
        },
      ),
      body: BaseScrollView(
        keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1, _nodeText2]),
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: _buildBody,
      ),
    );
  }

  List<Widget> get _buildBody => <Widget>[
        const Text(
          '密码登录',
          style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
        ),
        Gaps.vGap16,
        BaseTextField(key: const Key('phone'), controller: _phoneController, focusNode: _nodeText1, maxLength: 11, keyboardType: TextInputType.phone, hintText: '请输入手机号'),
        Gaps.vGap8,
        BaseTextField(
          key: const Key('password'),
          keyName: 'password',
          focusNode: _nodeText2,
          isInputPwd: true,
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          hintText: '请输入密码',
        ),
        Gaps.vGap24,
        BaseButton(
          key: const Key('login'),
          onPressed: _clickable ? _login : null,
          text: '登录',
        ),
        Container(
          height: 40.0,
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: (() => NavigatorUtils.push(context, LoginRouter.resetPasswordPage)),
            child: Text('忘记密码', key: const Key('forgotPassword'), style: Theme.of(context).textTheme.subtitle2),
          ),
        ),
        Gaps.vGap16,
        Container(
            alignment: Alignment.center,
            child: GestureDetector(
                child: Text('还没账号？前往注册', key: const Key('noAccountRegister'), style: TextStyle(color: Theme.of(context).primaryColor)),
                onTap: () => NavigatorUtils.push(
                      context,
                      LoginRouter.registerPage,
                    ))),
      ];
}
