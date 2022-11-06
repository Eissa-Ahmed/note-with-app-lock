class StoreVideoModel {
  int id;
  String video;
  String image;

  StoreVideoModel({required this.id, required this.video, required this.image});
  factory StoreVideoModel.fromJson(Map json) {
    return StoreVideoModel(
      id: json["id"],
      video: json["video"],
      image: json["image"],
    );
  }
}
