
class PartColor {

  int id;
  String name;
  String rgb;

  PartColor(this.name, this.rgb);

  PartColor.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        rgb = json["rgb"];
}