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

  static List<Region> getRegions() {
    return jsonRegion.map((e) => Region.fromJson(e)).toList();
  }
}

var jsonRegion = {
  {
    "_id": "62fb67f3f91f2f6d1b2e308f",
    "id": 1,
    "name": "Qoraqalpog‘iston Respublikasi"
  },
  {"_id": "62fb67f3f91f2f6d1b2e3090", "id": 2, "name": "Andijon viloyati"},
  {"_id": "62fb67f3f91f2f6d1b2e3091", "id": 3, "name": "Buxoro viloyati"},
  {"_id": "62fb67f3f91f2f6d1b2e3092", "id": 4, "name": "Jizzax viloyati"},
  {"_id": "62fb67f3f91f2f6d1b2e3093", "id": 5, "name": "Qashqadaryo viloyati"},
  {"_id": "62fb67f3f91f2f6d1b2e3094", "id": 6, "name": "Navoiy viloyati"},
  {"_id": "62fb67f3f91f2f6d1b2e3095", "id": 7, "name": "Namangan viloyati"},
  {"_id": "62fb67f3f91f2f6d1b2e3096", "id": 8, "name": "Samarqand viloyati"},
  {"_id": "62fb67f3f91f2f6d1b2e3097", "id": 9, "name": "Surxandaryo viloyati"},
  {"_id": "62fb67f3f91f2f6d1b2e3098", "id": 10, "name": "Sirdaryo viloyati"},
  {"_id": "62fb67f3f91f2f6d1b2e3099", "id": 11, "name": "Toshkent viloyati"},
  {"_id": "62fb67f3f91f2f6d1b2e309a", "id": 12, "name": "Farg‘ona viloyati"},
  {"_id": "62fb67f3f91f2f6d1b2e309b", "id": 13, "name": "Xorazm viloyati"},
  // {"_id": "62fb67f3f91f2f6d1b2e309c", "id": 14, "name": "Toshkent shahri"}
};
