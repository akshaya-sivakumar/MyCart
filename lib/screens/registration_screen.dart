import 'package:flutter/material.dart';
import 'package:mycart/screens/widgets/textform_widget.dart';
import 'package:intl/intl.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
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
              TextFormWidget(
                title: "Date Of Birth",
                controller: dateOfBirthController,
                suffixiconButton: IconButton(
                  icon: Icon(Icons.edit_calendar),
                  onPressed: selectDob,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ElevatedButton(
                  onPressed: () {
                    /*    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => HomePage())); */
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 20),
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

  void selectDob() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (dateOfBirthController.text != "")
            ? DateTime.parse(dateOfBirthController.text)
            : DateTime.now(),
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now());
    if (picked != null)
      dateOfBirthController.text = DateFormat("yyyy-MM-dd").format(picked);
  }
}
