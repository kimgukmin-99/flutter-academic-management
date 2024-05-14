import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:academic_management/screens/image_screen.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  // 사용자 정보를 여기에 추가
  final String userName = '홍길동';
  final String department = '컴퓨터공학과';
  final String year = '3학년';
  final String studentId = '20201234';
  final double graduationProgress = 0.75; // 졸업 퍼센티지 예시 (75%)

  // 학과 행사 목록 예시
  final List<Map<String, String>> events = [
    {'name': '신입생 환영회', 'image': 'assets/event1.png'},
    {'name': 'MT', 'image': 'assets/event2.png'},
    {'name': '학술제', 'image': 'assets/event3.png'},
  ];

  File? _selectedImage;

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
    });
    Navigator.of(context).pop();
  }

  void _showAddEventDialog() {
    String eventName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Event Name'),
                onChanged: (value) {
                  eventName = value;
                },
              ),
              SizedBox(height: 10),
              _selectedImage == null
                  ? TextButton(
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
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                });
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addEvent(eventName, _selectedImage);
              },
              child: Text('Add'),
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
        builder: (context) =>
            ImageDetailScreen(imagePath: imagePath, eventName: eventName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // 화면이 작은 기기에서 스크롤 가능하도록 수정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/profile_placeholder.png'), // 프로필 이미지 경로
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
                    onPressed: () {
                      // Edit profile 기능
                    },
                    child: Text('Edit Profile'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Share profile 기능
                    },
                    child: Text('Share Profile'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Setting 기능
                    },
                    child: Text('Setting'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(),
              Text(
                'Graduation Progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: graduationProgress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 10),
              Text(
                '${(graduationProgress * 100).toStringAsFixed(1)}% completed',
              ),
              SizedBox(height: 30),
              Text(
                '공지사항',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.announcement),
                title: Text('새로운 공지가 있습니다.'),
                onTap: () {
                  // 공지사항 상세 페이지로 이동
                },
              ),
              SizedBox(height: 20),
              Text(
                '학과 행사',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _showAddEventDialog,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.add),
                          ),
                          SizedBox(height: 5),
                          Text('Add Event'),
                        ],
                      ),
                    ),
                    ...events.map((event) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  _viewImage(event['image']!, event['name']!),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    FileImage(File(event['image']!)),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(event['name']!),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
