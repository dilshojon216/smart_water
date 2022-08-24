const String LANGUAGE = "language";
const String BASICURL = "http://suv-api.uz/api/";
const String APIBASE = "api_http_water";
const String APIBASE1 = "api_mqtt_water";
const String APIBASE2 = "api_pump_mqtt";
List<int> corretionList() {
  List<int> list = [];
  for (int i = -100; i < 101; i++) {
    list.add(i);
  }
  return list;
}

List<int> sendMinPerodList = [1, 10, 30, 60, 120, 360, 720, 1440];
List<int> sendFTPInterval = [10, 30, 60, 120, 360, 720, 1440, 14400];
