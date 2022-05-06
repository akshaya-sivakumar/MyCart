import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import 'package:mycart/bloc/user_bloc/user_bloc.dart';
import 'package:mycart/model/login_request.dart';
import 'package:mycart/ui/widgets/loader_widget.dart';
import 'package:mycart/ui/widgets/textform_widget.dart';
import 'package:mycart/ui/widgets/toast_widget.dart';
import 'package:flutter/services.dart';

import '../../resources/utilities/cart_secure_store.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  String _authorized = 'Not Authorized';
  late UserBloc userBloc;
  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context)
      ..stream.listen((state) {
        if (state is LoginFailed) {
          FlutterToast.showToast(state.message.toString(), color: Colors.red);

          LoaderWidget()
              .showLoader(context, text: "Please wait", showLoader: false);
        }
        //FlutterToast.showToast(state.message.toString(), color: Colors.red);
        if (state is LoginSuccess) {
          LoaderWidget()
              .showLoader(context, text: "Please wait", showLoader: false);
          FlutterToast.showToast("Login Successfully", color: Colors.green);
          Navigator.pushNamed(context, "/cartList");
        }
      });
    biometriclogin();
  }

  Future<void> biometriclogin() async {
    var userName =
        await CartSecureStore.getSecureStore(CartSecureStore.userName);
    if (userName != "" ) {
      await _checkBiometrics();
      if (_canCheckBiometrics ?? false) {
     
        await _authenticate();
        if (_authorized == "Authorized") {
          FlutterToast.showToast("Welcome $userName");
          Navigator.of(context).pushNamed("/cartList");
        }
      }
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: SizedBox(
                        width: 200,
                        height: 150,
                        /*decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50.0)),*/
                        child: Icon(
                          Icons.shopping_cart_checkout,
                          size: 100,
                          color: Theme.of(context).primaryColor,
                        )),
                  ),
                ),
                TextFormWidget(
                    title: "Username",
                    controller: usernameController,
                    validator: (value) {
                      if (usernameController.text.trim().isEmpty) {
                        return "Please Enter the username";
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.person)),
                TextFormWidget(
                    title: "Password",
                    controller: passwordController,
                    validator: (value) {
                      if ((value?.length ?? 0) < 6) {
                        return "Password should be greater then 5 character";
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.lock)),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        LoaderWidget().showLoader(context,
                            text: "Please wait", showLoader: true);
                        context.read<UserBloc>().add(LoginEvent(LoginRequest(
                              userName: usernameController.text,
                              passWord: passwordController.text,
                            )));
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 130,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/registration");
                    },
                    child: const Text('New User? Create Account'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException {
      canCheckBiometrics = false;
    
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
      });
    } on PlatformException catch (e) {
    
      setState(() {
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }


}

