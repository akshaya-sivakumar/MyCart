part of 'user_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

class UserAddEvent extends UserEvent {
  final User user;

  UserAddEvent(this.user);
}

class LoginEvent extends UserEvent {
  final LoginRequest user;

  LoginEvent(this.user);
}
