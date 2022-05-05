import 'package:bloc/bloc.dart';
import 'package:mycart/model/login_request.dart';
import 'package:mycart/repository/user_repository.dart';

import '../../model/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserAddEvent>((event, emit) async {
      final response = await UserRepository().addUser(event.user);
      emit(UserAdded());
    });
    on<LoginEvent>((event, emit) async {
      try {
        final response = await UserRepository().loginUser(event.user);
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailed(e.toString()));
      }
    });
  }
}
