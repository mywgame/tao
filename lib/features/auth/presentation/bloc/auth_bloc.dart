import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../data/repositories/auth_repository_impl.dart'; // सटीक रिलेटिव पाथ

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        final data = await _authRepository.loginUser(
          email: event.email,
          password: event.password,
        );
        emit(AuthSuccess(data));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}