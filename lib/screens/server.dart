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

