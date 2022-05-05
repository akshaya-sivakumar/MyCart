part of 'user_bloc.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {}

class UserLoad extends UserState {}

class UserAdded extends UserState {}

class LoginSuccess extends UserState {}

class LoginFailed extends UserState {
  final String message;

  LoginFailed(this.message);
}
