import 'package:floor/floor.dart';

@Entity(tableName: "region")
class Region {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;

  Region({this.id, required this.name});

  Region.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  List<Region> fromJsonList(List<dynamic> json) {
    return json.map((e) => Region.fromJson(e)).toList();
  }
}
