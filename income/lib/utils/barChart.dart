import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/controller.dart';
import 'package:income/utils/bigText.dart';


class GenerateBarChart extends StatefulWidget {
  const GenerateBarChart({super.key, required this.data, required this.title});
  final data;
  final String title;

  @override
  _GenerateBarChartState createState() => _GenerateBarChartState();
}

class _GenerateBarChartState extends State<GenerateBarChart> {
  myController controller = Get.find();
  List<Color> colors = [];
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          width: 500,
          child: GestureDetector(
            onLongPressMoveUpdate: (details) {
              // Calculate the touched index based on the position of the tap
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final localPosition =
                  renderBox.globalToLocal(details.globalPosition);
              final xValue = localPosition.dx;
              const barWidth = 20.0; // Adjust as needed
              final index = xValue ~/ (barWidth + 5);
              if (index >= 0 && index < widget.data.length) {
                setState(() {
                  touchedIndex = index;
                });
              }
            },
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                backgroundColor: Colors.indigo,
                barGroups: List.generate(widget.data.length, (index) {
                  Color color = controller.generateColor();

                  if (colors.contains(color) &&
                      color == Colors.indigo &&
                      color == Colors.transparent) {
                    color = controller.generateColor();
                  }
                  colors.add(color);
                  return BarChartGroupData(
                    x: int.parse(widget.data[index]['year']),
                    barsSpace: 5,
                    groupVertically: true,
                    barRods: [
                      BarChartRodData(
                        toY: double.parse(widget.data[index]['amount']),
                        width: 20,
                        color: color,
                      ),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: getTitles,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        BigText(text: widget.title),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: Text(value.toInt().toString(), style: style),
    );
  }
}

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 8,
    child: Text(value.toInt().toString(), style: style),
  );
}
