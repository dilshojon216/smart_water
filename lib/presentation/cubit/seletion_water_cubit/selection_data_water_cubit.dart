import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/presentation/cubit/seletion_water_cubit/selection_data_water_state.dart';

import '../../../data/datasources/water_clinet.dart';

class SelectionDataWaterCubit extends Cubit<SelectionDataWaterState> {
  final WaterClinet _waterClinet = WaterClinet();
  SelectionDataWaterCubit() : super(InitialSelectionDataWaterState());

  void getWaterDataSelection(String? id, String date) async {
    emit(SelectionDataWaterLoadingState());
    try {
      var _prefs = await SharedPreferences.getInstance();
      String? token = _prefs.getString("token");

      final data = await _waterClinet.getWaterDataToyday(token, id, date);

      emit(SelectionDataWaterLoadedState(data: data));
    } catch (e) {
      emit(SelectionDataWaterErrorState(error: e.toString()));
    }
  }
}
