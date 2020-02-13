class Color {

  int colorId;
  String colorName;
  int numSets;
  int numSetParts;
  String partImgUrl;

  Color(this.colorId, this.colorName, this.numSets, this.numSetParts, this.partImgUrl);

  Color.fromJson(Map<String, dynamic> json)
      : colorId = json["color_id"],
        colorName = json["color_name"],
        numSets = json["num_sets"],
        numSetParts = json["num_set_parts"],
        partImgUrl = json["part_img_url"];
}