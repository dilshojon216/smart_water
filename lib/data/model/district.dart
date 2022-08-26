import 'package:floor/floor.dart';

@Entity(tableName: "district")
class District {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int regionId;
  final String name;

  District({this.id, required this.name, required this.regionId});

  District.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        regionId = json['region_id'],
        name = json['name'];

  List<District> fromJsonList(List<dynamic> json) {
    return json.map((e) => District.fromJson(e)).toList();
  }
}
