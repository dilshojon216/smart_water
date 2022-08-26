class Organization {
  int id;
  int regionId;
  String name;
  Organization({
    required this.id,
    required this.regionId,
    required this.name,
  });

  Organization.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        regionId = json['region'] == null
            ? json["region_id"]
            : int.parse(json["region"]),
        name = json['name'];

  List<Organization> fromJsonList(List<dynamic> json) {
    return json.map((e) => Organization.fromJson(e)).toList();
  }
}
