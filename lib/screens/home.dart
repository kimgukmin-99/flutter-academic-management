import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:academic_management/screens/post_detail_screen.dart';
import 'package:academic_management/screens/bulletin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:academic_management/providers/person.dart';
import 'package:academic_management/screens/main_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabTapped;

  HomeScreen({required this.onTabTapped});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> recentPosts = [];
  bool showCalendar = false;

  @override
  void initState() {
    super.initState();
    fetchRecentPosts();
  }

  Future<void> fetchRecentPosts() async {
    BulletinBoardScreen bulletinBoardScreen = BulletinBoardScreen();
    final fetchedRecentPosts = bulletinBoardScreen.createState().getRecentPosts();

    setState(() {
      recentPosts = fetchedRecentPosts;
    });
  }

  void _updatePost(Post updatedPost) {
    setState(() {
      int index = recentPosts.indexWhere((post) => post.id == updatedPost.id);
      if (index != -1) {
        recentPosts[index] = updatedPost;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(userProfile), // userProfile 사용
                _buildScheduleSection(),
                SizedBox(height: 16), // 수업카드와 아이콘 사이의 간격
                _buildIconSection(context),
                Divider(color: Color(0xFF8A50CE)), // 아이콘 섹션과 게시판 섹션 구분
                Text(
                  '학사일정',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: SvgPicture.asset(
                    'assets/academic_calendar.svg', // 정확한 파일명 사용
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16), // 학사일정과 게시판 사이의 간격
                Divider(color: Color(0xFF8A50CE)), // 학사일정과 게시판 사이의 구분
                _buildNoticeBoardSection(context),
                if (showCalendar) _buildSvgCalendar(), // showCalendar 상태에 따라 주간 시간표 SVG 표시
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildUserInfo(UserProfile userProfile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userProfile.userName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          userProfile.department,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 16),
        Divider(color: Color(0xFF8A50CE)),
      ],
    );
  }

  Widget _buildScheduleSection() {
    final todaySchedule = [
      {
        'time': '10:00 - 12:00',
        'subject': '프로그래밍실습',
        'room': '090517',
        'color': '0xffE86AA7',
      },
      {
        'time': '13:00 - 15:00',
        'subject': '웹스크립밍프로그래밍',
        'room': '060114',
        'color': '0xffF7BF12',
      },
      {
        'time': '18:00 - 21:00',
        'subject': '캡스톤디자인',
        'room': '090517',
        'color': '0xff54B39B',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '수업',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: todaySchedule.map((item) {
              return Container(
                width: 150,
                margin: EdgeInsets.symmetric(horizontal: 8),
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
                      children: [
                        Text(
                          item['subject']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis, // 여기에서 텍스트 오버플로우 설정
                        ),
                        SizedBox(height: 10),
                        Text(
                          item['room']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          item['time']!,
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
      ],
    );
  }

  Widget _buildIconSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIcon('assets/icons/homepage.svg', '홈페이지', null, () {
            _launchURL('https://www.hannam.ac.kr/kor/main/');
          }),
          _buildIcon('assets/icons/notice.svg', '공지사항', null, () {
            _launchURL('https://www.hannam.ac.kr/kor/guide/guide_02.html');
          }),
          _buildIcon('assets/icons/portal.svg', '포털', null, () {
            _launchURL('https://my.hnu.kr/html/main/sso.html');
          }),
          _buildIcon('assets/icons/timetable.svg', '주간시간표', null, () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%
                        height: MediaQuery.of(context).size.height * 0.6, // 화면 높이의 60%
                        child: _buildSvgCalendar(),
                      )
                  );
                });
          }),
        ],
      ),
    );
  }

  Widget _buildIcon(String assetPath, String label, Color? color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            assetPath,
            width: 40,
            height: 40,
            color: color,
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _buildNoticeBoardSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '최근 게시글',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onTabTapped(2);
              },
              child: Text(
                '더 보기>',
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF8A50CE)),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 1), // Adjust padding for Container
          child: Column(
            children: recentPosts.map((post) {
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0), // Adjust padding for ListTile
                title: Text(
                  post.title,
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                  post.userName,
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  _timeAgo(post.createdAt),
                  style: TextStyle(fontSize: 11),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(
                        post: post,
                        onUpdate: (updatedPost) {
                          setState(() {
                            _updatePost(updatedPost);
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildSvgCalendar() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/pop.svg', // 여기에 사용하는 SVG 파일 경로를 넣어주세요.
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          SvgPicture.asset(
            'assets/icons/alarm.svg',
            width: double.infinity,
            height: 200,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }



  String _timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 1) {
      return '${difference.inSeconds}s';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
