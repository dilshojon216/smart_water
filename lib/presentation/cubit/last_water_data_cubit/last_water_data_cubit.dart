import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/data/model/water_info.dart';

import '../../../data/datasources/water_clinet.dart';
import 'last_water_data_state.dart';

class LastWaterDataCubit extends Cubit<LastWaterDataState> {
  final WaterClinet _waterClinet = WaterClinet();
  LastWaterDataCubit() : super(InitialLastWaterDataState());

  int page = 1;
  int pageCount = 0;
  void getLastWaterData() async {
    try {
      var _prefs = await SharedPreferences.getInstance();
      String? token = _prefs.getString("token");

      //if (state is LastWaterDataLoadingState) return;

      final currentState = state;
      var oldWaterDatas = <WaterInfo>[];
      if (currentState is LastWaterDataLoadedState) {
        oldWaterDatas = currentState.stations;
      }

      emit(LastWaterDataLoadingState(oldWaterDatas, page, pageCount,
          isFirstFetch: page == 1));

      if (pageCount == 0) {
        final stations = await _waterClinet.getLastData(token, page);
        pageCount = stations.pagination.pageCount;

        final stations1 = (state as LastWaterDataLoadingState).oldstations;
        stations1.addAll(stations.stations);

        page++;
        emit(LastWaterDataLoadedState(
            page: page, stations: stations1, pageTotal: pageCount));
      } else if (pageCount >= page) {
        if (pageCount == page) {}
        final stations = await _waterClinet.getLastData(token, page);
        final stations1 = (state as LastWaterDataLoadingState).oldstations;
        stations1.addAll(stations.stations);
        // print(stations1.length);
        page++;

        emit(LastWaterDataLoadedState(
            page: page, stations: stations1, pageTotal: pageCount));
      }
    } catch (e) {
      emit(LastWaterDataErrorState(error: e.toString()));
    }
  }
}
