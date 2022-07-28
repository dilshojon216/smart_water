import 'package:floor/floor.dart';

@entity
class SensorType {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  SensorType({this.id, required this.name});
}
