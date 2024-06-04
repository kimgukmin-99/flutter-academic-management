import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:academic_management/providers/person.dart';

class GraduationScreen extends StatefulWidget {
  @override
  _GraduationScreenState createState() => _GraduationScreenState();
}

class GraduationRequirement {
  final String requirement;
  final bool completed;
  final List<Map<String, String>> details;
  GraduationRequirement({
    required this.requirement,
    required this.completed,
    required this.details,
  });
}

class _GraduationScreenState extends State<GraduationScreen> {
  List<GraduationRequirement> recommendations = [
    GraduationRequirement(
      requirement: '수강신청',
      completed: true,
      details: [],
    ),
    GraduationRequirement(
      requirement: '봉사활동',
      completed: false,
      details: [],
    ),
    GraduationRequirement(
      requirement: '채용공고',
      completed: true,
      details: [],
    ),
    GraduationRequirement(
      requirement: '자격증',
      completed: false,
      details: [],
    ),
    GraduationRequirement(
      requirement: '학교활동',
      completed: false,
      details: [],
    ),
  ];
  final String userName = userProfile.userName;
  final String department = userProfile.department;
  final String year = "${userProfile.year[0]}학년 ${userProfile.year[2]}학기";
  final String studentId = userProfile.studentId;
  final int graduationScore = userProfile.graduationScore; // 졸업 진척도 예시 (750점)
  final int maxScore = userProfile.maxScore; // 총점 1000점

  @override
  void initState() {
    super.initState();
    fetchData(); // initState에서 초기화 시점에 데이터 요청
    sendData();
    sendData2();
    sendData3();
    fetchData2();
  }

//수강과목추천임
  Future<void> sendData3() async {
    try {
      final url = Uri.parse(server + '/submit-subjects');
      // 서버로 전송할 데이터를 정의합니다. 개인정보 받아와서 변경해야댐
      final data = {
        "subjects": userProfile.subjects,
        "semester": userProfile.year,
      };

      // JSON 형식으로 인코딩합니다.
      final body = json.encode(data);

      // POST 요청을 보냅니다.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          final responseBody = utf8.decode(response.bodyBytes);
          final List<dynamic> jsonData = json.decode(responseBody);
          if (jsonData != null && jsonData is List) {
            List<Map<String, String>> details =
                jsonData.map<Map<String, String>>((item) {
              return {
                '과목명': item['과목명'] ?? '',
                '개설학기': item['개설학기'] ?? '',
                '학수번호': item['학수번호'] ?? '',
              };
            }).toList();

            recommendations[0] = GraduationRequirement(
              requirement: '수강신청',
              completed: true,
              details: details,
            );
          } else {
            print('Empty response data');
          }
        });
      } else {
        // 서버 오류 처리
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 처리
      print('Network error: $e');
    }
  }

//봉사임
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(server + '/submit-volunteer'));
      if (response.statusCode == 200) {
        setState(() {
          final responseBody = utf8.decode(response.bodyBytes);
          final jsonData = json.decode(responseBody);
          if (jsonData != null && jsonData is List) {
            List<Map<String, String>> details =
                jsonData.map<Map<String, String>>((item) {
              return {
                'title': item['title'] ?? '',
                'period': item['모집기간'] ?? '',
                'time': item['봉사시간'] ?? '',
                'link': item['링크'] ?? '',
              };
            }).toList();

            recommendations[1] = GraduationRequirement(
              requirement: '봉사활동',
              completed: false,
              details: details,
            );
          } else {
            print('Empty response data');
          }
        });
      } else {
        // 서버 오류 처리
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 처리
      print('Network error: $e');
    }
  }

//자격증임
  Future<void> sendData() async {
    try {
      final url = Uri.parse(server + '/submit-certification');

      // 서버로 전송할 데이터를 정의합니다. 개인정보 받아와서 변경해야댐
      final data = {
        "certification": {
          "additionalProp1": true,
          "additionalProp2": true,
          "additionalProp3": true
        },
        "my_score": userProfile.graduationScore
      };

      // JSON 형식으로 인코딩합니다.
      final body = json.encode(data);

      // POST 요청을 보냅니다.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          final responseBody = utf8.decode(response.bodyBytes);
          final jsonData = json.decode(responseBody);

          if (jsonData != null && jsonData is List) {
            List<Map<String, String>> details =
                jsonData.map<Map<String, String>>((item) {
              return {
                'name': item['name'] ?? '',
                '점수': item['점수'] ?? '',
              };
            }).toList();

            recommendations[3] = GraduationRequirement(
              requirement: '자격증',
              completed: false,
              details: details,
            );
          } else {
            print('Empty response data');
          }
        });
      } else {
        // 서버 오류 처리
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 처리
      print('Network error: $e');
    }
  }

  //채용정보임
  Future<void> sendData2() async {
    try {
      final url = Uri.parse(server + '/submit-work');

      // 서버로 전송할 데이터를 정의합니다. 개인정보 받아와서 변경해야댐
      final data = {"work": userProfile.skills};

      // JSON 형식으로 인코딩합니다.
      final body = json.encode(data);

      // POST 요청을 보냅니다.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          final responseBody = utf8.decode(response.bodyBytes);
          final jsonData = json.decode(responseBody);

          if (jsonData != null && jsonData is List) {
            List<Map<String, String>> details =
                jsonData.map<Map<String, String>>((item) {
              return {
                'title': item['job_title'] ?? '',
                'date': item['job_date'] ?? '',
                'condition': item['job_condition'] ?? '',
                'sector': item['job_sector'] ?? '',
                'link': item['job_link'] ?? '',
              };
            }).toList();

            recommendations[2] = GraduationRequirement(
              requirement: '채용공고',
              completed: false,
              details: details,
            );
          } else {
            print('Empty response data');
          }
        });
      } else {
        // 서버 오류 처리
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 처리
      print('Network error: $e');
    }
  }

  Future<void> fetchData2() async {
    try {
      final response = await http.get(Uri.parse(server + '/submit-activation'));
      if (response.statusCode == 200) {
        setState(() {
          final responseBody = utf8.decode(response.bodyBytes);
          final jsonData = json.decode(responseBody);
          if (jsonData != null && jsonData is List) {
            List<Map<String, String>> details =
                jsonData.map<Map<String, String>>((item) {
              return {
                'title': item['title'] ?? '',
                '개설학기': item['개설학기'] ?? '',
                '혜택': item['혜택'] ?? '',
              };
            }).toList();

            recommendations[4] = GraduationRequirement(
              requirement: '학교활동',
              completed: false,
              details: details,
            );
          } else {
            print('Empty response data');
          }
        });
      } else {
        // 서버 오류 처리
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 처리
      print('Network error: $e');
    }
  }

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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
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
              SizedBox(
                height: 7,
              ),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: recommendations.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final recommendation = recommendations[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      title: Text(recommendation.requirement),
                      trailing: Icon(
                        recommendation.completed
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: recommendation.completed
                            ? Colors.green
                            : Colors.red,
                      ),
                      children: recommendation.details.map((detail) {
                        return ListTile(
                          title: Text(detail['title'] ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: detail.entries
                                .where((entry) => entry.key != 'title')
                                .map((entry) =>
                                    Text('${entry.key}: ${entry.value}'))
                                .toList(),
                          ),
                        );
                      }).toList(),
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
