import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loan_management_system/features/dashboard/data/member_data.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      ShareDividendData('John Calvin', 500000, 200000),
      ShareDividendData('Martin Luther', 400000, 150000),
      ShareDividendData('Saint Athanasius', 300000, 250000),
      ShareDividendData('Saint Augustine', 350000, 300000),
      ShareDividendData('William Cowper', 600000, 400000),
      ShareDividendData('Horatio Spafford', 200000, 100000),
      ShareDividendData('Horatio Bonar', 250000, 150000),
      ShareDividendData('Isaac Watts', 300000, 200000),
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: data.map((datum) {
          return BarChartGroupData(
            x: data.indexOf(datum),
            barRods: [
              BarChartRodData(
                toY: datum.shares.toDouble(),
                rodStackItems: [
                  BarChartRodStackItem(0, datum.shares.toDouble(), Colors.blue),
                ],
                width: 12,
              ),
              BarChartRodData(
                toY: datum.dividends.toDouble(),
                rodStackItems: [
                  BarChartRodStackItem(0, datum.dividends.toDouble(), Colors.purple),
                ],
                width: 12,
              ),
            ],
          );
        }).toList(),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 80,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  final surname = data[index].name.split(' ').last;

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 10.0,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationZ(0.5),
                        child: Text(
                          surname,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                // Only show labels if the value is not zero
                if (value != 0) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4.0,
                    child: Text(
                      value.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink(); 
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value != 0) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4.0,
                    child: Text(
                      value.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false, 
            ),
          ),
        ),
      ),
    );
  }
}
