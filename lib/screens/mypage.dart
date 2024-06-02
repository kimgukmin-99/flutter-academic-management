import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:academic_management/screens/image_screen.dart';
import 'package:academic_management/providers/person.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final String userName = userProfile.userName;
  final String department = userProfile.department;
  final String year = "${userProfile.year[0]}학년 ${userProfile.year[2]}학기";
  final String studentId = userProfile.studentId;
  int graduationScore = userProfile.graduationScore;
  final int maxScore = userProfile.maxScore;

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
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8A50CE),
                foregroundColor: Colors.white,
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
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Share Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA2A2FF),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Setting'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA2A2FF),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(),
              Text(
                'Participation Score',
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
              SizedBox(height: 30),
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
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.add),
                          ),
                          SizedBox(height: 5),
                          Text('Add Event'),
                        ],
                      ),
                    );
                  }
                  final event = events[index];
                  return GestureDetector(
                    onTap: () => _viewImage(event['image']!, event['name']!),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(event['image']!),
                        ),
                        SizedBox(height: 5),
                        Text(
                          event['name']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
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

class ImageDetailScreen extends StatelessWidget {
  final String imagePath;
  final String eventName;

  ImageDetailScreen({required this.imagePath, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventName),
      ),
      body: Center(
        child: Image.asset(imagePath),
      ),
    );
  }
}
