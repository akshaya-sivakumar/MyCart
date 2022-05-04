import 'package:flutter/material.dart';
import 'package:mycart/screens/widgets/textform_widget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                  prefixIcon: Icon(Icons.person)),
              TextFormWidget(
                  title: "Password",
                  controller: passwordController,
                  prefixIcon: Icon(Icons.lock)),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/cartList");
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
