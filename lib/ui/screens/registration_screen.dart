import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:mycart/bloc/user_bloc/user_bloc.dart';
import 'package:mycart/ui/widgets/textform_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycart/ui/widgets/toast_widget.dart';

import '../../model/user_model.dart';
import '../widgets/loader_widget.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool obscure = true;
  late UserBloc userBloc;
  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context)
      ..stream.listen((state) {
        if (state is UserAdded) {
          LoaderWidget()
              .showLoader(context, text: "Please wait", showLoader: false);
          FlutterToast.showToast("User Registered Successfully",
              color: Colors.green);
          Navigator.of(context).pushReplacementNamed("/");
        }
        if (state is UserAddFail) {
          LoaderWidget()
              .showLoader(context, text: "Please wait", showLoader: false);
          FlutterToast.showToast(state.message, color: Colors.red[900]);
        }
      });
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _images;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03),
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
                                    : Container(
                                        width: 120.0,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: FileImage(
                                                    File(_images!.path))))))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _images == null
                                ? "Upload Profile Picture"
                                : "Change Profile Image",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                TextFormWidget(
                  title: "Username",
                  controller: usernameController,
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) {
                    if (usernameController.text.trim().isEmpty) {
                      return "Please Enter the username";
                    }
                    return null;
                  },
                ),
                TextFormWidget(
                    title: "Password",
                    controller: passwordController,
                    obscure: obscure,
                    suffixiconButton: IconButton(
                        onPressed: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                        icon: Icon(
                            obscure ? Icons.visibility_off : Icons.visibility)),
                    validator: (value) {
                      if ((value?.length ?? 0) < 6) {
                        return "Password should be greater then 5 character";
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.lock)),
                TextFormWidget(
                  title: "Date Of Birth",
                  controller: dateOfBirthController,
                  readOnly: true,
                  validator: (value) {
                    if (dateOfBirthController.text.trim().isEmpty) {
                      return "Please select date";
                    }
                    return null;
                  },
                  suffixiconButton: IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: selectDob,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        LoaderWidget().showLoader(context,
                            text: "Please wait", showLoader: true);
                        context.read<UserBloc>().add(UserAddEvent(User(
                            userName: usernameController.text,
                            passWord: passwordController.text,
                            dateOfBirth: dateOfBirthController.text,
                            profile: _images != null ? _images!.path : "")));
                        /*    Navigator.push(
                          context, MaterialPageRoute(builder: (_) => HomePage())); */
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
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
