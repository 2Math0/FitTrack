import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double stepPercent = 0.0;
  int currentSteps = 0;
  int caloriesBurned = 0;
  int activeMinutes = 0;
  bool dataAvailable = true;
  final int goalSteps = 10000;

  @override
  void initState() {
    super.initState();
    fetchHealthData();
  }

  Future<void> fetchHealthData() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.MOVE_MINUTES,
    ];
    final health = HealthFactory();
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    // Request permissions
    await Permission.activityRecognition.request();

    bool accessWasGranted = await health.requestAuthorization(types);

    if (accessWasGranted) {
      try {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          midnight,
          now,
          types,
        );

        if (healthData.isEmpty) {
          setState(() => dataAvailable = false);
          return;
        }

        int totalSteps = 0;
        double totalCalories = 0;
        int totalMinutes = 0;

        for (var dp in healthData) {
          switch (dp.type) {
            case HealthDataType.STEPS:
              totalSteps += (dp.value as int);
              break;
            case HealthDataType.ACTIVE_ENERGY_BURNED:
              totalCalories += (dp.value as double);
              break;
            case HealthDataType.MOVE_MINUTES:
              totalMinutes += (dp.value as int);
              break;
            default:
              break;
          }
        }

        setState(() {
          currentSteps = totalSteps;
          stepPercent = totalSteps / goalSteps;
          caloriesBurned = totalCalories.round();
          activeMinutes = totalMinutes;
          dataAvailable = true;
        });
      } catch (e) {
        print("Health data error: $e");
        setState(() => dataAvailable = false);
      }
    } else {
      print("Authorization not granted");
      setState(() => dataAvailable = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good afternoon,\n John",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "April 12, 2025",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            dataAvailable
                ? _MetricsRow(
              steps: currentSteps,
              calories: caloriesBurned,
              minutes: activeMinutes,
            )
                : const Center(
              child: Text(
                "Health data not available",
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 40,),
            Center(
              child: dataAvailable
                  ? CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 12.0,
                percent: stepPercent.clamp(0.0, 1.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Steps",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Text("$currentSteps",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                progressColor: Colors.teal,
                backgroundColor: Colors.grey.shade200,
                circularStrokeCap: CircularStrokeCap.round,
              )
                  : const Text("No step data to display"),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.blue.shade900,
                      foregroundColor: Colors.white
                    ),
                    onPressed: (){},
                    child: Text('Log Activity')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.blue.shade900,
                      foregroundColor: Colors.white
                    ),
                    onPressed: (){},
                    child: Text('View Goals')),
              ],
            )
          ],
        ),
      ),),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  final int steps;
  final int calories;
  final int minutes;

  const _MetricsRow({
    this.steps = 0,
    this.calories = 0,
    this.minutes = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _MetricCard(icon: Icons.directions_walk, label: "Steps", value: "$steps"),
        _MetricCard(icon: Icons.local_fire_department, label: "Calories", value: "$calories kcal"),
        _MetricCard(icon: Icons.timer, label: "Workout", value: "$minutes min"),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.teal),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
/*
class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
*/