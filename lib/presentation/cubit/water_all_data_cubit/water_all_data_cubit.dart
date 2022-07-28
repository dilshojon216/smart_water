import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/data/datasources/water_clinet.dart';

import 'water_all_data_state.dart';

class WaterAllDataCubit extends Cubit<WaterAllDataState> {
  final WaterClinet _waterClinet = WaterClinet();
  WaterAllDataCubit() : super(InitialWaterAllDataState());

  void getWaterDataToday(String? id, String date) async {
    emit(WaterAllDataLoadingState());
    try {
      var _prefs = await SharedPreferences.getInstance();
      String? token = _prefs.getString("token");

      final data = await _waterClinet.getWaterDataToyday(token, id, date);

      emit(WaterDataTodayState(data: data));
    } catch (e) {
      emit(WaterDataErrorState(error: e.toString()));
    }
  }

  void getWaterDataYesterday(String? id, String date) async {
    emit(WaterAllDataLoadingState());
    try {
      var _prefs = await SharedPreferences.getInstance();
      String? token = _prefs.getString("token");

      final data = await _waterClinet.getWaterDataToyday(token, id, date);

      emit(WaterDataYesterdayState(data: data));
    } catch (e) {
      emit(WaterDataErrorState(error: e.toString()));
    }
  }

  void getWaterDataTenDay(String? id, String date) async {
    emit(WaterAllDataLoadingState());
    try {
      var _prefs = await SharedPreferences.getInstance();
      String? token = _prefs.getString("token");

      final data = await _waterClinet.getWaterDataTenDay(token, id, date);

      emit(WaterDataTenDayState(data: data));
    } catch (e) {
      emit(WaterDataErrorState(error: e.toString()));
    }
  }

  void getWaterDataMonths(String? id, String date) async {
    emit(WaterAllDataLoadingState());
    try {
      var _prefs = await SharedPreferences.getInstance();
      String? token = _prefs.getString("token");

      final data = await _waterClinet.getWaterDataMonth(token, id, date);

      emit(WaterDataMonthState(data: data));
    } catch (e) {
      emit(WaterDataErrorState(error: e.toString()));
    }
  }

  void getWaterDataYear(String? id, String date) async {
    emit(WaterAllDataLoadingState());
    try {
      var _prefs = await SharedPreferences.getInstance();
      String? token = _prefs.getString("token");

      final data = await _waterClinet.getWaterDataYear(token, id);

      emit(WaterDataYearState(data: data));
    } catch (e) {
      emit(WaterDataErrorState(error: e.toString()));
    }
  }
}
