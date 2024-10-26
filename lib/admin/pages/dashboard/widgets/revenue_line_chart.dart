import 'package:car_workshop_admin/controllers/booking_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';


class RevenueLineChart extends StatefulWidget {
 
  const RevenueLineChart({super.key});

  @override
  _RevenueLineChartState createState() => _RevenueLineChartState();
}

class _RevenueLineChartState extends State<RevenueLineChart> {
  final BookingController bookingController = Get.find<BookingController>();
  

  // Track selected data type (bookings or mechanics)
  String selectedDataType = "Bookings";

  @override
  Widget build(BuildContext context) {
    // Generate data points based on the selected data type
    List<FlSpot> dataSpots = selectedDataType == "Bookings"
        ? _generateDataSpots(bookingController.bookings, "Bookings")
        : _generateDataSpots(bookingController.mechanics, "Mechanics");

    return Column(
      children: [
        // Dropdown for selecting data type
        DropdownButton<String>(
          value: selectedDataType,
          items: ["Bookings", "Mechanics"].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedDataType = newValue!;
            });
          },
        ),
        // SizedBox(height: 16),
        // Chart displaying selected data
        Expanded(
          child: LineChart(
            LineChartData(
              lineTouchData: lineTouchData1,
              gridData: gridData,
              titlesData: titlesData1,
              borderData: borderData,
              lineBarsData: [
                LineChartBarData(
                  spots: dataSpots,
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              minX: 0,
              maxX: 11, // Assumes monthly data
              minY: 0,
              maxY: _calculateMaxY(dataSpots),
            ),
            duration: const Duration(milliseconds: 250),
          ),
        ),
      ],
    );
  }

  /// Generates data spots based on the start dates for bookings or mechanics
  List<FlSpot> _generateDataSpots(List<dynamic> data, String dataType) {
    // Group data by month or custom intervals
    Map<int, int> dataCounts = {};
    if(dataType == "Bookings") {
       for (var entry in data) {
      DateTime date = entry.startDatetime.toDate(); // Assuming `startDatetime` is in Firestore's `Timestamp`
      int month = date.month;
      dataCounts[month] = (dataCounts[month] ?? 0) + 1;
    }
    } else {
       for (var entry in data) {
      DateTime date = entry.createdAt.toDate(); // Assuming `startDatetime` is in Firestore's `Timestamp`
      int month = date.month;
      dataCounts[month] = (dataCounts[month] ?? 0) + 1;
    }
    }
   

    // Convert dataCounts into FlSpots
    return dataCounts.entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList();
  }

  double _calculateMaxY(List<FlSpot> spots) {
    return spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.2;
  }

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => AppColors.titleLight,
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return Text('${value.toInt()}', style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle();
    String text = '';
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: AppColors.highlightLight, width: 1),
          left: BorderSide.none,
          right: BorderSide.none,
          top: BorderSide.none,
        ),
      );
}
