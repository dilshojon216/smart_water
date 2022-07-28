class DistrictHttp {
  late int id;
  late String tum_nomi;
  late int vil_id;

  DistrictHttp(
    this.id,
    this.tum_nomi,
    this.vil_id,
  );

  DistrictHttp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tum_nomi = json['tum_nomi'];
    vil_id = json['vil_id'];
  }
}
