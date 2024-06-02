import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> todaySchedule = [
    {
      'time': '09:00 - 10:00',
      'subject': 'Mathematics',
      'room': '090524',
      'color': '0xff6A1B9A',
    },
    {
      'time': '10:15 - 11:15',
      'subject': 'Physics',
      'room': '060321',
      'color': '0xff0277BD',
    },
  ];

  final List<Map<String, dynamic>> weeklySchedule = [
    {
      'day': 'Monday',
      'schedules': [
        {
          'time': '09:00 - 10:00',
          'subject': 'Mathematics',
          'room': '090524',
        },
        {
          'time': '10:15 - 11:15',
          'subject': 'Physics',
          'room': '060321',
        },
      ],
    },
    {
      'day': 'Tuesday',
      'schedules': [
        {
          'time': '11:30 - 12:30',
          'subject': 'Chemistry',
          'room': '260212',
        },
      ],
    },
    {
      'day': 'Wednesday',
      'schedules': [
        {
          'time': '09:00 - 10:00',
          'subject': 'Biology',
          'room': '120321',
        },
        {
          'time': '10:15 - 11:15',
          'subject': 'English',
          'room': '110524',
        },
      ],
    },
    {
      'day': 'Thursday',
      'schedules': [
        {
          'time': '09:00 - 10:00',
          'subject': 'History',
          'room': '150524',
        },
        {
          'time': '10:15 - 11:15',
          'subject': 'Geography',
          'room': '140321',
        },
      ],
    },
    {
      'day': 'Friday',
      'schedules': [
        {
          'time': '09:00 - 10:00',
          'subject': 'Art',
          'room': '080524',
        },
        {
          'time': '10:15 - 11:15',
          'subject': 'Music',
          'room': '070321',
        },
      ],
    },
  ];

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  children: [
                    _buildScrollableTodaySchedule(),
                    _buildWeeklySchedule(),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: SmoothPageIndicator(
                  controller: _controller, // PageController
                  count: 2,
                  effect: WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 250),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableTodaySchedule() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: todaySchedule.map((item) {
            return Container(
              width: 250,
              height: 150,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                color: Color(int.parse(item['color']!)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['time']!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        item['subject']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Room: ${item['room']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildWeeklySchedule() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: weeklySchedule.map((day) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  day['day'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...day['schedules'].map<Widget>((schedule) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(schedule['subject']),
                    subtitle: Text(schedule['time']),
                    trailing: Text('Room: ${schedule['room']}'),
                  ),
                );
              }).toList(),
              SizedBox(height: 10),
            ],
          );
        }).toList(),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: HomeScreen(),
  debugShowCheckedModeBanner: false,
));
