import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 요소들을 양 끝으로 분배
          children: <Widget>[
            Image.asset(
              'assets/logo.png', // 로고 이미지 파일 경로
              fit: BoxFit.cover,
              height: 40, // 로고의 높이 조정
            ),
            Text('한남대학교'), // 중간에 텍스트 제목이 있으면 이를 추가
            IconButton(
              icon: Icon(Icons.notifications), // 알람 아이콘
              onPressed: () {
                // 알람 아이콘 클릭 이벤트 처리
                print('Notification icon tapped!');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Daily Schedule',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(100),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(100),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Time',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Subject',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Room',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('09:00 - 10:00'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Mathematics'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('101'),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('10:15 - 11:15'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Physics'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('102'),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('11:30 - 12:30'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Chemistry'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('103'),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
