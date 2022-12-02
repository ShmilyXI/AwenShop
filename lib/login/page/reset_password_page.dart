import 'package:flutter/material.dart';
import 'package:AwenShop/login/widgets/base_text_field.dart';
import 'package:AwenShop/res/resources.dart';
import 'package:AwenShop/util/change_notifier_manage.dart';
import 'package:AwenShop/util/other_utils.dart';
import 'package:AwenShop/util/toast_utils.dart';
import 'package:AwenShop/widgets/base_app_bar.dart';
import 'package:AwenShop/widgets/base_button.dart';
import 'package:AwenShop/widgets/base_scroll_view.dart';

/// design/1注册登录/index.html#artboard9
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> with ChangeNotifierMixin<ResetPasswordPage> {
  //定义一个controller
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
    final String name = _phoneController.text;
    final String vCode = _vCodeController.text;
    final String password = _passwordController.text;
    bool clickable = true;
    if (name.isEmpty || name.length < 11) {
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

  void _reset() {
    Toast.show('确认');
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
        title: "忘记密码",
      ),
      body: BaseScrollView(
        keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[_nodeText1, _nodeText2, _nodeText3]),
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: _buildBody(),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      const Text(
        "忘记密码",
        style: TextStyles.textBold26,
      ),
      Gaps.vGap16,
      BaseTextField(
        focusNode: _nodeText1,
        controller: _phoneController,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        hintText: "请输入手机号",
      ),
      Gaps.vGap8,
      BaseTextField(
        focusNode: _nodeText2,
        controller: _vCodeController,
        keyboardType: TextInputType.number,
        getVCode: _getVCode,
        maxLength: 6,
        hintText: "请输入验证码",
      ),
      Gaps.vGap8,
      BaseTextField(
        focusNode: _nodeText3,
        isInputPwd: true,
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        hintText: "请输入新密码",
      ),
      Gaps.vGap24,
      BaseButton(
        onPressed: _clickable ? _reset : null,
        text: "确认",
      )
    ];
  }
}
