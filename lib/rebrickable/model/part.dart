
class Part {

  String partNum;
  String name;
  String partImgUrl;
  String partUrl;

  Part(this.partNum, this.name, this.partImgUrl, this.partUrl);

  Part.fromJson(Map<String, dynamic> json)
      : partNum = json["part_num"],
        partImgUrl = json["part_img_url"],
        partUrl = json["part_url"],
        name = json["name"];
}