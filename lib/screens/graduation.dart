import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:academic_management/providers/person.dart';
import 'package:url_launcher/url_launcher.dart';

class GraduationScreen extends StatefulWidget {
  @override
  _GraduationScreenState createState() => _GraduationScreenState();
}

class GraduationRequirement {
  final String requirement;
  final List<Map<String, String>> details;
  GraduationRequirement({
    required this.requirement,
    required this.details,
  });
}

class _GraduationScreenState extends State<GraduationScreen> {
  List<GraduationRequirement> recommendations = [
    GraduationRequirement(
      requirement: '수강신청',
      details: [],
    ),
    GraduationRequirement(
      requirement: '봉사활동',
      details: [],
    ),
    GraduationRequirement(
      requirement: '채용공고',
      details: [],
    ),
    GraduationRequirement(
      requirement: '자격증',
      details: [],
    ),
    GraduationRequirement(
      requirement: '학교활동',
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
                '제목': item['title'] ?? '',
                '모집기간': item['모집기간'] ?? '',
                '시간': item['봉사시간'] ?? '',
                '링크': item['링크'] ?? '',
              };
            }).toList();

            recommendations[1] = GraduationRequirement(
              requirement: '봉사활동',
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
                '자격증 이름': item['name'] ?? '',
                '점수': item['점수'] ?? '',
              };
            }).toList();

            recommendations[3] = GraduationRequirement(
              requirement: '자격증',
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

  // 채용정보임
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
                '제목': item['job_title'] ?? '',
                '날짜': item['job_date'] ?? '',
                '조건': (item['job_condition'] ?? '').replaceAll('\n', ', '),
                '모집분야': item['job_sector'] ?? '',
                '링크': item['job_link'] ?? '',
              };
            }).toList();

            recommendations[2] = GraduationRequirement(
              requirement: '채용공고',
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

  //학교활동임
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
                '활동명': item['title'] ?? '',
                '개설학기': item['개설학기'] ?? '',
                '혜택': item['혜택'] ?? '',
              };
            }).toList();

            recommendations[4] = GraduationRequirement(
              requirement: '학교활동',
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

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
                    Text(
                      '기술 스택: ${userProfile.skills.join(', ')}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff546E7A),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '졸업 인증 점수',
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFA2A2FF)),
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
              SizedBox(height: 7),
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
                      title: Text(
                        recommendation.requirement,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      children: recommendation.details.isNotEmpty
                          ? recommendation.details.map((detail) {
                              return Column(
                                children: [
                                  Divider(color: Color(0xFFA2A2FF)),
                                  ...detail.entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 2.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: entry.key == '링크'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () => _launchURL(
                                                        entry.value!),
                                                    child: Text(
                                                      '바로가기',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                '${entry.key}: ${entry.value}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                    );
                                  }).toList(),
                                  SizedBox(height: 8),
                                ],
                              );
                            }).toList()
                          : [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'No details available.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
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
