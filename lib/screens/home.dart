import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> schedule = [
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

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: schedule.length,
                itemBuilder: (context, index) {
                  final item = schedule[index];
                  return SizedBox(
                    height: 50, // 원하는 카드 높이로 설정
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
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
                },
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: SmoothPageIndicator(
                controller: _controller, // PageController
                count: schedule.length,
                effect: WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 300),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    ));
