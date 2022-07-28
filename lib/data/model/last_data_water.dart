import 'last_data_water_pagination.dart';
import 'water_info.dart';

class LastDataWater {
  LastDataWaterPagination pagination;
  List<WaterInfo> stations;

  LastDataWater(
    this.pagination,
    this.stations,
  );

  factory LastDataWater.fromJson(Map<String, dynamic> json) => LastDataWater(
        LastDataWaterPagination.fromJson(json["pagination"]),
        List<WaterInfo>.from(
            json["stations"].map((x) => WaterInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
        "stations": List<dynamic>.from(stations.map((x) => x.toJson())),
      };
}
