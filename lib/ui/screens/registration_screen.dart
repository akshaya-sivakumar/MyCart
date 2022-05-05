import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:mycart/bloc/user_bloc/user_bloc.dart';
import 'package:mycart/ui/widgets/textform_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycart/ui/widgets/toast_widget.dart';

import '../../model/user_model.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late UserBloc userBloc;
  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context)
      ..stream.listen((state) {
        if (state is UserAdded) {
          FlutterToast.showToast("User Registered Successfully",
              color: Colors.green);
          Navigator.of(context).pushReplacementNamed("/");
        }
      });
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _images;
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
              /*  Padding(
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
              ), */
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                          width: 200,
                          height: 150,
                          /*decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50.0)),*/
                          child: InkWell(
                              onTap: () {
                                loadPicker(ImageSource.gallery);
                              },
                              child: _images == null
                                  ? Image.asset("lib/assets/profile.png")
                                  : ClipOval(
                                      child: SizedBox.fromSize(
                                          size: Size.fromRadius(
                                              48), // Image radius
                                          child:
                                              Image.file(File(_images!.path))),
                                    ))),
                      Text("Upload Profile Picture")
                    ],
                  ),
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
              TextFormWidget(
                title: "Date Of Birth",
                controller: dateOfBirthController,
                readOnly: true,
                suffixiconButton: IconButton(
                  icon: const Icon(Icons.edit_calendar),
                  onPressed: selectDob,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<UserBloc>().add(UserAddEvent(User(
                        userName: usernameController.text,
                        passWord: passwordController.text,
                        dateOfBirth: dateOfBirthController.text,
                        profile: _images!.path)));
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
                    Navigator.of(context).pushReplacementNamed("/");
                  },
                  child: const Text('Already have account? Login'))
            ],
          ),
        ),
      ),
    );
  }

  loadPicker(ImageSource source) async {
    XFile? cameraFile;
    if (source == ImageSource.gallery) {
      cameraFile = await _picker.pickImage(source: source, imageQuality: 100);
    } else {
      cameraFile = await _picker.pickImage(
          source: source, imageQuality: 100, maxHeight: 1800, maxWidth: 1800);
    }

    if (cameraFile != null) {
      setState(() {
        _images = XFile(cameraFile!.path);
      });
    }
  }

  void selectDob() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (dateOfBirthController.text != "")
            ? DateTime.parse(dateOfBirthController.text)
            : DateTime.now(),
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now());
    if (picked != null) {
      dateOfBirthController.text = DateFormat("yyyy-MM-dd").format(picked);
    }
  }
}
