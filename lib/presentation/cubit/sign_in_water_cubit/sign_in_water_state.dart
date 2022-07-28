import 'package:equatable/equatable.dart';

import '../../../data/model/mqtt_user_token.dart';
import '../../../data/model/water_user_token.dart';

abstract class SignInWaterState extends Equatable {
  const SignInWaterState();
  @override
  List<Object> get props => [];
}

class InitialSignInWaterState extends SignInWaterState {}

class SignInWaterLoadingState extends SignInWaterState {}

class SignInWaterLoadedState extends SignInWaterState {
  final WaterUserToken token;
  const SignInWaterLoadedState({
    required this.token,
  });
}

class SignInWaterMqttState extends SignInWaterState {
  final MqttUserToken user;
  SignInWaterMqttState({
    required this.user,
  });
}

class SignInWaterErrorState extends SignInWaterState {
  final String error;
  const SignInWaterErrorState({
    required this.error,
  });
}
