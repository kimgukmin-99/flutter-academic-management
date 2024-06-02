import 'package:http/http.dart' as http;

const String server =
    "http://13.237.43.243:8000"; //이거 챗봇서버 성민이가 알아서 보안유지되게끔 해서 해주셈 어케하는지는 나도 모름

//유저데이터 백엔드랑 통신해서 받아올거니까 여기다 저장후 다른 페이지에도 적용하게끔
class UserProfile {
  final String userName;
  final String department;
  final String year;
  final String studentId;
  final int graduationScore;
  final int maxScore;
  final List<String> skills;
  final Map<String, bool> subjects;

  UserProfile({
    required this.userName,
    required this.department,
    required this.year,
    required this.studentId,
    required this.graduationScore,
    required this.maxScore,
    required this.skills, //스킬 넣는거임 ex)파이썬 이런거
    required this.subjects, //내가 수강한 과목 넣기!
  });
}

//그냥 메모리에 작성한것 이부분을 로그인후 백엔드데이터에서 가저온 데이터로 바꿔치기
final UserProfile userProfile = UserProfile(
    userName: '김성민',
    department: '컴퓨터공학과',
    year: '3-1',
    studentId: '20180595',
    graduationScore: 30,
    maxScore: 1000,
    skills: ["파이썬"],
    subjects: {"자료구조": true, "알고리즘": true, "캡스톤디자인": true});
