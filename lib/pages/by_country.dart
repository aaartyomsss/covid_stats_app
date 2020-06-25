import 'package:covid_stats_app/models/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:covid_stats_app/models/by_country_model.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class ByCountry extends StatefulWidget {
  @override
  _ByCountryState createState() => _ByCountryState();
}

class _ByCountryState extends State<ByCountry> {
  String url = 'https://api.covid19api.com/live/country/';
  String userInput;
  TextEditingController controller;

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
  void initState() {
    // TODO: implement initStated
    controller = TextEditingController();
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
    return customRow();
  }

  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: customRow(),
        ),
        FutureBuilder(
            future: getData(),
            builder: (context, data) {
              if (data.hasData && data.connectionState == ConnectionState.done) {
                var dataObject = data.data;
              return Expanded(
                flex: 8,
                              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataObject.length,
                  itemBuilder: (context, index) {
                    return displayInfo(con: dataObject[index].confirmed,
                    recovered: dataObject[index].recovered,
                    active: dataObject[index].active,
                    deaths: dataObject[index].deaths,
                    date: dataObject[index].date,
                    );
                  }
                  ),
              );
              } else if (data.hasError) {
                return Center(child: Text('Unable to receive data. Please check spelling of a country'));
              }
              return Center(child: CircularProgressIndicator());
            }),
      ],
    );
  }

  Widget displayInfo({con, recovered, deaths, active, date}) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: [
              Text('Confirmed', style: cardText,),
              Text('Recovered', style: cardText,),
              Text('Active', style: cardText,),
              Text('Deaths', style: cardText,),
              Text('Date', style: cardText,),
            ]
          ),
          Column(
            children: [
              Text(con.toString(), style: cardText,),
              Text(recovered.toString(), style: cardText,),
              Text(active.toString(), style: cardText,),
              Text(deaths.toString(), style: cardText,),
              Text(DateFormat("dd-MM-yyyy").format(date), style: cardText,),
            ]
          ),

        ],
      )
    );
  }

  Widget customInputField() {
    return TextField(
      controller: controller,
      onSubmitted: (String value) {
        setState(() {
          userInput = value.toLowerCase().replaceAllMapped(" ", (match) => "-");
          controller.clear();
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter country name',
      ),
    );
  }

  Widget refreshButton() {
    return FlatButton(
      onPressed: () {
        setState(() {
        userInput = null;
      });
      }, 
      child: Icon(Icons.refresh),
      );
  }

  Row customRow() {
    return Row(
      children: [
        refreshButton(),
        Expanded(child: customInputField()),
      ]
    );
  }

}
