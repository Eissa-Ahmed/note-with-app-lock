class AddNoteModel {
  String title;
  String note;
  String date;
  String image;
  int id;
  int color;
  AddNoteModel({
    required this.date,
    required this.image,
    required this.note,
    required this.title,
    required this.color,
    required this.id,
  });

  factory AddNoteModel.fronJson(Map<String, dynamic> model) {
    return AddNoteModel(
      date: model["date"],
      image: model["image"],
      note: model["note"],
      title: model["title"],
      color: model["color"],
      id: model["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "note": note,
      "image": image,
      "date": date,
      "color": color,
      "id": id,
    };
  }
}
