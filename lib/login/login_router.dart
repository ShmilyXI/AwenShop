import 'package:fluro/fluro.dart';
import 'package:awenshop/routers/base_router.dart';
import "page/login_page.dart";
import "page/sms_login_page.dart";
import "page/reset_password_page.dart";
import "page/register_page.dart";
import 'page/update_password_page.dart';

class LoginRouter implements BaseRouterProvider {
  static String loginPage = '/login';
  static String smsLoginPage = '/smsLogin';
  static String resetPasswordPage = '/resetPassword';
  static String registerPage = '/register';
  static String updatePasswordPage = '/login/updatePassword';

  @override
  void initRouter(FluroRouter router) {
    router.define(loginPage, handler: Handler(handlerFunc: (_, __) => const LoginPage()));
    router.define(smsLoginPage, handler: Handler(handlerFunc: (_, __) => const SMSLoginPage()));
    router.define(resetPasswordPage, handler: Handler(handlerFunc: (_, __) => const ResetPasswordPage()));
    router.define(registerPage, handler: Handler(handlerFunc: (_, __) => const RegisterPage()));
    router.define(updatePasswordPage, handler: Handler(handlerFunc: (_, __) => const UpdatePasswordPage()));
  }
}
