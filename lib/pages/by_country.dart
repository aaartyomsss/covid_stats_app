import 'package:covid_stats_app/models/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:covid_stats_app/models/by_country_model.dart';
import 'dart:convert';

class ByCountry extends StatefulWidget {
  @override
  _ByCountryState createState() => _ByCountryState();
}

class _ByCountryState extends State<ByCountry> {
  String url = 'https://api.covid19api.com/live/country/';
  String userInput;
  

  Future<List<ByCountryModel>> getData() async {
    var response = await http.get(url + userInput);
    var jsonData = json.decode(response.body);
    List<ByCountryModel> countryData = [];

    if (response.statusCode == 200) {
      for (var obj in jsonData) {
        countryData.add(ByCountryModel.fromJson(obj));
      }
      return countryData;
    } else {
      throw Exception('Failed to load the data');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userInput == null) {
      return buildBodyNull();
    } else {
      return buildBody();
    }
  }

  Widget buildBodyNull() {
    return TextFormField(
      onFieldSubmitted: (String value) {
        setState(() {
          userInput = value.toLowerCase().replaceAllMapped(" ", (match) => "-");
        });
      },
    );
  }

  Widget buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            onFieldSubmitted: (String value) {
              setState(() {
                userInput = value.toLowerCase();
              });
            },
          ),
        ),
        FutureBuilder(
            future: getData(),
            builder: (context, data) {
              if (data.hasData && data.connectionState == ConnectionState.done) {
                var dataObject = data.data;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: dataObject.length,
                itemBuilder: (context, index) {
                  return Text('${dataObject[index].confirmed}');
                }
                );
              } else if (data.hasError) {
                return Text('Unable to receive data. Please check spelling of a country');
              }
              return CircularProgressIndicator();
            }),
      ],
    );
  }
}
