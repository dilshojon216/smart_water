import 'package:equatable/equatable.dart';

import '../../../data/model/water_info.dart';

abstract class LastWaterDataState extends Equatable {
  const LastWaterDataState();

  @override
  List<Object> get props => [];
}

class InitialLastWaterDataState extends LastWaterDataState {}

class LastWaterDataLoadingState extends LastWaterDataState {
  final int page;
  final List<WaterInfo> oldstations;
  final bool isFirstFetch;
  final int pageTotal;
  LastWaterDataLoadingState(this.oldstations, this.page, this.pageTotal,
      {this.isFirstFetch = false});
}

class LastWaterDataLoadedState extends LastWaterDataState {
  final int page;
  final List<WaterInfo> stations;
  final int pageTotal;

  const LastWaterDataLoadedState(
      {required this.page, required this.pageTotal, required this.stations});
}

class LastWaterDataErrorState extends LastWaterDataState {
  final String error;
  const LastWaterDataErrorState({
    required this.error,
  });
}
