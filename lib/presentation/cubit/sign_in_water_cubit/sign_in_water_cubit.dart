import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/water_clinet.dart';
import 'sign_in_water_state.dart';

class SignInWaterCubit extends Cubit<SignInWaterState> {
  final WaterClinet _waterClinet = WaterClinet();
  SignInWaterCubit() : super(InitialSignInWaterState());

  void signIn(String login, String password) async {
    emit(SignInWaterLoadingState());
    try {
      final token = await _waterClinet.getUserToken(login, password);
      emit(SignInWaterLoadedState(token: token));
    } catch (e) {
      emit(SignInWaterErrorState(error: e.toString()));
    }
  }

  void signInMqtt(String login, String password) async {
    emit(SignInWaterLoadingState());
    try {
      final token = await _waterClinet.getUserMqttToken(login, password);
      emit(SignInWaterMqttState(user: token));
    } catch (e) {
      emit(SignInWaterErrorState(error: e.toString()));
    }
  }
}
