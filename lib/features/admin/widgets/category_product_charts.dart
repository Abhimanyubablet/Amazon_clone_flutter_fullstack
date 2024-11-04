import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../model/sales.dart';

class CategoryProductCharts extends StatelessWidget {
  final List<Sales> salesData;

  const CategoryProductCharts({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: salesData.map((data) => data.earning).reduce((a, b) => a > b ? a : b) + 10,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 10),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < salesData.length) {
                  return Text(salesData[index].label,style: TextStyle(fontSize: 10),);
                }
                return Text('');
              },
            ),
          ),
        ),
        barGroups: salesData.asMap().entries.map((entry) {
          int index = entry.key;
          Sales data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.earning.toDouble(),
                color: Colors.blue,
                width: 20,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
