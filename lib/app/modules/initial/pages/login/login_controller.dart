import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:bunnie/app/app_controller.dart';
import 'package:bunnie/app/shared/models/user.dart';
import 'package:bunnie/app/shared/repositories/bunnie_api_repository.dart';
import 'package:asuka/asuka.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final api = Modular.get<BunnieApiRepository>();
  final app = Modular.get<AppController>();

  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @action
  login(startLoading, stopLoading, btnState) async {
    if (btnState == ButtonState.Busy) return;

    if (!(formKey.currentState?.validate() ?? false)) return;

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    User user = User(
      username: usernameCtrl.text,
      password: passwordCtrl.text,
    );

    startLoading();
    final result = await api.signIn(user);
    stopLoading();

    if (result.isRight()) {
      app.user = result.getOrElse(() => User());

      Modular.to.navigate('/app');
    } else {
      showSnackBar(AsukaSnackbar.alert('You cannot login'));
    }
  }

  @action
  loginWithGoogle() {
    Modular.to.navigate('/app');
  }

  @action
  loginWithFacebook() {}

  @action
  register() {
    Modular.to.navigate('/register');
  }

  @action
  recovery() {}
}
