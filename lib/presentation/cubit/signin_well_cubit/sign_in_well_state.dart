import 'package:equatable/equatable.dart';

import '../../../data/model/mqtt_user_token.dart';

abstract class SignInWellState extends Equatable {
  const SignInWellState();
  @override
  List<Object> get props => [];
}

class InitialSignInWellState extends SignInWellState {}

class SignInWellLoadingState extends SignInWellState {}

class SignInWellMqttLoadedState extends SignInWellState {
  final MqttUserToken token;
  const SignInWellMqttLoadedState({
    required this.token,
  });
}

class SignInWellErrorState extends SignInWellState {
  final String error;
  const SignInWellErrorState({
    required this.error,
  });
}
