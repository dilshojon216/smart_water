import 'package:equatable/equatable.dart';

import '../../../data/model/water_data_today.dart';

abstract class SelectionDataWaterState extends Equatable {
  const SelectionDataWaterState();

  @override
  List<Object> get props => [];
}

class InitialSelectionDataWaterState extends SelectionDataWaterState {}

class SelectionDataWaterLoadingState extends SelectionDataWaterState {}

class SelectionDataWaterLoadedState extends SelectionDataWaterState {
  final WaterDataToyday data;

  const SelectionDataWaterLoadedState({
    required this.data,
  });
}

class SelectionDataWaterErrorState extends SelectionDataWaterState {
  final String error;

  const SelectionDataWaterErrorState({
    required this.error,
  });
}
