import 'package:covid_stats_app/pages/by_country.dart';
import 'package:covid_stats_app/pages/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _pageIndex = 0;

  void _onTapped(int i) {
    setState(() {
      _pageIndex = i;
    });
  }

  List<Widget> pages = [
    HomePage(),
    ByCountry(),
  ];

  List<String> appBarTitles = [
    'Global Stats',
    'Country Specific Stats',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitles[_pageIndex],
          style: TextStyle(fontFamily: 'Muli'),
        ),
        centerTitle: true,
      ),
      body: pages[_pageIndex],
      bottomNavigationBar: returnBottomNavBar(_pageIndex),
    ));
  }

  Widget returnBottomNavBar(int i) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.language),
          title: Text(
            'Global Stats',
            style: TextStyle(fontFamily: 'Muli'),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flag),
          title: Text(
            'By Country',
            style: TextStyle(fontFamily: 'Muli'),
          ),
        ),
      ],
      currentIndex: i,
      onTap: _onTapped,
    );
  }
}
