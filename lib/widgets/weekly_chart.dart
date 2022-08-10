import 'package:covid_19/constant.dart';
import 'package:covid_19/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';      // utf8.decede

class WeeklyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          barGroups: getBarGroups(),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: false,
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: getWeek,
              // getTextStyles: TextStyle(
              //   color: Color(0xFF7589A2),
              //   fontSize: 10,
              //   fontWeight: FontWeight.w200,
              // ),
            ),
            rightTitles: SideTitles(
              showTitles: true,
            ),
            topTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
      ),
    );
  }
}



getBarGroups() {
  List<double> barChartDatas = [600, 1000, 800, 777, 10, 15, 9];
  List<BarChartGroupData> barChartGroups = [];
  barChartDatas.asMap().forEach(
        (i, value) => barChartGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                y: value,
                //This is not the proper way, this is just for demo
                colors: i == 4 ? [kPrimaryColor] : [kInfectedColor],
                width: 16,
              )
            ],
          ),
        ),
      );
  return barChartGroups;
}

String getWeek(double value) {
  switch (value.toInt()) {
    case 0:
      return 'MON';
    case 1:
      return 'TUE';
    case 2:
      return 'WED';
    case 3:
      return 'THU';
    case 4:
      return 'FRI';
    case 5:
      return 'SAT';
    case 6:
      return 'SUN';
    default:
      return '';
  }
}
