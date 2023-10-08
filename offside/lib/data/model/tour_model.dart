class TourModel {
  TourModel(this.addr, this.contentId, this.typeId, this.img, this.title,
      this.mapy, this.mapx);
  String? addr;
  String? contentId;
  String? typeId;
  String? img;
  String? title;
  String? mapy;
  String? mapx;

  TourModel.fromMap(Map<String, dynamic> map) {
    addr = map["addr1"];
    contentId = map["contentid"];
    typeId = map["contenttypeid"];
    img = map["firstimage"];
    title = map["title"];
    mapy = map["mapy"];
    mapx = map["mapx"];
  }

  TourModel.copy(TourModel tourModel) {
    addr = tourModel.addr;
    contentId = tourModel.contentId;
    typeId = tourModel.typeId;
    img = tourModel.img;
    title = tourModel.title;
    mapy = tourModel.mapy;
    mapx = tourModel.mapx;
  }
}

Map<String, String> getType = {
  '12': '관광지',
  '14': '문화시설',
  '32': '숙박',
  '39': '음식점'
};
