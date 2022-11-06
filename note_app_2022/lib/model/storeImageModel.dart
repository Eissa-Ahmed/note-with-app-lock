class StoreImageModel {
  int id;
  String image;

  StoreImageModel({required this.id, required this.image});
  factory StoreImageModel.fromJson(Map json) {
    return StoreImageModel(
      id: json["id"],
      image: json["image"],
    );
  }
}
