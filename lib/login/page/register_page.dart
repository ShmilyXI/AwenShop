import 'package:flutter/material.dart';
import 'package:awenshop/login/widgets/base_text_field.dart';
import 'package:awenshop/res/resources.dart';
import 'package:awenshop/util/change_notifier_manage.dart';
import 'package:awenshop/util/other_utils.dart';
import 'package:awenshop/util/toast_utils.dart';
import 'package:awenshop/widgets/base_app_bar.dart';
import 'package:awenshop/widgets/base_button.dart';
import 'package:awenshop/widgets/base_scroll_view.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with ChangeNotifierMixin<RegisterPage> {
  // 定义controller
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  bool _clickable = false;

  @override
  Map<ChangeNotifier, List<VoidCallback>?>? changeNotifier() {
    final List<VoidCallback> callbacks = <VoidCallback>[_verify];
    return <ChangeNotifier, List<VoidCallback>?>{
      _phoneController: callbacks,
      _vCodeController: callbacks,
      _passwordController: callbacks,
      _nodeText1: null,
      _nodeText2: null,
      _nodeText3: null,
    };
  }

  void _verify() {
    final String phone = _phoneController.text;
    final String vCode = _vCodeController.text;
    final String password = _passwordController.text;
    bool clickable = true;
    if (phone.isEmpty || phone.length < 11) {
      clickable = false;
    }
    if (vCode.isEmpty || vCode.length < 6) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }

  void _register() {
    Toast.show('注册');
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
        appBar: const BaseAppBar(
          title: "注册",
        ),
        body: BaseScrollView(
          keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1, _nodeText2, _nodeText3]),
          crossAxisAlignment: CrossAxisAlignment.center,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ));
  }

  List<Widget> _buildBody() {
    return <Widget>[
      const Text(
        "开启你的账号",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
      ),
      Gaps.vGap16,
      BaseTextField(
        controller: _phoneController,
        key: const Key('phone'),
        focusNode: _nodeText1,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        hintText: "请输入手机号",
      ),
      Gaps.vGap8,
      BaseTextField(
        controller: _vCodeController,
        key: const Key('vCode'),
        focusNode: _nodeText2,
        getVCode: _getVCode,
        maxLength: 6,
        keyboardType: TextInputType.number,
        hintText: "请输入验证码",
      ),
      Gaps.vGap8,
      BaseTextField(
        controller: _passwordController,
        key: const Key('password'),
        focusNode: _nodeText3,
        keyboardType: TextInputType.visiblePassword,
        isInputPwd: true,
        hintText: "请输入密码",
      ),
      Gaps.vGap24,
      BaseButton(
        key: const Key('register'),
        text: "注册",
        onPressed: _clickable ? _register : null,
      ),
    ];
  }
}
