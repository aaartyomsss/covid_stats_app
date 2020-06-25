import 'package:covid_stats_app/models/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:covid_stats_app/models/total.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  Future<Global> globalObject;
  
  Future<Global> getData() async {
    // Getting an API data
    var response = await http.get(
      'https://api.covid19api.com/world/total',
    );

    if (response.statusCode == 200) {
      return Global.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load the data');
    }
  }

  @override
  void initState() {
    super.initState();
    globalObject = getData();
  }

  @override
  Widget build(BuildContext context) {

    return buildFuture(globalObject);
  }
}

// Building UI after getting data from API
Widget buildFuture(Future<Global> object) {
  return FutureBuilder(
          future: object,
          builder: (context, data) {
            if (data.hasData) {
              var dataObject = data.data;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Total confirmed cases:', style: mainPageHeadings,),
                    Text('${dataObject.totalConfirmed}', style: TextStyle(fontSize: 20),),
                    returnChart(confirmed: dataObject.totalConfirmed, deaths: dataObject.totalDeaths, recovered: dataObject.totalRecovered),

                  ]
                ),
              );
            } else if (data.hasError){
              return Text('${data.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        );
}

Widget returnChart({confirmed, deaths, recovered}) {
  
  PieChartSectionData total = PieChartSectionData(value: confirmed.toDouble(), color: Colors.red, title: 'Confirmed Cases', titleStyle: TextStyle(fontFamily: 'Muli', color: Colors.black, fontSize: 20), radius: 60);
  PieChartSectionData deathRate = PieChartSectionData(value: deaths.toDouble(), color: Colors.black, title: 'Deaths', titleStyle: TextStyle(fontFamily: 'Muli', fontSize: 20, color: Colors.blue), radius: 60);
  PieChartSectionData recoveredPeople = PieChartSectionData(value: recovered.toDouble(), color: Colors.yellow, title: 'Recovered', titleStyle: TextStyle(fontFamily: 'Muli', color: Colors.black, fontSize: 20), radius: 60);


  return PieChart(
    PieChartData(
      sections: [
        total,
        deathRate,
        recoveredPeople,
      ], 
      centerSpaceRadius: 70.0,
      startDegreeOffset: 180,
      borderData: FlBorderData(
        show: false
      ),
    )
  );
}