import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:academic_management/screens/post_detail_screen.dart';
import 'package:academic_management/screens/bulletin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:academic_management/providers/person.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
                _buildUserInfo(userProfile),
                _buildScheduleSection(),
                SizedBox(height: 16),
                _buildIconSection(context),
                Divider(color: Color(0xFF8A50CE), thickness: 1.0),
                Text(
                  '학사일정',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Center(
                  child: SvgPicture.asset(
                    'assets/academic_calendar.svg',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16),
                Divider(color: Color(0xFF8A50CE), thickness: 1.0),
                _buildNoticeBoardSection(context),
                if (showCalendar) _buildSvgCalendar(),
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
        Divider(color: Color(0xFF8A50CE), thickness: 1.0),
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
        'subject': '웹스크립트프로그래밍',
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
                          overflow: TextOverflow.ellipsis,
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
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/timetable_screen.png',
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.9,
                        ),
                      ),
                      Positioned(
                        bottom: 96,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/pop.svg',
                              width: 48,
                              height: 48,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
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
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 5), // 그림자의 위치 조정
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 컨테이너의 상하좌우 여백 조정
          child: Column(
            children: recentPosts.asMap().entries.map((entry) {
              int index = entry.key;
              Post post = entry.value;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(
                            post: post,
                            onUpdate: _updatePost,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    post.title,
                                    style: TextStyle(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4), // title과 username 사이의 간격 조정
                                  AutoSizeText(
                                    post.userName,
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8), // title과 시간 사이의 간격 조정
                            Align(
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(
                                _timeAgo(post.createdAt),
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (index < recentPosts.length - 1) SizedBox(height: 8), // 마지막 게시글에는 여백 추가 안 함
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSvgCalendar() {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/timetable_screen.svg',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
        ),
        Positioned(
          bottom: 64,
          left: 0,
          right: 0,
          child: Center(
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/pop.svg',
                width: 48,
                height: 48,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
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
