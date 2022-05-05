import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mycart/bloc/user_bloc/user_bloc.dart';
import 'package:mycart/model/login_request.dart';
import 'package:mycart/ui/widgets/textform_widget.dart';
import 'package:mycart/ui/widgets/toast_widget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late UserBloc userBloc;
  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context)
      ..stream.listen((state) {
        if (state is LoginFailed) print(state.message.toString());
        //FlutterToast.showToast(state.message.toString(), color: Colors.red);
        if (state is LoginSuccess) {
          FlutterToast.showToast("Login Successfully", color: Colors.green);
          Navigator.pushNamed(context, "/cartList");
        }
      });
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                  prefixIcon: const Icon(Icons.person)),
              TextFormWidget(
                  title: "Password",
                  controller: passwordController,
                  prefixIcon: const Icon(Icons.lock)),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<UserBloc>().add(LoginEvent(LoginRequest(
                          userName: usernameController.text,
                          passWord: passwordController.text,
                        )));
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
    );
  }
}
