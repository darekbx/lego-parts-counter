
class PartColor {

  String name;
  String rgb;

  PartColor(this.name, this.rgb);

  PartColor.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        rgb = json["rgb"];
}