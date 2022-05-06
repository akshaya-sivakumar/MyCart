import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mycart/resources/utilities/cart_secure_store.dart';
import 'package:mycart/ui/widgets/text_widget.dart';

class AppScaffold extends StatefulWidget {
  final Widget? body;
  final FloatingActionButtonLocation? floatingLocation;
  final Widget? title;
  final Widget? bottomappbar, bottom;
  const AppScaffold(
      {Key? key,
      this.body,
      this.title,
      this.bottomappbar,
      this.floatingLocation,
      this.bottom})
      : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  String? userName, profile, dob;
  @override
  void initState() {
    super.initState();
    getUserdeatil();
  }

  getUserdeatil() async {
    userName = await CartSecureStore.getSecureStore(CartSecureStore.userName);
    profile = await CartSecureStore.getSecureStore(CartSecureStore.profile);
    dob = await CartSecureStore.getSecureStore(CartSecureStore.dob);
    setState(() {});
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: widget.bottom == null,
          title: (widget.title),
          actions: [
            Row(
              children: [
                Text(userName != "" ? capitalize(userName ?? "-") : ""),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context, userName, dob),
                    );
                  },
                  icon: profile != ""
                      ? Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(File(profile ?? "")))))
                      : Image.asset(
                          "lib/assets/profile.png",
                          color: Colors.black,
                        ),
                )
              ],
            )
          ],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(widget.bottom != null ? 40 : 0),
              child: widget.bottom ?? Container()),
        ),
        body: widget.body,
        floatingActionButtonLocation: widget.floatingLocation,
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(width: 300, child: widget.bottomappbar),
        ),
      ),
    );
  }

  Widget _buildPopupDialog(
      BuildContext context, String? userName, dateOfBirth) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('User Detail'),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                size: 20,
              ))
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          profile != ""
              ? Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(File(profile ?? "")))))
              : Image.asset(
                  "lib/assets/profile.png",
                  width: 80,
                  color: Colors.black,
                ),
          Table(
            children: [
              tableRowdata("UserName",
                  userName != "" ? capitalize(userName ?? "-") : ""),
              tableRowdata("Date Of Birth", dob)
            ],
          ),
        ],
      ),
      actions: <Widget>[
        Center(
          child: ElevatedButton.icon(
              onPressed: () async {
                await CartSecureStore.deleteSecureStore(
                    CartSecureStore.userName);

                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              icon: const Icon(Icons.logout),
              label: const TextWidget(text: "Logout")),
        ),
      ],
    );
  }

  TableRow tableRowdata(String title, data) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextWidget(text: title, fontWeight: FontWeight.bold),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextWidget(text: data),
      ),
    ]);
  }
}
