import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_water/presentation/cubit/signin_well_cubit/sign_in_well_state.dart';

import '../../../data/datasources/water_clinet.dart';

class SignInWellCubit extends Cubit<SignInWellState> {
  final WaterClinet _waterClinet = WaterClinet();
  SignInWellCubit() : super(InitialSignInWellState());

  void signIn(String login, String password) async {
    emit(SignInWellLoadingState());
    try {
      final token = await _waterClinet.getUserMqttToken(login, password);
      emit(SignInWellMqttLoadedState(token: token));
    } catch (e) {
      emit(SignInWellErrorState(error: e.toString()));
    }
  }
}
