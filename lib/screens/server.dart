import 'package:http/http.dart' as http;


//유저데이터 백엔드랑 통신해서 받아올거니까 여기다 저장후 다른 페이지에도 적용하게끔
class UserProfile {
  final String userName;
  final String department;
  final String year;
  final String studentId;
  final int graduationScore;
  final int maxScore;

  UserProfile({
    required this.userName,
    required this.department,
    required this.year,
    required this.studentId,
    required this.graduationScore,
    required this.maxScore,
  });
}
//그냥 메모리에 작성한것 이부분을 로그인후 백엔드데이터에서 가저온 데이터로 바꿔치기
final UserProfile userProfile = UserProfile(
  userName: '홍길동',
  department: '컴퓨터공학과',
  year: '3-1',
  studentId: '20201234',
  graduationScore: 500,
  maxScore: 1000,
);

//챗봇백엔드랑 연결해야댐 추천클래스임
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
//추천서버랑 통신하는 부분 
Future<void> fetchData() async {
  final response = await http.get(Uri.parse('http://localhost:8000/submit-volunteer'));
  
  if (response.statusCode == 200) {
    // 요청이 성공했을 때의 처리
    print('요청 성공: ${response.body}');
  } else {
    // 요청이 실패했을 때의 처리
    print('요청 실패: ${response.statusCode}');
  }
}
List<GraduationRequirement> recommendations = [
  GraduationRequirement(
    requirement: '수강신청',
    completed: true,
    details: [
      ],
  ),
  GraduationRequirement(
    requirement: '봉사활동',
    completed: false,
    details: [
     ],
  ),
  GraduationRequirement(
    requirement: '채용공고',
    completed: true,
    details: [
      ],
  ),
  GraduationRequirement(
    requirement: '자격증',
    completed: false,
    details: [
      ],
  ),
  GraduationRequirement(
    requirement: '학교활동',
    completed: false,
    details: [
     
    ],
  ),
];

