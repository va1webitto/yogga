import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(YogaApp());
}

class YogaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guided Yoga',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<String> levels = ["Beginner", "Intermediate", "Advanced"];
  final Map<String, Color> buttonColors = {
    "Beginner": Colors.lightGreen,
    "Intermediate": Colors.orange,
    "Advanced": Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: Image.asset(
              'assets/main-image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: Text(
              "Choose yoga training difficulty",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: levels.map((level) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                          textStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                          backgroundColor: buttonColors[level],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => YogaSessionScreen(level: level),
                            ),
                          );
                        },
                        child: Text(level),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class YogaSessionScreen extends StatelessWidget {
  final String level;
  final Map<String, List<String>> yogaPoses = {
    "Beginner": ["Mountain Pose", "Downward Dog", "Child Pose"],
    "Intermediate": ["Warrior II", "Tree Pose", "Triangle Pose"],
    "Advanced": ["Crow Pose", "Handstand Pose", "Scorpion Pose"]
  };

  YogaSessionScreen({required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$level Yoga Session')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: yogaPoses[level]?.length ?? 0,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(yogaPoses[level]![index]),
                leading: Icon(Icons.self_improvement, color: Colors.green),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PoseDetailScreen(pose: yogaPoses[level]![index], level: level),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class PoseDetailScreen extends StatefulWidget {
  final String pose;
  final String level;

  PoseDetailScreen({required this.pose, required this.level});

  @override
  _PoseDetailScreenState createState() => _PoseDetailScreenState();
}

class _PoseDetailScreenState extends State<PoseDetailScreen> {
  Timer? _timer;
  int _remainingTime = 0;

  final Map<String, int> durationMap = {
    "Beginner": 300,
    "Intermediate": 600,
    "Advanced": 900,
  };

  @override
  void initState() {
    super.initState();
    _remainingTime = durationMap[widget.level] ?? 300;
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    setState(() {
      _remainingTime = durationMap[widget.level] ?? 300;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pose)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/${widget.pose.toLowerCase().replaceAll(" ", "_")}.png', height: 300, fit: BoxFit.cover),
            SizedBox(height: 20),
            Text(
              "Description of ${widget.pose}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text("Remaining Time: ${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: startTimer, child: Text("Start")),
                SizedBox(width: 10),
                ElevatedButton(onPressed: stopTimer, child: Text("Stop")),
                SizedBox(width: 10),
                ElevatedButton(onPressed: resetTimer, child: Text("Reset")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
