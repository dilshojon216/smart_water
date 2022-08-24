import 'package:equatable/equatable.dart';
import 'package:smart_water/data/model/pump_stations.dart';

abstract class SignInPumpState extends Equatable {
  const SignInPumpState();
  @override
  List<Object> get props => [];
}

class SignInPumpInitial extends SignInPumpState {}

class SignInPumpLoading extends SignInPumpState {}

class GetUserToken extends SignInPumpState {
  String token;
  GetUserToken(this.token);
}

class GetStations extends SignInPumpState {
  List<PumpStations> data;
  GetStations(this.data);
}

class SaveLocalBaseStations extends SignInPumpState {
  String token;
  SaveLocalBaseStations(this.token);
}

class SignInPumpEroror extends SignInPumpState {
  String error;
  SignInPumpEroror(this.error);
}
