
import 'package:flutter/material.dart';
import 'package:lego_parts_counter/partcolorspage/partcolorspage.dart';
import 'package:lego_parts_counter/rebrickable/model/part.dart';
import 'package:lego_parts_counter/rebrickable/rebrickableapi.dart';
import 'package:lego_parts_counter/storage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

class PartDialog {

  BuildContext context;

  PartDialog(this.context);

  showPartDialog(Part part) async {
    _showLoadingDialog();

    var apiKey = await loadApiKey();
    var colors = await RebrickableApi(apiKey).fetchPartColors(part.partNum, 1);

    // close loading dialog
    Navigator.pop(context);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(part.name),
              content: Container(
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: SizedBox(
                        width: 80,
                        child: Image.network(part.partImgUrl))),
                    InkWell(
                        child: Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Text("Open in browser",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue))
                        ),
                        onTap: () => _launchURL(part.partUrl)),
                    Row(children: <Widget>[
                      Text("Part num: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${part.partNum}"),
                    ]),
                    Row(children: <Widget>[
                      Text("Colors: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      InkWell(
                        child: Text("${colors.count}",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue)),
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>
                              PartColorsPage(part.partNum)));
                        },
                      ),
                    ]),
                    Row(children: <Widget>[
                      Text("Years: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${part.yearFrom} -  ${part.yearTo}"),
                    ])
                  ],
                ),
              ));
        });
  }

  void _showLoadingDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Loading..."),
            content: Container(
                height: 100,
                child: Center(child: CircularProgressIndicator())
            ),
          );
        }
    );
  }

  Future<String> loadApiKey() async => await LocalStorage().getApiKey();

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}