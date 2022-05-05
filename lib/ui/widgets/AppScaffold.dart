import 'package:flutter/material.dart';

class AppScaffold extends StatefulWidget {
  final Widget? body;
  final FloatingActionButtonLocation? floatingLocation;
  final Widget? title;
  final Widget? floatingButton;
  AppScaffold(
      {Key? key,
      this.body,
      this.title,
      this.floatingButton,
      this.floatingLocation})
      : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: (widget.title)),
      body: widget.body,
      floatingActionButton: widget.floatingButton,
      floatingActionButtonLocation: widget.floatingLocation,
    );
  }
}
