import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:academic_management/providers/person.dart';
import 'package:academic_management/screens/image_screen.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final String userName = userProfile.userName;
  final String department = userProfile.department;
  final String year = "${userProfile.year[0]}학년 ${userProfile.year[2]}학기";
  final String studentId = userProfile.studentId;
  int graduationScore = 30;
  final int maxScore = 150;

  final List<Map<String, String>> events = [
    {'name': '신입생 환영회', 'image': 'assets/event1.png'},
    {'name': 'MT', 'image': 'assets/event2.png'},
    {'name': '학술제', 'image': 'assets/event3.png'},
  ];

  File? _selectedImage;
  bool isDeleteMode = false;

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _addEvent(String name, File? image) {
    setState(() {
      events.add({
        'name': name,
        'image': image?.path ?? 'assets/default_event.png',
      });
      _selectedImage = null;
      if (graduationScore + 10 <= maxScore) {
        graduationScore += 10;
      }
    });
    Navigator.of(context).pop();
  }

  void _showAddEventDialog() {
    String eventName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('참여 행사 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: '행사명',
                  labelStyle: TextStyle(color: Colors.grey),
                  floatingLabelStyle: TextStyle(color: Color(0xFF8A50CE)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8A50CE)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                onChanged: (value) {
                  eventName = value;
                },
              ),
              SizedBox(height: 10),
              _selectedImage == null
                  ? TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: _pickImage,
                child: Text('Select Image'),
              )
                  : Image.file(
                _selectedImage!,
                height: 100,
                width: 100,
              ),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                });
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                _addEvent(eventName, _selectedImage);
              },
              child: Text('등록'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8A50CE),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _viewImage(String imagePath, String eventName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDetailScreen(
          imagePath: imagePath,
          eventName: eventName,
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }

  void _removeEvent(int index) {
    setState(() {
      events.removeAt(index);
      if (graduationScore - 10 >= 0) {
        graduationScore -= 10;
      }
    });
  }

  void _onLongPress(int index) {
    setState(() {
      isDeleteMode = true;
    });
  }

  void _onDragEnd() {
    setState(() {
      isDeleteMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile_placeholder.png'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      userName,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      '$department | $year | $studentId',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA2A2FF),
                          foregroundColor: Colors.white,
                          fixedSize: Size(110, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Share'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA2A2FF),
                          foregroundColor: Colors.white,
                          fixedSize: Size(110, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Setting'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA2A2FF),
                          foregroundColor: Colors.white,
                          fixedSize: Size(110, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    '학과 참여 점수',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: graduationScore / maxScore,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA2A2FF)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$graduationScore / $maxScore',
                  ),
                  SizedBox(height: 20),
                  Text(
                    '공지사항',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.announcement),
                    title: Text('새로운 공지가 있습니다.'),
                    onTap: () {},
                  ),
                  SizedBox(height: 20),
                  Text(
                    '학과 행사',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: events.length + 1,
                    itemBuilder: (context, index) {
                      if (index == events.length) {
                        return GestureDetector(
                          onTap: _showAddEventDialog,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[350],
                                child: Icon(Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text('행사 추가'),
                            ],
                          ),
                        );
                      }
                      final event = events[index];
                      return LongPressDraggable<int>(
                        data: index,
                        onDragStarted: () => _onLongPress(index),
                        onDraggableCanceled: (_, __) => _onDragEnd(),
                        onDragEnd: (_) => _onDragEnd(),
                        feedback: Material(
                          color: Colors.transparent,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: _getImageProvider(event['image']!),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => _viewImage(event['image']!, event['name']!),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: _getImageProvider(event['image']!),
                              ),
                              SizedBox(height: 5),
                              Text(
                                event['name']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
            if (isDeleteMode)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: DragTarget<int>(
                  onAccept: (index) {
                    _removeEvent(index);
                    setState(() {
                      isDeleteMode = false;
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.asset(
                        'assets/icons/pop.svg',
                        width: 48,
                        height: 48,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
