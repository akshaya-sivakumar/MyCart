import 'package:flutter/material.dart';
import 'package:mycart/bloc/products_bloc/products_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycart/ui/screens/add_item.dart';
import 'package:mycart/ui/screens/cart_list.dart';
import 'package:mycart/ui/screens/login_screen.dart';
import 'package:mycart/ui/screens/registration_screen.dart';

import '../bloc/user_bloc/user_bloc.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => UserBloc(),
                  child: const Login(),
                ));
      case '/registration':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => UserBloc(),
                  child: const Registration(),
                ));
      case '/addItem':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ProductsBloc(),
                  child: AddItem(args: args as AddItemArgs),
                ));
      case '/cartList':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ProductsBloc(),
                  child: const CartList(),
                ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text('HomePage'),
        ),
      );
    });
  }
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, Object? arg) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arg);
  }
}
