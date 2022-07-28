import 'package:equatable/equatable.dart';

import '../../../data/model/water_data_month.dart';
import '../../../data/model/water_data_ten_day.dart';
import '../../../data/model/water_data_today.dart';
import '../../../data/model/water_data_year.dart';

abstract class WaterAllDataState extends Equatable {
  const WaterAllDataState();

  @override
  List<Object> get props => [];
}

class InitialWaterAllDataState extends WaterAllDataState {}

class WaterAllDataLoadingState extends WaterAllDataState {}

class WaterDataTodayState extends WaterAllDataState {
  final WaterDataToyday data;

  const WaterDataTodayState({
    required this.data,
  });
}

class WaterDataMonthState extends WaterAllDataState {
  final WaterDataMonths data;

  const WaterDataMonthState({
    required this.data,
  });
}

class WaterDataYesterdayState extends WaterAllDataState {
  final WaterDataToyday data;

  const WaterDataYesterdayState({
    required this.data,
  });
}

class WaterDataTenDayState extends WaterAllDataState {
  final WaterDataTenDay data;

  const WaterDataTenDayState({
    required this.data,
  });
}

class WaterDataYearState extends WaterAllDataState {
  final WaterDatasYear data;

  const WaterDataYearState({
    required this.data,
  });
}

class WaterDataErrorState extends WaterAllDataState {
  final String error;

  const WaterDataErrorState({
    required this.error,
  });
}
