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

  static List<District> getDistricts() {
    return jsonDatataa.map((e) => District.fromJson(e)).toList();
  }
}

var jsonDatataa = {
  {
    "_id": "62fb6ea2f91f2f6d1b2e30b4",
    "id": 15,
    "region_id": 1,
    "name": "Amudaryo tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30b5",
    "id": 16,
    "region_id": 1,
    "name": "Beruniy tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30b6",
    "id": 17,
    "region_id": 1,
    "name": "Kegayli tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30b7",
    "id": 18,
    "region_id": 1,
    "name": "Qonliko‘l tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30b8",
    "id": 19,
    "region_id": 1,
    "name": "Qorao‘zak tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30b9",
    "id": 20,
    "region_id": 1,
    "name": "Qo‘ng‘irot tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30ba",
    "id": 21,
    "region_id": 1,
    "name": "Mo‘ynoq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30bb",
    "id": 22,
    "region_id": 1,
    "name": "Nukus tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30bc",
    "id": 23,
    "region_id": 1,
    "name": "Nukus shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30bd",
    "id": 24,
    "region_id": 1,
    "name": "Taxtako‘pir tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30be",
    "id": 25,
    "region_id": 1,
    "name": "To‘rtko‘l tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30bf",
    "id": 26,
    "region_id": 1,
    "name": "Xo‘jayli tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30c0",
    "id": 27,
    "region_id": 1,
    "name": "CHimboy tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30c1",
    "id": 28,
    "region_id": 1,
    "name": "SHumanay tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30c2",
    "id": 29,
    "region_id": 1,
    "name": "Ellikqal‘a tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30c3",
    "id": 30,
    "region_id": 2,
    "name": "Andijon shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30c4",
    "id": 31,
    "region_id": 2,
    "name": "Andijon tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30c5",
    "id": 32,
    "region_id": 2,
    "name": "Asaka tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30c6",
    "id": 33,
    "region_id": 2,
    "name": "Baliqchi tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30c7",
    "id": 34,
    "region_id": 2,
    "name": "Buloqboshi tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30c8",
    "id": 35,
    "region_id": 2,
    "name": "Bo‘z tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30c9",
    "id": 36,
    "region_id": 2,
    "name": "Jalaquduq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30ca",
    "id": 37,
    "region_id": 2,
    "name": "Izbosgan tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30cb",
    "id": 38,
    "region_id": 2,
    "name": "Qorasuv shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30cc",
    "id": 39,
    "region_id": 2,
    "name": "Qo‘rg‘ontepa tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30cd",
    "id": 40,
    "region_id": 2,
    "name": "Marhamat tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30ce",
    "id": 41,
    "region_id": 2,
    "name": "Oltinko‘l tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30cf",
    "id": 42,
    "region_id": 2,
    "name": "Paxtaobod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30d0",
    "id": 43,
    "region_id": 2,
    "name": "Ulug‘nor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30d1",
    "id": 44,
    "region_id": 2,
    "name": "Xonabod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30d2",
    "id": 45,
    "region_id": 2,
    "name": "Xo‘jaobod shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30d3",
    "id": 46,
    "region_id": 2,
    "name": "Shaxrixon tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30d4",
    "id": 47,
    "region_id": 3,
    "name": "Buxoro shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30d5",
    "id": 48,
    "region_id": 3,
    "name": "Buxoro tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30d6",
    "id": 49,
    "region_id": 3,
    "name": "Vobkent tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30d7",
    "id": 50,
    "region_id": 3,
    "name": "G‘ijduvon tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30d8",
    "id": 51,
    "region_id": 3,
    "name": "Jondor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30d9",
    "id": 52,
    "region_id": 3,
    "name": "Kogon tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30da",
    "id": 53,
    "region_id": 3,
    "name": "Kogon shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30db",
    "id": 54,
    "region_id": 3,
    "name": "Qorako‘l tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30dc",
    "id": 55,
    "region_id": 3,
    "name": "Qorovulbozor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30dd",
    "id": 56,
    "region_id": 3,
    "name": "Olot tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30de",
    "id": 57,
    "region_id": 3,
    "name": "Peshku tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30df",
    "id": 58,
    "region_id": 3,
    "name": "Romitan tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30e0",
    "id": 59,
    "region_id": 3,
    "name": "Shofirkon tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30e1",
    "id": 60,
    "region_id": 4,
    "name": "Arnasoy tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30e2",
    "id": 61,
    "region_id": 4,
    "name": "Baxmal tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30e3",
    "id": 62,
    "region_id": 4,
    "name": "G‘allaorol tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30e4",
    "id": 63,
    "region_id": 4,
    "name": "Do‘stlik tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30e5",
    "id": 64,
    "region_id": 4,
    "name": "Sh.Rashidov tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30e6",
    "id": 65,
    "region_id": 4,
    "name": "Jizzax shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30e7",
    "id": 66,
    "region_id": 4,
    "name": "Zarbdor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30e8",
    "id": 67,
    "region_id": 4,
    "name": "Zafarobod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30e9",
    "id": 68,
    "region_id": 4,
    "name": "Zomin tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30ea",
    "id": 69,
    "region_id": 4,
    "name": "Mirzacho‘l tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30eb",
    "id": 70,
    "region_id": 4,
    "name": "Paxtakor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30ec",
    "id": 71,
    "region_id": 4,
    "name": "Forish tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30ed",
    "id": 72,
    "region_id": 4,
    "name": "Yangiobod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30ee",
    "id": 73,
    "region_id": 5,
    "name": "G‘uzor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30ef",
    "id": 74,
    "region_id": 5,
    "name": "Dehqonobod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30f0",
    "id": 75,
    "region_id": 5,
    "name": "Qamashi tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30f1",
    "id": 76,
    "region_id": 5,
    "name": "Qarshi tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30f2",
    "id": 77,
    "region_id": 5,
    "name": "Qarshi shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30f3",
    "id": 78,
    "region_id": 5,
    "name": "Kasbi tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30f4",
    "id": 79,
    "region_id": 5,
    "name": "Kitob tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30f5",
    "id": 80,
    "region_id": 5,
    "name": "Koson tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30f6",
    "id": 81,
    "region_id": 5,
    "name": "Mirishkor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30f7",
    "id": 82,
    "region_id": 5,
    "name": "Muborak tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30f8",
    "id": 83,
    "region_id": 5,
    "name": "Nishon tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30f9",
    "id": 84,
    "region_id": 5,
    "name": "Chiroqchi tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30fa",
    "id": 85,
    "region_id": 5,
    "name": "Shahrisabz tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30fb",
    "id": 86,
    "region_id": 5,
    "name": "Yakkabog‘ tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30fc",
    "id": 87,
    "region_id": 6,
    "name": "Zarafshon shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30fd",
    "id": 88,
    "region_id": 6,
    "name": "Karmana tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30fe",
    "id": 89,
    "region_id": 6,
    "name": "Qiziltepa tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e30ff",
    "id": 90,
    "region_id": 6,
    "name": "Konimex tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3100",
    "id": 91,
    "region_id": 6,
    "name": "Navbahor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3101",
    "id": 92,
    "region_id": 6,
    "name": "Navoiy shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3102",
    "id": 93,
    "region_id": 6,
    "name": "Nurota tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3103",
    "id": 94,
    "region_id": 6,
    "name": "Tomdi tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3104",
    "id": 95,
    "region_id": 6,
    "name": "Uchquduq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3105",
    "id": 96,
    "region_id": 6,
    "name": "Xatirchi tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3106",
    "id": 97,
    "region_id": 7,
    "name": "Kosonsoy tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3107",
    "id": 98,
    "region_id": 7,
    "name": "Mingbuloq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3asdas",
    "id": 99,
    "region_id": 7,
    "name": "Namangan tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3109",
    "id": 100,
    "region_id": 7,
    "name": "Namangan shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e310a",
    "id": 101,
    "region_id": 7,
    "name": "Norin tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e310b",
    "id": 102,
    "region_id": 7,
    "name": "Pop tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e310c",
    "id": 103,
    "region_id": 7,
    "name": "To‘raqo‘rg‘on tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e310d",
    "id": 104,
    "region_id": 7,
    "name": "Uychi tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e310e",
    "id": 105,
    "region_id": 7,
    "name": "Uchqo‘rg‘on tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e310f",
    "id": 106,
    "region_id": 7,
    "name": "Chortoq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3110",
    "id": 107,
    "region_id": 7,
    "name": "Chust tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3111",
    "id": 108,
    "region_id": 7,
    "name": "Yangiqo‘rg‘on tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3112",
    "id": 109,
    "region_id": 8,
    "name": "Bulung‘ur tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3113",
    "id": 110,
    "region_id": 8,
    "name": "Jomboy tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3114",
    "id": 111,
    "region_id": 8,
    "name": "Ishtixon tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3115",
    "id": 112,
    "region_id": 8,
    "name": "Kattaqo‘rg‘on tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3116",
    "id": 113,
    "region_id": 8,
    "name": "Kattaqo‘rg‘on shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3117",
    "id": 114,
    "region_id": 8,
    "name": "Qo‘shrabot tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3118",
    "id": 115,
    "region_id": 8,
    "name": "Narpay tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3119",
    "id": 116,
    "region_id": 8,
    "name": "Nurabod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e311a",
    "id": 117,
    "region_id": 8,
    "name": "Oqdaryo tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e311b",
    "id": 118,
    "region_id": 8,
    "name": "Payariq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e311c",
    "id": 119,
    "region_id": 8,
    "name": "Pastarg‘om tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e311d",
    "id": 120,
    "region_id": 8,
    "name": "Paxtachi tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e311e",
    "id": 121,
    "region_id": 8,
    "name": "Samarqand tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e311f",
    "id": 122,
    "region_id": 8,
    "name": "Samarqand shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3120",
    "id": 123,
    "region_id": 8,
    "name": "Toyloq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3121",
    "id": 124,
    "region_id": 8,
    "name": "Urgut tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3122",
    "id": 125,
    "region_id": 9,
    "name": "Angor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3123",
    "id": 126,
    "region_id": 9,
    "name": "Boysun tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3124",
    "id": 127,
    "region_id": 9,
    "name": "Denov tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3125",
    "id": 128,
    "region_id": 9,
    "name": "Jarqo‘rg‘on tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3126",
    "id": 129,
    "region_id": 9,
    "name": "Qiziriq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3127",
    "id": 130,
    "region_id": 9,
    "name": "Qo‘mqo‘rg‘on tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3128",
    "id": 131,
    "region_id": 9,
    "name": "Muzrabot tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3129",
    "id": 132,
    "region_id": 9,
    "name": "Oltinsoy tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e312a",
    "id": 133,
    "region_id": 9,
    "name": "Sariosiy tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e312b",
    "id": 134,
    "region_id": 9,
    "name": "Termiz tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e312c",
    "id": 135,
    "region_id": 9,
    "name": "Termiz shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e312d",
    "id": 136,
    "region_id": 9,
    "name": "Uzun tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e312e",
    "id": 137,
    "region_id": 9,
    "name": "Sherobod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e312f",
    "id": 138,
    "region_id": 9,
    "name": "Sho‘rchi tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3130",
    "id": 139,
    "region_id": 10,
    "name": "Boyovut tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3131",
    "id": 140,
    "region_id": 10,
    "name": "Guliston tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3132",
    "id": 141,
    "region_id": 10,
    "name": "Guliston shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3133",
    "id": 142,
    "region_id": 10,
    "name": "Mirzaobod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3134",
    "id": 143,
    "region_id": 10,
    "name": "Oqoltin tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3135",
    "id": 144,
    "region_id": 10,
    "name": "Sayxunobod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3136",
    "id": 145,
    "region_id": 10,
    "name": "Sardoba tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3137",
    "id": 146,
    "region_id": 10,
    "name": "Sirdaryo tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3138",
    "id": 147,
    "region_id": 10,
    "name": "Xavos tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3139",
    "id": 148,
    "region_id": 10,
    "name": "Shirin shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e313a",
    "id": 149,
    "region_id": 10,
    "name": "Yangier shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e313b",
    "id": 150,
    "region_id": 11,
    "name": "Angiren shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e313c",
    "id": 151,
    "region_id": 11,
    "name": "Bekabod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e313d",
    "id": 152,
    "region_id": 11,
    "name": "Bekabod shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e313e",
    "id": 153,
    "region_id": 11,
    "name": "Bo‘ka tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e313f",
    "id": 154,
    "region_id": 11,
    "name": "Bo‘stonliq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3140",
    "id": 155,
    "region_id": 11,
    "name": "Zangiota tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3141",
    "id": 156,
    "region_id": 11,
    "name": "Qibray tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3142",
    "id": 157,
    "region_id": 11,
    "name": "Quyichirchiq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3143",
    "id": 158,
    "region_id": 11,
    "name": "Oqqo‘rg‘on tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3144",
    "id": 159,
    "region_id": 11,
    "name": "Olmaliq shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3145",
    "id": 160,
    "region_id": 11,
    "name": "Ohangaron tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3146",
    "id": 161,
    "region_id": 11,
    "name": "Parkent tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3147",
    "id": 162,
    "region_id": 11,
    "name": "Piskent tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3148",
    "id": 163,
    "region_id": 11,
    "name": "O‘rtachirchiq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3149",
    "id": 164,
    "region_id": 11,
    "name": "Chinoz tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e314a",
    "id": 165,
    "region_id": 11,
    "name": "Chirchiq shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e314b",
    "id": 166,
    "region_id": 11,
    "name": "Yuqorichirchiq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e314c",
    "id": 167,
    "region_id": 11,
    "name": "Yangiyo‘l tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e314d",
    "id": 168,
    "region_id": 12,
    "name": "Beshariq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e314e",
    "id": 169,
    "region_id": 12,
    "name": "Bog‘dod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e314f",
    "id": 170,
    "region_id": 12,
    "name": "Buvayda tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3150",
    "id": 171,
    "region_id": 12,
    "name": "Dang‘ara tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3151",
    "id": 172,
    "region_id": 12,
    "name": "Yozyovon tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3152",
    "id": 173,
    "region_id": 12,
    "name": "Quva tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3153",
    "id": 174,
    "region_id": 12,
    "name": "Quvasoy shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3154",
    "id": 175,
    "region_id": 12,
    "name": "Qo‘qon shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3155",
    "id": 176,
    "region_id": 12,
    "name": "Qo‘shtepa tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3156",
    "id": 177,
    "region_id": 12,
    "name": "Marg‘ilon shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3157",
    "id": 178,
    "region_id": 12,
    "name": "Oltiariq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3158",
    "id": 179,
    "region_id": 12,
    "name": "Rishton tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3159",
    "id": 180,
    "region_id": 12,
    "name": "So‘x tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e315a",
    "id": 181,
    "region_id": 12,
    "name": "Toshloq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e315b",
    "id": 182,
    "region_id": 12,
    "name": "Uchko‘prik tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e315c",
    "id": 183,
    "region_id": 12,
    "name": "O‘zbekiston tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e315d",
    "id": 184,
    "region_id": 12,
    "name": "Farg‘ona tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e315e",
    "id": 185,
    "region_id": 12,
    "name": "Farg‘ona shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e315f",
    "id": 186,
    "region_id": 12,
    "name": "Furqat tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3160",
    "id": 187,
    "region_id": 13,
    "name": "Bog‘ot tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3161",
    "id": 188,
    "region_id": 13,
    "name": "Gurlan tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3162",
    "id": 189,
    "region_id": 13,
    "name": "Qo‘shko‘pir tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3163",
    "id": 190,
    "region_id": 13,
    "name": "Urganch tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3164",
    "id": 191,
    "region_id": 13,
    "name": "Urganch shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3165",
    "id": 192,
    "region_id": 13,
    "name": "Xiva tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3166",
    "id": 193,
    "region_id": 13,
    "name": "Xazarasp tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3167",
    "id": 194,
    "region_id": 13,
    "name": "Xonqa tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3168",
    "id": 195,
    "region_id": 13,
    "name": "Shavot tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3169",
    "id": 196,
    "region_id": 13,
    "name": "Yangiariq tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e316a",
    "id": 197,
    "region_id": 13,
    "name": "Yangibozor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e316b",
    "id": 198,
    "region_id": 14,
    "name": "Bektimer tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e316c",
    "id": 199,
    "region_id": 14,
    "name": "M.Ulug‘bek tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e316d",
    "id": 200,
    "region_id": 14,
    "name": "Mirobod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e316e",
    "id": 201,
    "region_id": 14,
    "name": "Olmazor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e316f",
    "id": 202,
    "region_id": 14,
    "name": "Sergeli tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3170",
    "id": 203,
    "region_id": 14,
    "name": "Uchtepa tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3171",
    "id": 204,
    "region_id": 14,
    "name": "Yashnobod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3172",
    "id": 205,
    "region_id": 14,
    "name": "Chilonzor tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3173",
    "id": 206,
    "region_id": 14,
    "name": "Shayxontohur tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3174",
    "id": 207,
    "region_id": 14,
    "name": "Yunusobod tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3175",
    "id": 208,
    "region_id": 14,
    "name": "Yakkasaroy tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3176",
    "id": 209,
    "region_id": 1,
    "name": "Taxiatosh shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3177",
    "id": 210,
    "region_id": 2,
    "name": "Asaka shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3178",
    "id": 211,
    "region_id": 9,
    "name": "Bandixon tumani"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e3179",
    "id": 212,
    "region_id": 11,
    "name": "Ohangaron shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e317a",
    "id": 213,
    "region_id": 11,
    "name": "Yangiyo‘l shahri"
  },
  {
    "_id": "62fb6ea2f91f2f6d1b2e317b",
    "id": 215,
    "region_id": 11,
    "name": "Toshkent tumani"
  }
};
