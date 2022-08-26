import 'package:floor/floor.dart';

@Entity(tableName: "sensorType")
class SensorType {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  SensorType({this.id, required this.name});
}
