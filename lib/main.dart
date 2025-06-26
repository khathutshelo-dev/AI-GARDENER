import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(WateringApp());
}

class WateringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garden Watering App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  void checkMoisture(BuildContext context) {
    String input = controller.text.trim();

    if (input.isEmpty) return;

    final moisture = double.tryParse(input);

    if (moisture == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Invalid Input"),
          content: Text("Please enter a valid number."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );

      return;
    }

    if (moisture < 20) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WateringNeededPage(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.green[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text("Garden Status 🌿"),
          content: Text("No need to water the garden now!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cool"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Garden Watering App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.grass, size: 100, color: Colors.green),
            SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter moisture % (e.g. 18)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => checkMoisture(context),
              child: Text("Check Moisture"),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GardenStatusPage()),
                );
              },
              child: Text("Check Garden Status"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}

class WateringNeededPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Action Required")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.water_drop, size: 100, color: Colors.blueAccent),
            SizedBox(height: 20),
            Text(
              "The soil moisture is low.\nYou need to water the garden 💧",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class GardenStatusPage extends StatelessWidget {
  final List<FlSpot> moistureData = [
    FlSpot(0, 25),
    FlSpot(1, 18),
    FlSpot(2, 22),
    FlSpot(3, 17),
    FlSpot(4, 19),
    FlSpot(5, 23),
    FlSpot(6, 20),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Garden Status")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Moisture History (Last 7 Days)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text("Day ${value.toInt() + 1}");
                        },
                        reservedSize: 32,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        getTitlesWidget: (value, meta) =>
                            Text("${value.toInt()}%"),
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: 6,
                  minY: 10,
                  maxY: 30,
                  lineBarsData: [
                    LineChartBarData(
                      spots: moistureData,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 4,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.5),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
