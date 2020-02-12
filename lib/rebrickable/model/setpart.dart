import 'package:lego_parts_counter/rebrickable/model/part.dart';
import 'package:lego_parts_counter/rebrickable/model/partcolor.dart';

class SetPart {

  int quantity;
  String elementId;
  int numSets;
  Part part;
  PartColor partColor;

  SetPart(this.quantity, this.elementId, this.numSets, this.part, this.partColor);

  SetPart.fromJson(Map<String, dynamic> json)
      : quantity = json["quantity"],
        elementId = json["element_id"],
        numSets = json["num_sets"],
        part = Part.fromJson(json["part"]),
        partColor = PartColor.fromJson(json["color"]);
}