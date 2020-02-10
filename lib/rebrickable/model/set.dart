
class Set {

  String number;
  String name;
  int year;
  int themeId;
  int partsCount;
  String imageUrl;
  String setUrl;

  Set(this.number, this.name, this.year, this.themeId, this.partsCount,
      this.imageUrl);

  Set.fromJson(Map<String, dynamic> json)
      : number = json["set_num"],
        name = json["name"],
        year = json["year"],
        themeId = json["theme_id"],
        partsCount = json["num_parts"],
        imageUrl = json["set_img_url"],
        setUrl = json["setUrl"];
}