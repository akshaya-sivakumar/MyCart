import 'package:flutter/material.dart';
import 'package:mycart/resources/utilities/cart_secure_store.dart';

class AppScaffold extends StatefulWidget {
  final Widget? body;
  final FloatingActionButtonLocation? floatingLocation;
  final Widget? title;
  final Widget? bottomappbar, bottom;
  AppScaffold(
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
  String? userName, profile;
  @override
  void initState() {
    super.initState();
    getUserdeatil();
  }

  getUserdeatil() async {
    userName = await CartSecureStore.getSecureStore(CartSecureStore.userName);
    profile = await CartSecureStore.getSecureStore(CartSecureStore.profile);
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  @override
  Widget build(BuildContext context) {
    print(userName);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: widget.bottom == null,
          title: (widget.title),
          actions: [
            Row(
              children: [
                Text(userName ?? ""),
                PopupMenuButton<int>(
                    icon: Image.asset(
                      "lib/assets/profile.png",
                      color: Colors.black,
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                          new PopupMenuItem<int>(
                              value: 1, child: new Text('Logout')),
                        ],
                    onSelected: (int value) async {
                      if (value == 1) {
                        await CartSecureStore.deleteSecureStore(
                            CartSecureStore.userName);

                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    }),
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
}
