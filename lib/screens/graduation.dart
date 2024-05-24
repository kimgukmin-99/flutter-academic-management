import 'package:flutter/material.dart';

class GraduationRequirement {
  final String requirement;
  final bool completed;

  GraduationRequirement({required this.requirement, required this.completed});
}

class GraduationScreen extends StatelessWidget {
  final List<GraduationRequirement> recommendations = [
    GraduationRequirement(requirement: '봉사 활동 1', completed: true),
    GraduationRequirement(requirement: '봉사 활동 2', completed: false),
    GraduationRequirement(requirement: '인턴십 1', completed: true),
    GraduationRequirement(requirement: '동아리 활동', completed: false),
  ];

  final String userName = '홍길동';
  final String department = '컴퓨터공학과';
  final String year = '3학년';
  final String studentId = '20201234';
  final int graduationScore = 750; // 졸업 진척도 예시 (750점)
  final int maxScore = 1000; // 총점 1000점

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xffECEFF1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$department | $year | $studentId',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff546E7A),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Graduation Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: graduationScore / maxScore,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$graduationScore / $maxScore',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff546E7A),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                '추천 활동',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final recommendation = recommendations[index];
                  return ListTile(
                    title: Text(recommendation.requirement),
                    trailing: Icon(
                      recommendation.completed
                          ? Icons.check_circle
                          : Icons.cancel,
                      color:
                          recommendation.completed ? Colors.green : Colors.red,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
