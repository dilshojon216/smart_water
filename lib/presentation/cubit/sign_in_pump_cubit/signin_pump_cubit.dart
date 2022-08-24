import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/pump_stations.dart';
import '../../../data/repository/pump_repository.dart';
import 'signin_pump_state.dart';

class SignInPumpCubit extends Cubit<SignInPumpState> {
  final PumpRepository _pumpRepository = PumpRepository();
  SignInPumpCubit() : super(SignInPumpInitial());

  void signIn(String login, String password) async {
    emit(SignInPumpLoading());
    try {
      final token = await _pumpRepository.signInUser(login, password);
      token.fold((l) => emit(SignInPumpEroror(l.toString())),
          (r) => emit(GetUserToken(r)));
    } catch (e) {
      emit(SignInPumpEroror(e.toString()));
    }
  }

  void getServerStations(String token) async {
    emit(SignInPumpLoading());
    try {
      final stations = await _pumpRepository.getPumpStations(token);

      stations.fold((l) => emit(SignInPumpEroror(l.toString())),
          (r) => emit(GetStations(r)));
    } catch (e) {
      emit(SignInPumpEroror(e.toString()));
    }
  }

  void setLocalBaseData(List<PumpStations> r) async {
    try {
      final stations = await _pumpRepository.saveLocalBase(r);

      stations.fold((l) => emit(SignInPumpEroror(l.toString())),
          (r) => emit(SaveLocalBaseStations(r)));
    } catch (e) {
      print(e.toString());
      emit(SignInPumpEroror(e.toString()));
    }
  }
}
