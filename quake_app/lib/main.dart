import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main () async {

  Map _data = await getJSON();

  List _features = _data["features"];
  
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("EarthQuake"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _features.length,
            itemBuilder: (BuildContext context, int position){
            var format = new DateFormat.yMMMMd("en_US").add_jm();
            var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[position]["properties"]["time"]*1000, isUtc: true));

            return Column(
              children: <Widget>[
                Divider(height: 5.5),
                ListTile(
                  title: Text("At: $date", style: TextStyle(color: Colors.amber, fontSize: 20.0, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic),),
                  subtitle: Text("${_features[position]["properties"]["place"]}", style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)),
                  leading: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Text("${_features[position]["properties"]["mag"]}", style: TextStyle(color: Colors.white,)),
                  ),
                  onTap: () => _showAlertDialog(context, "${_features[position]["properties"]["title"]}"),
                ),
              ],
            );
            }),
      ),
    )
  ));
}


void _showAlertDialog (BuildContext context, String message){
var alert = new AlertDialog(
  title: Text("Quakes"),
  content: Text(message),
  actions: <Widget>[
    FlatButton(
      child: Text("OK"),
        onPressed: (){
        Navigator.pop(context);
        })
  ],
);

showDialog(context: context, builder: (context) => alert);
}



Future<Map> getJSON() async {
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}